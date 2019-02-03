local Component = require(script.Parent.Component)
local mount = require(script.Parent.mount)
local unmount = require(script.Parent.unmount)
local getValue = require(script.Parent.getValue)

local GetChildren = Component:extend("GetChildren")

function GetChildren:didMount()
	self.children = {}

	for _,child in pairs(self.props.instance:GetChildren()) do
		self.children[child] = self.continuation(child)
	end
	mount(self.children, self.onValueChange)

	self.childAdded = self.props.instance.ChildAdded:Connect(function(child)
		self.children[child] = self.continuation(child)
		mount(self.children[child], self.onValueChange)
		self:update()
	end)
	self.childRemoved = self.props.instance.ChildRemoved:Connect(function(child)
		unmount(self.children[child])
		self.children[child] = nil
		self:update()
	end)
end

function GetChildren:willUnmount()
	self.childAdded:Disconnect()
	self.childRemoved:Disconnect()
	unmount(self.children)
end

function GetChildren:render()
	local result = {}
	for _, value in pairs(self.children) do
		result[#result+1] = getValue(value)
	end

	return result
end

return GetChildren
