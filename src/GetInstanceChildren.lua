local Component = require(script.Parent.Component)
local getValue = require(script.Parent.getValue)

local GetChildren = Component:extend("GetChildren")

function GetChildren:didMount()
	self.children = {}
	for _,child in pairs(self.props.instance:GetChildren()) do
		self.children[child] = self.continuation(child)
	end

	self.childAdded = self.props.instance.ChildAdded:Connect(function(child)
		self:setChild(child, self.continuation(child))
	end)
	self.childRemoved = self.props.instance.ChildRemoved:Connect(function(child)
		self:setChild(child, nil)
	end)
end

function GetChildren:willUnmount()
	self.childAdded:Disconnect()
	self.childRemoved:Disconnect()
end

function GetChildren:render()
	local result = {}
	for _, value in pairs(self.children) do
		result[#result+1] = getValue(value)
	end

	return result
end

return GetChildren
