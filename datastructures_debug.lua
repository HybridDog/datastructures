-- This adds assertations to various datastructures methods for debugging

assert(datastructures_path_prefix, "A global \"datastructures_path_prefix\" " ..
	"variable has to be specified for the datastructures_debug dofile.")
local datastructures = dofile(datastructures_path_prefix .. "datastructures.lua")


local function is_nan(x)
	return x ~= x
end

local function is_inf(x)
	return x == x + 1.0
end

local function is_int(x)
	return not is_nan(x) and not is_inf(x) and x % 1.0 == 0.0
end

local function is_nonnegative_int(x)
	return is_int(x) and x >= 0
end


local stack_methods = datastructures.Stack.__index
local stack_mt_orig = {}
for name, func in pairs(stack_methods) do
	stack_mt_orig[name] = func
end

local function test_stack_invariant(self)
	assert(is_nonnegative_int(self.n), "Invalid number of stack elements")
end

stack_methods.push = function(self, v)
	test_stack_invariant(self)
	return stack_mt_orig.push(self, v)
end

stack_methods.pop = function(self)
	assert(not self:is_empty(), "Attempt to pop from empty stack")
	local v = stack_mt_orig.pop(self)
	test_stack_invariant(self)
	return v
end

stack_methods.top = function(self)
	assert(not self:is_empty(), "Attempt to get top element from empty stack")
	test_stack_invariant(self)
	return stack_mt_orig.top(self)
end

stack_methods.get = function(self, i)
	assert(not self:is_empty(), "Attempt to get an element from empty stack")
	assert(is_int(i), "Non-integer stack index")
	assert(i <= self.n, "Out of bounds stack index")
	if i <= 0 then
		assert(self.n + i <= self.n, "Out of bounds stack index (from top)")
	end
	test_stack_invariant(self)
	return stack_mt_orig.get(self, i)
end


local fifo_methods = datastructures.Queue.__index
local fifo_mt_orig = {}
for name, func in pairs(fifo_methods) do
	fifo_mt_orig[name] = func
end

local function test_fifo_invariant(self)
	assert(is_nonnegative_int(self.n_in),
		"Invalid number of input table elements")
	assert(is_nonnegative_int(self.n_out),
		"Invalid number of output table elements")
	assert(is_nonnegative_int(self.p_out), "Invalid p_out value")
	assert(type(self.sink) == "table")
	assert(type(self.source) == "table")
end

fifo_methods.add = function(self, v)
	test_fifo_invariant(self)
	return fifo_mt_orig.add(self, v)
end

fifo_methods.take = function(self)
	assert(not self:is_empty(), "Attempt to take from empty queue")
	test_fifo_invariant(self)
	local v = fifo_mt_orig.take(self)
	test_fifo_invariant(self)
	return v
end

fifo_methods.peek = function(self)
	assert(not self:is_empty(),
		"Attempt to get (oldest) element from empty queue")
	test_fifo_invariant(self)
	return fifo_mt_orig.peek(self)
end


local binary_heap_methods = datastructures.BinaryHeap.__index
local binary_heap_mt_orig = {}
for name, func in pairs(binary_heap_methods) do
	binary_heap_mt_orig[name] = func
end

local function test_binary_heap_invariant(self)
	assert(is_nonnegative_int(self.n), "Invalid number of heap elements")
	assert(type(self.compare) == "function", "Invalid comparison function")
end

binary_heap_methods.peek = function(self)
	assert(not self:is_empty(), "Attempt to peek at empty binary heap")
	test_binary_heap_invariant(self)
	return binary_heap_mt_orig.peek(self)
end

binary_heap_methods.add = function(self, v)
	test_binary_heap_invariant(self)
	return binary_heap_mt_orig.add(self, v)
end

binary_heap_methods.take = function(self)
	assert(not self:is_empty(), "Attempt to take from empty binary heap")
	test_binary_heap_invariant(self)
	return binary_heap_mt_orig.take(self)
end

binary_heap_methods.change_element = function(self, v, i)
	assert(not self:is_empty(),
		"Attempt to change an element in an empty binary heap")
	if i ~= nil then
		assert(is_int(i) and i >= 1, "Invalid heap index")
		assert(i < self.n, "Index out of bounds")
	end
	test_binary_heap_invariant(self)
	return binary_heap_mt_orig.change_element(self, v, i)
end


return datastructures
