local shallowEquals = require(script.Parent.shallowEquals)
local mount = require(script.Parent.mount)
local unmount = require(script.Parent.unmount)
local debugDrawTable = require(script.Parent.debugDrawTable)

local Component = {}
Component.__index = Component

function Component:extend(name)
	local class = {}
	class.__index = class
	class.__classname = name

	function class:__tostring()
		return name
	end

	function class.new(props, continuation)
		local self = {
			value = nil,
			valueChanged = nil,
			props = props,
			children = {},
			continuation = continuation or function(value) return value end,
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
	mount(self.children, self.onValueChange)
	self.value = self:render()
end

function Component:unmount()
	unmount(self.children)
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

function Component:setChild(key, newChild)
	local oldChild = self.children[key]

	if oldChild ~= newChild then
		if oldChild then
			unmount(oldChild)
		end
		self.children[key] = newChild
		if newChild then
			mount(newChild, self.onValueChange)
		end
		self:update()
	end
end

local function mapRecursive(object, func)
	if type(object) == 'table' and object.getValue then
		return func(object)
	elseif type(object) == 'table' then
		local result = {}
		for key, value in pairs(object) do
			result[key] = mapRecursive(value, func)
		end
		return result
	else
		return object
	end
end

function Component:_debugDrawTreeInner()
	return {
		class = self.__classname,
		props = self.props,
		children = mapRecursive(self.children, function(component) return component:_debugDrawTreeInner() end),
		__keyOrder = { "class", "props", "children" },
	}
end

function Component:debugDrawTree()
	return table.concat(debugDrawTable(self:_debugDrawTreeInner()), "\n")
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
