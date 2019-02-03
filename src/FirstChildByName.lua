local Component = require(script.Parent.Component)
local mount = require(script.Parent.mount)
local unmount = require(script.Parent.unmount)
local getValue = require(script.Parent.getValue)

local FirstChildByName = Component:extend("FirstChildByName")

function FirstChildByName:didMount()
	self.child = self.props.instance:FindFirstChild(self.props.name)
	self.innerValue = self.continuation(self.child)
	mount(self.innerValue, self.onValueChange)

	self.childAdded = self.props.instance.ChildAdded:Connect(function(child)
		if not self.child and child.Name == self.props.name then
			self.child = child
			unmount(self.innerValue)
			self.innerValue = self.continuation(self.child)
			mount(self.innerValue, self.onValueChange)
			self:update()
		end
	end)

	self.childRemoved = self.props.instance.ChildRemoved:Connect(function(child)
		if child == self.child then
			unmount(self.innerValue)
			self.child = self.props.instance:FindFirstChild(self.props.name)
			self.innerValue = self.continuation(self.child)
			mount(self.innerValue, self.onValueChange)
			self:update()
		end
	end)
end

function FirstChildByName:willUnmount()
	self.childAdded:Disconnect()
	self.childRemoved:Disconnect()
	unmount(self.innerValue)
end

function FirstChildByName:render()
	return getValue(self.innerValue)
end

return FirstChildByName
