datastructures = {}


local stack_mt = {
	__index = {
		push = function(self, v)
			self.n = self.n+1
			self[self.n] = v
		end,
		pop = function(self)
			local v = self[self.n]
			self[self.n] = nil
			self.n = self.n-1
			return v
		end,
		is_empty = function(self)
			return self.n == 0
		end,
		size = function(self)
			return self.n
		end,
		to_table = function(self)
			local t = {}
			for i = 1, self.n do
				t[i] = self[i]
			end
			return t
		end,
		to_string = function(self, value_tostring)
			if self.n == 0 then
				return "empty stack"
			end
			value_tostring = value_tostring or tostring
			local t = {}
			for i = 1, self.n do
				t[i] = value_tostring(self[i])
			end
			return self.n .. " elements; bottom to top: " ..
				table.concat(t, ", ")
		end,
	}
}

function datastructures.create_stack()
	-- setting the first element to true makes it ~10 times faster with luajit
	-- when the stack always contains less or equal to one element
	local stack = {n = 0, true}
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
				self.source[p] = nil
				self.p_out = p+1
				return v
			end
			-- source is empty, swap it with sink
			self.source, self.sink = self.sink, self.source
			self.n_out = self.n_in
			self.n_in = 0
			local v = self.source[1]
			self.source[1] = nil
			self.p_out = 2
			return v
		end,
		is_empty = function(self)
			return self.n_in == 0 and self.p_out == self.n_out+1
		end,
		size = function(self)
			return self.n_in + self.n_out - self.p_out + 1
		end,
		to_table = function(self)
			local t = {}
			local k = 1
			for i = self.p_out, self.n_out do
				t[k] = self.source[i]
				k = k+1
			end
			for i = 1, self.n_in do
				t[k] = self.sink[i]
				k = k+1
			end
			return t
		end,
		to_string = function(self, value_tostring)
			local size = self:size()
			if size == 0 then
				return "empty fifo"
			end
			value_tostring = value_tostring or tostring
			local t = self:to_table()
			for i = 1, #t do
				t[i] = value_tostring(t[i])
			end
			return size .. " elements; oldest to newest: " ..
				table.concat(t, ", ")
		end,
	}
}

function datastructures.create_fifo()
	local fifo = {n_in = 0, n_out = 0, p_out = 1, sink = {}, source = {}}
	setmetatable(fifo, fifo_mt)
	return fifo
end


local binary_heap_mt = {
	__index = {
		peek = function(self)
			return self[1]
		end,
		add = function(self, v)
			local i = self.n+1
			self.n = i
			self[i] = v
			local p = math.floor(i / 2)
			while p > 0
			and self.compare(self[i], self[p]) do
				-- new data has higher priority than its parent
				self[i], self[p] = self[p], self[i]
				i = p
				p = math.floor(p / 2)
			end
		end,
		take = function(self)
			local v = self[1]
			self[1] = self[self.n]
			self[self.n] = nil
			self.n = self.n-1
			local i = 1
			while true do
				local l = i + i
				local r = l+1
				if l > self.n then
					break
				end
				if r > self.n then
					if self.compare(self[l], self[i]) then
						self[i], self[l] = self[l], self[i]
					end
					break
				end
				local preferred_child =
					self.compare(self[l], self[r]) and l or r
				if not self.compare(self[preferred_child], self[i]) then
					break
				end
				self[i], self[preferred_child] = self[preferred_child], self[i]
				i = preferred_child
			end
			return v
		end,
		-- merge and decrease-key is not yet implemented
		is_empty = function(self)
			return self.n == 0
		end,
		size = function(self)
			return self.n
		end,
		to_table = function(self)
			local t = {}
			for i = 1, self.n do
				t[i] = self[i]
			end
			return t
		end,
		to_string = function(self, value_tostring)
			if self.n == 0 then
				return "empty binary heap"
			end
			value_tostring = value_tostring or tostring
			local t = {}
			for i = 1, self.n do
				t[i] = value_tostring(self[i])
			end
			return self.n .. " elements: " .. table.concat(t, ", ")
		end,
	}
}

function datastructures.create_binary_heap(compare)
	local binary_heap = {compare = compare, n = 0, true}
	setmetatable(binary_heap, binary_heap_mt)
	return binary_heap
end


local pairing_heap_mt = {
	__index = {
		peek = function(self)
			return self.root.data
		end,
		add = function(self, data)
			local node = {
				children = {},
				data = data,
			}
			if self.n == 0 then
				self.root = node
				self.n = 1
				return
			end
			self.n = self.n+1
			if not self.compare(data, self.root.data) then
				-- new data has lower or equal priority than root
				self.root.children[#self.root.children+1] = node
				return
			end
			node.children = {self.root}
			self.root = node
		end,
		take = function(self)
			self.n = self.n-1
			local oldroot = self.root
			local data = oldroot.data
			if self.n == 0 then
				self.root = false
				return data
			end
			oldroot = oldroot.children
			local node = oldroot[#oldroot]
			for i = #oldroot-1, 1, -1 do
				local node2 = oldroot[i]
				if self.compare(node2.data, node.data) then
					-- node2 has higher priority than node
					node, node2 = node2, node
				end
				node.children[#node.children+1] = node2
			end
			self.root = node
			return data
		end,
		-- merge and decrease-key is not yet implemented
		is_empty = function(self)
			return self.n == 0
		end,
		size = function(self)
			return self.n
		end,
		to_table = function(self)
			if self:is_empty() then
				return {}
			end
			local t = {}
			local k = 1
			local bfs_fifo = datastructures.create_fifo()
			bfs_fifo:add(self.root)
			while not bfs_fifo:is_empty() do
				local node = bfs_fifo:take()
				t[k] = node.data
				k = k+1
				for i = 1, #node.children do
					bfs_fifo:add(node.children[i])
				end
			end
			return t
		end,
		to_string = function(self, value_tostring)
			local size = self:size()
			if size == 0 then
				return "empty pairing heap"
			end
			value_tostring = value_tostring or tostring
			local t = {}
			local k = 1
			local dfs_stack = datastructures.create_stack()
			dfs_stack:push{self.root, nil}
			local previous_node
			while not dfs_stack:is_empty() do
				local v = dfs_stack:pop()
				local node = v[1]
				local dfs_parent = v[2]
				if previous_node then
					if previous_node == dfs_parent then
						t[k] = " < "
					else
						t[k] = "; "
					end
					k = k+1
				end
				t[k] = value_tostring(node.data)
				k = k+1
				for i = 1, #node.children do
					dfs_stack:push{node.children[i], node}
				end
				previous_node = node
			end
			return size .. " elements: " .. table.concat(t)
		end,
	}
}

function datastructures.create_pairing_heap(compare)
	local pairing_heap = {compare = compare, n = 0}
	setmetatable(pairing_heap, pairing_heap_mt)
	return pairing_heap
end

--~ datastructures.create_priority_queue = datastructures.create_pairing_heap


dofile(minetest.get_modpath"datastructures" .. "/testing.lua")
