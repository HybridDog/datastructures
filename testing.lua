--~ if false then
if 1 then
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
	local fifo = datastructures.create_queue()
	print(fifo:to_string())
	fifo:add"first"
	fifo:add"snd"
	print(fifo:to_string())
	print(fifo:take(), fifo:take(), fifo:is_empty(), fifo:size())
	print(fifo:to_string())
	print""

	print"testing binary heap"
	local compar = function(a, b)
		return a < b
	end
	local heap = datastructures.create_binary_heap(compar)
	print("Empty: " .. heap:to_string())
	heap:add(1)
	heap:add(6)
	heap:add(3)
	heap:add(-5)
	print("Some elements added: " .. heap:to_string())
	local heap2 = datastructures.create_binary_heap(compar)
	heap2:add(72)
	heap2:add(1.4)
	heap2:add(4)
	heap2:add(4.5)
	heap2:add(4.4)
	heap2:add(4.5)
	heap2:add(1)
	print("Another heap: " .. heap2:to_string())
	heap:merge(heap2)
	print("After merging: " .. heap:to_string())
	print("take take empty size",
		heap:take(), heap:take(), heap:is_empty(), heap:size())
	print("After taking: " .. heap:to_string())
	heap:sort()
	print("After sorting: " .. table.concat(heap, ", "))
	print""

	print"testing pairing heap"
	local heap = datastructures.create_pairing_heap(compar)
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

if false then
	local fifo = datastructures.create_queue()
	function thous()
		for i = 1,1000 do
			fifo:add(5)
		end
		for i = 1,1000 do
			fifo:take()
		end
	end
	function thous_single()
		for i = 1,1000 do
			fifo:add(5)
			fifo:take()
		end
	end
	function single_multi()
		for j = 1,10000 do
			local fifo = datastructures.create_queue()
			for i = 1,10 do
				fifo:add(5)
				fifo:take()
			end
		end
	end
	--~ local fifo,a,b = {},1,1
	--~ function thous()
	--~ -- local fifo,a,b = {},1,1
		--~ for i = 1,1000 do
			--~ fifo[b] = 5
			--~ b = b+1
		--~ end
		--~ for i = 1,1000 do
			--~ _=fifo[a]
			--~ fifo[a] = nil
			--~ a = a+1
		--~ end
	--~ end
	--~ function thous_single()
	--~ -- local fifo,a,b = {},1,1
		--~ for i = 1,1000 do
			--~ fifo[b] = 5
			--~ b = b+1
			--~ _=fifo[a]
			--~ fifo[a] = nil
			--~ a = a+1
		--~ end
	--~ end
	--~ print("fifo full tsd " .. benchmark_function(thous) .. " s⁻¹")
	--~ print("fifo 1xtsd reuse " .. benchmark_function(thous_single) .. " s⁻¹")
	--~ fifo = datastructures.create_queue()
	--~ fifo,a,b = {},1,1
	--~ print("fifo 1xtsd new " .. benchmark_function(thous_single) .. " s⁻¹")
	print("fifo multi " .. benchmark_function(single_multi) .. " s⁻¹")

	--[[
	with true until 128:
	fifo full tsd 57,286.904521826 s⁻¹
	fifo 1xtsd reuse 269,884.33333333 s⁻¹
	fifo 1xtsd new 269,687.82020812 s⁻¹

	with true until 1:
	fifo full tsd 237,624.66666667 s⁻¹
	fifo 1xtsd reuse 269,899.91003336 s⁻¹
	fifo 1xtsd new 269,249.24358359 s⁻¹

	always nil:
	fifo full tsd 234,458.8436941 s⁻¹
	fifo 1xtsd reuse 268,114.57729514 s⁻¹
	fifo 1xtsd new 267,796 s⁻¹

	always nil, but keep first value:
	fifo full tsd 234,041.43262523 s⁻¹
	fifo 1xtsd reuse 294,292.90190237 s⁻¹
	fifo 1xtsd new 294,202.13719858 s⁻¹

	keep old values:
	fifo full tsd 235,383.76461624 s⁻¹
	fifo 1xtsd reuse 298,366.8010888 s⁻¹
	fifo 1xtsd new 298,613.66666667 s⁻¹

	set sink to empty table on swap
	fifo full tsd 96,857.838570269 s⁻¹
	fifo 1xtsd reuse 8,357.8802037171 s⁻¹
	fifo 1xtsd new 8,439.5737716939 s⁻¹

	set sink to new table {true} on swap
	fifo full tsd 99,955.033468233 s⁻¹
	fifo 1xtsd reuse 17,849.125093541 s⁻¹
	fifo 1xtsd new 17,820.12543187 s⁻¹


	]]
end

if false then
	local N = 10000000
	local data = {true}
	for i = 1, N do
		local r = math.random()
		if r > 0.5 then
			data[i] = false
		else
			data[i] = r
		end
	end
	local compare = function(a, b)
		return a < b
	end

	function test_binary()
		local heap = datastructures.create_binary_heap(compare)
		for i = 1, N do
			if not data[i] then
				if not heap:is_empty() then
					heap:take()
				end
			else
				heap:add(data[i])
			end
		end
	end
	function test_pairing()
		local heap = datastructures.create_pairing_heap(compare)
		for i = 1, N do
			if not data[i] then
				if not heap:is_empty() then
					heap:take()
				end
			else
				heap:add(data[i])
			end
		end
	end
	--~ print("binary heap times " .. benchmark_function(test_binary) .. " s⁻¹")
	--~ print("pairing heap times " .. benchmark_function(test_pairing) .. " s⁻¹")

	function test_binary_singl()
		for j = 1, 10000 do
			local heap = datastructures.create_binary_heap(compare)
			for i = 1, 10 do
				heap:add(5)
				heap:take()
			end
		end
	end
	print("binary heap single times "
		.. benchmark_function(test_binary_singl) .. " s⁻¹")


	--[[
	N=10000, similar speed differences for N=1000 and N=100
	binary heap times 1110.9481557527 s⁻¹
	pairing heap times 329.20198174262 s⁻¹

	binary heap with and without {true} in initialization showed same speed
	]]
end
