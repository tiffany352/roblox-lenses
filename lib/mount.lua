local function mount(object)
	if type(object) == 'table' and object.mount then
		object:mount()
	elseif type(object) == 'table' then
		for key, value in pairs(object) do
			mount(value)
		end
	else
		return object
	end
end

return mount
