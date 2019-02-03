local getValue = require(script.Parent.getValue)
local mount = require(script.Parent.mount)
local unmount = require(script.Parent.unmount)
local shallowEquals = require(script.Parent.shallowEquals)

local Component = {}
Component.__index = Component

function Component:extend(name)
	local class = {}
	class.__index = class
	class.__tostring = name

	function class.new(props, continuation)
		local self = {
			value = nil,
			valueChanged = function() end,
			props = props,
			continuation = continuation,
		}
		setmetatable(self, class)

		return self
	end

	setmetatable(class, self)

	return class
end

function Component:mount()
	self:didMount()
	mount(self.value)
	self.value = self:render()
end

function Component:unmount()
	unmount(self.value)
	self:willUnmount()
end

function Component:getValue()
	return getValue(self.value)
end

function Component:update()
	local oldValue = self.value
	local newValue = self:render()

	if not shallowEquals(oldValue, newValue) then
		self.value = newValue
		self.valueChanged()
	end
end

-- Lifecycle methods

function Component:didMount()
end

function Component:willUnmount()
end

function Component:render()
	return nil
end

return Component
