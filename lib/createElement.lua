local function createElement(component, props, children)
	props.children = props.children or children or {}
	return {
		component = component,
		props = props,
	}
end

return createElement
