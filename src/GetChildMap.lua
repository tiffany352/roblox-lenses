local Component = require(script.Parent.Component)
local GetChildren = require(script.Parent.GetInstanceChildren)
local GetProperty = require(script.Parent.GetProperty)
local mount = require(script.Parent.mount)
local unmount = require(script.Parent.unmount)
local getValue = require(script.Parent.getValue)

local GetChildMap = Component:extend("GetChildMap")

function GetChildMap:didMount()
	self.getChildren = GetChildren.new({
		instance = self.props.instance,
	}, function(instance)
		return {
			name = GetProperty.new({
				instance = instance,
				key = "Name",
			}),
			value = self.continuation(instance)
		}
	end)
	mount(self.getChildren, self.onValueChange)
end

function GetChildMap:willUnmount()
	unmount(self.getChildren)
end

function GetChildMap:render()
	local children = getValue(self.getChildren)

	local result = {}
	for _,child in pairs(children) do
		result[child.name] = getValue(child.value)
	end

	return result
end

return GetChildMap
