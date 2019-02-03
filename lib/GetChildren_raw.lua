local getValue = require(script.Parent.getValue)
local dispose = require(script.Parent.dispose)
local shallowEquals = require(script.Parent.shallowEquals)

local GetChildren = {}
GetChildren.__index = GetChildren

function GetChildren.new(instance, processChild)
	local self = {
		instance = instance,
		children = {},
		processChild = processChild,
		value = {},
		valueChanged = function() end,
	}
	setmetatable(self, GetChildren)

	self:render()

	self.childAdded = instance.ChildAdded:Connect(function(child)
		self.children[child] = self.processChild(child)
		self:render()
	end)

	self.childRemoved = instance.ChildRemoved:Connect(function(child)
		self.children[child]:Destroy()
		self.children[child] = nil
		self:render()
	end)

	return self
end

function GetChildren:destroy()
	self.childAdded:Disconnect()
	self.childRemoved:Disconnect()
	dispose(self.value)
end

function GetChildren:getValue()
	return self.value
end

function GetChildren:render()
	local values = {}
	for _,child in pairs(self.children) do
		values[#values+1] = getValue(child)
	end

	local oldValue = self.value
	local newValue = values

	if not shallowEquals(oldValue, newValue) then
		self.value = newValue
		self.valueChanged(newValue)

		dispose(oldValue)
	else
		dispose(newValue)
	end
end

return GetChildren
