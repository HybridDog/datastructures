datastructures = {}


local stack_mt = {
	__index = {
		push = function(self, v)
			self.n = self.n+1
			self[self.n] = v
		end,
		pop = function(self)
			local n = self.n
			local v = self[n]
			-- fill the lower part of the table that the array part
			-- can't shrink too much in a following push
			self[n] = n <= 128 or nil
			self.n = n-1
			return v
		end,
		is_empty = function(self)
			return self.n == 0
		end,
	}
}

function datastructures.create_stack()
	local stack = {n = 0}
	setmetatable(stack, stack_mt)
	return stack
end



local test = true
if test then
	local stack = datastructures.create_stack()
	print(dump(stack))
	stack:push("first")
	stack:push("snd")
	print(dump(stack))
	print(stack:pop(), stack:pop(), stack:is_empty())
	print(dump(stack))


end
