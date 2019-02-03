-- first iteration

-- class Observable<T>
--   function new(func: function(setValue: function(value: T) -> void) -> void) -> Observable<T>
--   value: T
--   function andThen<U>(self, func: function(value: T) -> Observable<U>) -> Observable<U>

-- function firstChild(instance: Instance, childName: string) -> Observable<Instance>
-- function children(instance: Instance) -> Observable<Instance[]>
-- function join<T>(list: Observable<T>[]) -> Observable<T[]>
-- function childrenWhichAre(child: Instance, className: string) -> Observable<Instance[]>
-- function property<T>(instance: Instance, propName: string) -> Observable<T>
-- function Array.map<T, U>(array: T[], func: function(value: T) -> U) -> U[]

firstChild(ServerStorage, "TagList"):andThen(function(tagList)
	return children(tagList):andThen(function(children)
		return join(Array.map(children, function(child)
			return childrenWhichAre(child, "ValueBase"):andThen(function(values)
				return join(Array.map(values, function(value)
					return property(value, "Value")
				end))
			end)
		end))
	end)
end)

-- second iteration
query(ServerStorage)
	:firstChild("TagList")
	:children()
	:map(function(child) return query(child)
		:childrenWhichAre("ValueBase")
		:map(function(value) return query(value)
			:property("Value")
		end)
	end)

-- third iteration
query.subscribe(ServerStorage, query.firstChild("TagList", {
	[query.name] = query.children({
		[query.name] = query.childrenOfClass("ValueBase", query.property("Value"))
	})
}))

-- fourth iteration
query.new(ServerStorage):firstChild("TagList"):childrenWithKey("Name", function(child)
	return child:childrenWithKey("Name", function(value)
		return value:property("Value")
	end)
end)
