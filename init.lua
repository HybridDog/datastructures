datastructures = {}


local stack_mt = {
	__index = {
		push = function(self, v)
			local n = self.n+1
			self.n = n
			self[n] = v
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


local fifo_mt = {
	__index = {
		add = function(self, v)
			local n = self.n_in+1
			self.n_in = n
			self.sink[n] = v
		end,
		take = function(self)
			local p = self.p_out
			if p <= self.n_out then
				local v = self.source[p]
				-- a table is only shrunk when a new element is added
				self.source[p] = p <= 128 or nil
				self.p_out = p+1
				return v
			end
			-- source is empty, swap it with sink
			self.source, self.sink = self.sink, self.source
			self.n_out = self.n_in
			self.n_in = 0
			local v = self.source[1]
			self.source[1] = true
			self.p_out = 2
			return v
		end,
		is_empty = function(self)
			return self.n_in == 0 and self.p_out == self.n_out+1
		end,
	}
}

function datastructures.create_fifo()
	local fifo = {n_in = 0, n_out = 0, p_out = 1, sink = {}, source = {}}
	setmetatable(fifo, fifo_mt)
	return fifo
end


dofile(minetest.get_modpath"datastructures" .. "/testing.lua")
