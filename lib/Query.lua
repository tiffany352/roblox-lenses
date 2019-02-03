local Observable = require(script.Parent.Observable)

local Query = {}
Query.__index = Query

function Query.new(observable)
	local self = {
		observable = observable,
	}
	setmetatable(self, Query)
	return self
end

function Query:fromInstance(instance)
	return Query.new(Observable.new(function(setValue)
		setValue(instance)
	end))
end

function Query:map(func)
	return Query.new(Observable.new(function(setValue)
		self.observable:subscribe(function(array)
			local result = {}
			for key, value in pairs(array) do
				result[key] = func(value)
			end
			Observable.join(result):subscribe(setValue)
		end)
	end))
end

function Query:firstChild(childName)
	return Query.new(Observable.new(function(setValue)
		local conn
		self.observable:subscribe(function(instance)
			setValue(instance:FindFirstChild(childName))

			if conn then
				conn:Disconnect()
			end
			conn = instance.ChildAdded:Connect(function(child)
				if child.Name == childName then
					setValue(child)
					conn:Disconnect()
				end
			end)
		end)
	end))
end

return Query
