local Component = require(script.Parent.Component)
local mount = require(script.Parent.mount)
local unmount = require(script.Parent.unmount)
local getValue = require(script.Parent.getValue)

local GetProperty = Component:extend("GetProperty")

function GetProperty:didMount()
	local instance = self.props.instance
	local key = self.props.key

	self.innerValue = self.continuation(instance[key])
	mount(self.innerValue)

	self.changed = instance:GetPropertyChangedSignal(key):Connect(function()
		unmount(self.innerValue)
		self.innerValue = self.continuation(instance[key])
		mount(self.innerValue)
	end)
end

function GetProperty:willUnmount()
	self.changed:Disconnect()
	unmount(self.innerValue)
end

function GetProperty:render()
	return getValue(self.innerValue)
end
