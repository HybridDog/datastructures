print"testing stack"
local stack = datastructures.create_stack()
print(stack:to_string())
stack:push"first"
stack:push"snd"
print(stack:to_string())
print(stack:pop(), stack:pop(), stack:is_empty(), stack:size())
print(stack:to_string())
print"\n"

print"testing fifo"
local fifo = datastructures.create_fifo()
print(fifo:to_string())
fifo:add"first"
fifo:add"snd"
print(fifo:to_string())
print(fifo:take(), fifo:take(), fifo:is_empty(), fifo:size())
print(fifo:to_string())
print"\n"

