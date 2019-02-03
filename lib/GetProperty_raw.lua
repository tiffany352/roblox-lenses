local shallowEquals = require(script.Parent.shallowEquals)
local dispose = require(script.Parent.dispose)
local getValue = require(script.Parent.getValue)

local GetProperty = {}
GetProperty.__index = GetProperty

function GetProperty.new(instance, property, processProperty)
	local self = {
		instance = instance,
		children = {},
		processProperty = processProperty,
		valueChanged = function() end,
	}
	setmetatable(self, GetProperty)

	self.value = self:render()

	self.changed = instance:GetPropertyChangedSignal(property):Connect(function()
		local newValue = self:render()
		local oldValue = self.value

		if not shallowEquals(newValue, oldValue) then
			self.value = newValue
			self.valueChanged()
			dispose(oldValue)
		else
			dispose(newValue)
		end
	end)

	return self
end

function GetProperty:destroy()
	self.changed:Disconnect()
	dispose(self.value)
end

function GetProperty:getValue()
	return getValue(self.value)
end

function GetProperty:render()
	return self.processProperty(self.instance[self.property])
end

return GetProperty
