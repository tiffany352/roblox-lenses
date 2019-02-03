local Component = require(script.Parent.Component)
local getValue = require(script.Parent.getValue)

local GetProperty = Component:extend("GetProperty")

function GetProperty:didMount()
	local instance = self.props.instance
	local key = self.props.key

	self.children = {
		value = self.continuation(instance[key])
	}

	self.changed = instance:GetPropertyChangedSignal(key):Connect(function()
		self:setChild("value", self.continuation(instance[key]))
	end)
end

function GetProperty:willUnmount()
	self.changed:Disconnect()
end

function GetProperty:render()
	return getValue(self.children.value)
end

return GetProperty
