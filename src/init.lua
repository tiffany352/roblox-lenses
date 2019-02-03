local Component = require(script.Component)
local GetChildren = require(script.GetInstanceChildren)
local GetChildMap = require(script.GetChildMap)
local GetProperty = require(script.GetProperty)
local mount = require(script.mount)
local unmount = require(script.unmount)
local shallowEquals = require(script.shallowEquals)
local getValue = require(script.getValue)

local Lenses = {}
Lenses.Component = Component
Lenses.GetChildren = GetChildren
Lenses.GetChildMap = GetChildMap
Lenses.GetProperty = GetProperty
Lenses.mount = mount
Lenses.unmount = unmount
Lenses.shallowEquals = shallowEquals
Lenses.getValue = getValue

return Lenses
