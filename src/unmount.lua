local function unmount(object)
	if type(object) == 'table' and object.unmount then
		object:unmount()
		object.valueChanged = nil
	elseif type(object) == 'table' then
		for key, value in pairs(object) do
			unmount(value)
		end
	else
		return object
	end
end

return unmount
