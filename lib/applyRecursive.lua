local function applyRecursive(object, func)
	if type(object) == 'table' then
		local result = func(object)
		if result ~= nil then
			return result
		end
	end

	if type(object) == 'table' then
		for key, value in pairs(object) do
			applyRecursive(value)
		end
	else
		return object
	end
end

return applyRecursive
