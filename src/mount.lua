local function mount(object, valueChanged)
	if type(object) == 'table' and object.mount then
		object:mount()
		object.valueChanged = valueChanged
	elseif type(object) == 'table' then
		for key, value in pairs(object) do
			mount(value, valueChanged)
		end
	else
		return object
	end
end

return mount
