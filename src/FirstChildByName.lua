local Component = require(script.Parent.Component)
local getValue = require(script.Parent.getValue)

local FirstChildByName = Component:extend("FirstChildByName")

function FirstChildByName:didMount()
	self.child = self.props.instance:FindFirstChild(self.props.name)

	self.children = {
		value = self.continuation(self.child)
	}

	self.childAdded = self.props.instance.ChildAdded:Connect(function(child)
		if not self.child and child.Name == self.props.name then
			self.child = child
			self:setChild("value", self.continuation(self.child))
		end
	end)

	self.childRemoved = self.props.instance.ChildRemoved:Connect(function(child)
		if child == self.child then
			self.child = self.props.instance:FindFirstChild(self.props.name)
			self:setChild("value", self.continuation(self.child))
		end
	end)
end

function FirstChildByName:willUnmount()
	self.childAdded:Disconnect()
	self.childRemoved:Disconnect()
end

function FirstChildByName:render()
	return getValue(self.children.value)
end

return FirstChildByName
