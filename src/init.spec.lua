return function()
	local Lenses = require(script.Parent)

	it("should work", function()
		local folder = Instance.new("Folder")

		local obj1 = Instance.new("StringValue")
		obj1.Name = "Obj1"
		obj1.Value = "asdf"
		obj1.Parent = folder

		local lens = Lenses.GetChildren.new({
			instance = folder,
		}, function(instance)
			return Lenses.GetProperty.new({
				instance = instance,
				key = "Value",
			}, function(str)
				return str .. " world"
			end)
		end)

		lens:mount()
		local result = lens:render()
		expect(result).to.be.a('table')
		expect(#result).to.equal(1)
		expect(result[1]).to.equal("asdf world")

		local spyRan = false
		lens.valueChanged = function()
			local result = lens:render()
			expect(result).to.be.a('table')
			expect(#result).to.equal(2)
			expect(result[2]).to.equal("foo world")
			spyRan = true
		end

		local obj2 = Instance.new("StringValue")
		obj2.Name = "Obj2"
		obj2.Value = "foo"
		obj2.Parent = folder

		expect(spyRan).to.equal(true)

		spyRan = false
		lens.valueChanged = function()
			local result = lens:render()
			expect(result).to.be.a('table')
			expect(#result).to.equal(2)
			expect(result[2]).to.equal("bar world")
			spyRan = true
		end

		obj2.Value = "bar"
		expect(spyRan).to.equal(true)

		lens:unmount()
	end)

	it("should work with GetChildMap", function()
		local folder = Instance.new("Folder")

		local obj1 = Instance.new("StringValue")
		obj1.Name = "Obj1"
		obj1.Value = "asdf"
		obj1.Parent = folder

		local lens = Lenses.GetChildMap.new({
			instance = folder,
		}, function(instance)
			return Lenses.GetProperty.new({
				instance = instance,
				key = "Value",
			}, function(str)
				return str .. " world"
			end)
		end)

		lens:mount()
		local result = lens:render()
		expect(result).to.be.a('table')
		expect(result.Obj1).to.equal("asdf world")

		local spyRan = false
		lens.valueChanged = function()
			local result = lens:render()
			expect(result).to.be.a('table')
			expect(result.Obj2).to.equal("foo world")
			spyRan = true
		end

		local obj2 = Instance.new("StringValue")
		obj2.Name = "Obj2"
		obj2.Value = "foo"
		obj2.Parent = folder

		expect(spyRan).to.equal(true)

		spyRan = false
		lens.valueChanged = function()
			local result = lens:render()
			expect(result).to.be.a('table')
			expect(result.Obj2).to.equal("bar world")
			spyRan = true
		end

		obj2.Value = "bar"
		expect(spyRan).to.equal(true)

		lens:unmount()
	end)
end
