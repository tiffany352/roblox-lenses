local FirstChild = {}
FirstChild.__index = FirstChild

function FirstChild.new(setValue, instance, childName)
	local self = {
		instance = instance,
		childName = childName,
		setValue = setValue,
	}
	setmetatable(self, FirstChild)

	self.childAddedConn = instance.ChildAdded:Connect(function(child)
		self:childAdded(child)
	end)
	self.childRemovedConn = instance.ChildRemoved:Connect(function(child)
		self:childRemoved(child)
	end)

	return self
end

function FirstChild:destroy()
	self.childAddedConn:Disconnect()
	self.childRemovedConn:Disconnect()
end

function FirstChild:childAdded(child)
	if not self.value and child.Name == self.childName then
		self.value = child
		self.setValue(self.value)
	end
end

function FirstChild:childRemoved(child)
	if self.value == child then
		self.value = self.instance:FindFirstChild(self.childName)
		self.setValue(self.value)
	end
end

return FirstChild
