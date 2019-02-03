local Observable = {}
Observable.__index = Observable

function Observable.new(func)
	local self = {
		value = nil,
		onChanged = {},
	}
	setmetatable(self, Observable)

	local function setValue(newValue)
		if self.value ~= newValue then
			self.value = newValue
			for func in self.onChanged do
				func(self.value)
			end
		end
	end

	func(setValue)

	return self
end

function Observable.once(value)
	return Observable.new(function(setValue)
		setValue(value)
	end)
end

local function set(array, index, value)
	local newArray = {}

	for key, oldValue in pairs(array) do
		newArray[key] = oldValue
	end
	newArray[index] = value

	return newArray
end

function Observable.join(array)
	return Observable.new(function(setValue)
		local result = {}
		for key, observable in pairs(array) do
			result[key] = observable.value
			observable:subscribe(function(newValue)
				result = set(result, key, newValue)
				setValue(result)
			end)
		end
		setValue(result)
	end)
end

function Observable:subscribe(func)
	self.onChanged[func] = true

	func(self.value)

	local function unsubscribe()
		self.onChanged[func] = nil
	end

	return unsubscribe
end

function Observable:andThen(func)
	return Observable.new(function(setValue)
		self:subscribe(function(value)
			func(value):subscribe(setValue)
		end)
	end)
end

return Observable
