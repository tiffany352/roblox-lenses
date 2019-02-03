local Observable = require(script.Observable)

local query = {}

function query.subscribe(instance, observable)

end

function query.property(name)
	return function(instance)
		return Observable.new(function(setValue)
			setValue(instance[name])

			instance:GetPropertyChangedSignal(name):Connect(function()
				setValue(instance[name])
			end)
		end)
	end
end

function query.firstChild(childName, query)
	return Observable.new(function(setValue)
		local conn
		query:subscribe(function(instance)
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
	end)
end

return query
