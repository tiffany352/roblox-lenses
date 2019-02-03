# Roblox Lenses

**This is a prototype, and is not intended to be production ready. Use
at your own risk!**

This is a library for easily defining mappings from a DataModel
hierarchy, into a table shaped however you like. You can think of it
like GraphQL or like the inverse of Roact/React.

This library has the power to replace hundreds of lines of error prone
manual synchronization code with a few dozen lines of straightforward
queries. For example:

```lua
local lens = Lenses.FirstChildByName.new({
    instance = game:GetService("ReplicatedStorage"),
    name = "TagList",
}, function(tagList)
    return Lenses.GetChildMap.new({
        instance = tagList,
    }, function(tag)
        return Lenses.GetChildMap.new({
            instance = tag,
        }, function(prop)
            return Lenses.GetProperty.new({
                instance = prop,
                key = "Value",
            })
        end)
    end)
end)

lens:mount()

local result = lens:getValue()
lens.valueChanged = function()
    result = lens:getValue()
    -- do stuff
end
```
