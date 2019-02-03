local function shallowEquals(left, right)
	if left == right then return true end

	if type(left) == 'table' and type(right) == 'table' then
		local countKeys = {}
		for key, value in pairs(left) do
			countKeys[key] = (countKeys[key] or 0) + 1
		end
		for key, value in pairs(right) do
			countKeys[key] = (countKeys[key] or 0) + 1
		end
		for key, value in pairs(countKeys) do
			if value ~= 2 then
				return false
			end
		end

		return true
	end

	return false
end

return shallowEquals
