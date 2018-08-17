if false then
	print"testing stack"
	local stack = datastructures.create_stack()
	print(stack:to_string())
	stack:push"first"
	stack:push"snd"
	print(stack:to_string())
	print(stack:pop(), stack:pop(), stack:is_empty(), stack:size())
	print(stack:to_string())
	print""

	print"testing fifo"
	local fifo = datastructures.create_fifo()
	print(fifo:to_string())
	fifo:add"first"
	fifo:add"snd"
	print(fifo:to_string())
	print(fifo:take(), fifo:take(), fifo:is_empty(), fifo:size())
	print(fifo:to_string())
	print""

	print"testing pairing heap"
	local heap = datastructures.create_pairing_heap(function(a, b)
		return b - a
	end)
	print(heap:to_string())
	heap:add(1)
	heap:add(6)
	heap:add(3)
	heap:add(-5)
	print(heap:to_string())
	print(heap:take(), heap:take(), heap:is_empty(), heap:size())
	print(heap:to_string())
	print""
end


local TIME = 3

local clock = minetest.get_us_time
--~ local clock = os.clock
local us = TIME * 1000000
--~ local us = TIME
local function benchmark_function(fct, ...)
	local start = clock()
	local fin = start
	local total = 0
	while fin - start < us do
		fct(...)

		total = total + 1
		fin = clock()
	end
	--~ return total / (fin - start)
	return total * 1000000 / (fin - start)
end

if false then
	local stack = datastructures.create_stack()
	function stackth()
		for i = 1,1000 do
			stack:push(5)
		end
		for i = 1,1000 do
			stack:pop()
		end
	end
	function stacksin()
		for i = 1,1000 do
			stack:push(5)
			stack:pop()
		end
	end
	--~ local stack,n = {},0
	--~ function stackth()
		--~ for i = 1,1000 do
			--~ n = n+1
			--~ stack[n] = 5
		--~ end
		--~ for i = 1,1000 do
			--~ _=stack[n]
			--~ n = n-1
		--~ end
	--~ end
	--~ function stacksin()
		--~ for i = 1,1000 do
			--~ n = n+1
			--~ stack[n] = 5
			--~ _=stack[n]
			--~ n = n-1
		--~ end
	--~ end
	print("stack full tsd " .. benchmark_function(stackth) .. " s⁻¹")
	print("stack 1xtsd reuse " .. benchmark_function(stacksin) .. " s⁻¹")
	stack = datastructures.create_stack()
	--~ stack,n = {},n
	print("stack 1xtsd new " .. benchmark_function(stacksin) .. " s⁻¹")

	--[[ with true between 1 and 128, else nil:
	stack full tsd 171,458.21902785 s⁻¹
	stack 1xtsd reuse 278,928.33333333 s⁻¹
	stack 1xtsd new 30,549.786151497 s⁻¹

	with nil everywhere:
	stack full tsd 244,866.83675544 s⁻¹
	stack 1xtsd reuse 288,896.23703459 s⁻¹
	stack 1xtsd new 30,106.959857387 s⁻¹

	without removal on pop:
	stack full tsd 242,467.17168855 s⁻¹
	stack 1xtsd reuse 288,799.8074668 s⁻¹
	stack 1xtsd new 31,744.100543263 s⁻¹

	without removal, direct implemented:
	stack full tsd 225,525.84964943 s⁻¹
	stack 1xtsd reuse 289,465.66666667 s⁻¹
	stack 1xtsd new 288,730.47417968 s⁻¹

	without removal, direct implemented but with metatable:
	stack full tsd 233,457.17769521 s⁻¹
	stack 1xtsd reuse 289,884.33333333 s⁻¹
	stack 1xtsd new 66,182.622544918 s⁻¹

	without removal, direct implemented but with metatable and
	first element initialized to true:
	stack full tsd 235,532.92013581 s⁻¹
	stack 1xtsd reuse 288,725.66666667 s⁻¹
	stack 1xtsd new 289,091.90363603 s⁻¹

	with nil everywhere, first element initialized to true:
	stack full tsd 243,480.42318624 s⁻¹
	stack 1xtsd reuse 288,056.14129591 s⁻¹
	stack 1xtsd new 288,496.66666667 s⁻¹

	with true between 1 and 128, else nil, first element initialized to true:
	stack full tsd 170,962.71506214 s⁻¹
	stack 1xtsd reuse 276,628.39003828 s⁻¹
	stack 1xtsd new 278,323.24055892 s⁻¹


	without luajit, Lua 5.1.5 (Lua 5.3 showed almost the same results):

	with true between 1 and 128, else nil, first element initialized to true:
	stack full tsd 5292.3826421315 s⁻¹
	stack 1xtsd reuse 4885.5087018853 s⁻¹
	stack 1xtsd new 4884.9446372941 s⁻¹

	with nil everywhere, first element initialized to true:
	stack full tsd 5525.8121223878 s⁻¹
	stack 1xtsd reuse 5104.9710718306 s⁻¹
	stack 1xtsd new 5090.1789312391 s⁻¹

	with nil everywhere:
	stack full tsd 5537.548532298 s⁻¹
	stack 1xtsd reuse 5043.5607518909 s⁻¹
	stack 1xtsd new 5082.0741475518 s⁻¹

	without removal, direct implemented:
	stack full tsd 14,432.358776346 s⁻¹
	stack 1xtsd reuse 15,773.377488079 s⁻¹
	stack 1xtsd new 15,820.841791582 s⁻¹

	]]
end
