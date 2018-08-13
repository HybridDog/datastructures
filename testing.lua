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

