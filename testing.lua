print"testing stack"
local stack = datastructures.create_stack()
print(dump(stack))
stack:push"first"
stack:push"snd"
print(dump(stack))
print(stack:pop(), stack:pop(), stack:is_empty())
print(dump(stack))
print"\n"

print"testing fifo"
local fifo = datastructures.create_fifo()
print(dump(fifo))
fifo:add"first"
fifo:add"snd"
print(dump(fifo))
print(fifo:take(), fifo:take(), fifo:is_empty())
print(dump(fifo))
print"\n"

