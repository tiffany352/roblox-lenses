local function getValue(object)
	if type(object) == 'table' and object.getValue then
		return object:getValue()
	elseif type(object) == 'table' then
		local newTable = {}
		for key, value in pairs(object) do
			newTable[key] = getValue(value)
		end
		return newTable
	else
		return object
	end
end

return getValue
