local shallowEquals = require(script.Parent.shallowEquals)

local Component = {}
Component.__index = Component

function Component:extend(name)
	local class = {}
	class.__index = class

	function class:__tostring()
		return name
	end

	function class.new(props, continuation)
		local self = {
			value = nil,
			valueChanged = nil,
			props = props,
			continuation = continuation,
		}
		setmetatable(self, class)

		self.onValueChange = function()
			self:update()
		end

		return self
	end

	setmetatable(class, self)

	return class
end

function Component:mount()
	self:didMount()
	self.value = self:render()
end

function Component:unmount()
	self:willUnmount()
end

function Component:getValue()
	return self.value
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
