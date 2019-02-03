local function debugDrawTable(t, keys)
	keys = keys or t.__keyOrder
	if not keys then
		keys = {}
		for key in pairs(t) do
			keys[#keys+1] = key
		end
		table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
	end

	local lines = {}
	for i = 1, #keys do
		local last = (i == #keys)
		local key = keys[i]
		local value = t[key]
		key = tostring(key)

		local char = last and "`-" or "|- "

		if type(value) == 'table' then
			lines[#lines+1] = char .. key .. ":"
			local char = last and "   " or "|  "
			for _,line in pairs(debugDrawTable(value)) do
				lines[#lines+1] = char .. line
			end
		else
			lines[#lines+1] = char .. key .. ": " .. tostring(value)
		end
	end
	return lines
end

return debugDrawTable
