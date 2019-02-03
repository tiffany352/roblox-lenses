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

	it("should work with FirstChildByName", function()
		local folder = Instance.new("Folder")
		local child = Instance.new("StringValue")
		child.Name = "ChildName"
		child.Value = "foo"
		child.Parent = folder

		local lens = Lenses.FirstChildByName.new({
			instance = folder,
			name = "ChildName",
		}, function(child)
			return Lenses.GetProperty.new({
				instance = child,
				key = "Value",
			})
		end)
		lens:mount()

		local result = lens:getValue()

		expect(result).to.equal("foo")

		lens:unmount()
	end)

	it("should handle the tag editor format", function()
		local tags = Instance.new("Folder")
		tags.Name = "TagList"

		local door = Instance.new("Folder")
		door.Name = "Door"

		local doorIcon = Instance.new("StringValue")
		doorIcon.Name = "Icon"
		doorIcon.Value = "door"
		doorIcon.Parent = door

		door.Parent = tags

		local computer = Instance.new("Folder")
		computer.Name = "Computer"
		computer.Parent = tags

		tags.Parent = game:GetService("ReplicatedStorage")

		local lens = Lenses.FirstChildByName.new({
			instance = game:GetService("ReplicatedStorage"),
			name = "TagList",
		}, function(tagList)
			return Lenses.GetChildMap.new({
				instance = tagList,
			}, function(tag)
				return Lenses.GetChildMap.new({
					instance = tag,
				}, function(prop)
					return Lenses.GetProperty.new({
						instance = prop,
						key = "Value",
					})
				end)
			end)
		end)
		lens:mount()

		local result = lens:getValue()

		expect(result).to.be.a("table")
		expect(result.Door).to.be.a("table")
		expect(result.Door.Icon).to.be.equal("door")
		expect(result.Computer).to.be.a("table")

		lens:unmount()
		tags:Destroy()
	end)
end
