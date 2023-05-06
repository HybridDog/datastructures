# Datastructures API Documentation

To use the datastructures in a lua program inside a git repository,
I recommend to add the files with `git subtree`, for example:
```
git subtree add --squash --prefix=datastructures git@github.com:HybridDog/datastructures.git master
```
You may need to change the prefix to some subdirectory,
or change the datastructures repository url if you want to use some fork of
this repository. <br/>
After adding the subtree, datastructures can be imported with dofile:
```lua
local path = […]
local datastructures = dofile(path .. "/datastructures/datastructures.lua")
```

The code is written to be fast, so there are no tests for invalid arguments
in `datastructures.lua`.
For development or testing, the `datastructures_debug.lua` file can be used.
It adds assertations to the methods so that e.g. pop cannot be executed on an
empty stack.
```lua
local path = […]
datastructures_path_prefix = path .. "/"
local datastructures = dofile(path .. "/datastructures/datastructures_debug.lua")
```


## Datastructures

### Stack

#### Initialization

* `datastructures.Stack()` returns an empty LIFO queue.
* To initialize a stack from given data, a table can be passed whose
  `input` field is changed to be a stack, the `n` field can be used to
  explicitly pass the stack size, e.g.
  `datastructures.Stack({input = mytable})` changes `mytable`
  into a stack.


#### Methods

* `push(v)`: pushes the value `v` onto the stack; it can be `nil`
* `pop()`: removes the top element from the stack and returns it
* `top()`: returns the top element of the stack
* `get(i)`: returns an element of the stack
  If `i` is negative, it returns the `-i+1`th element from the top;
  if `i` is positive, it returns the `i`th element from the bottom
* `is_empty()`: returns a boolean which is true iff the stack is empty
* `size()`: returns the number of elements
* `clone([copy_element])`: returns a duplicate of the stack
  `copy_element` is an optional function used to duplicate the elements.
* `to_table()`: returns a table and the number of elements
  the top element of the stack is the last element in the returned table
* `to_string([value_tostring])`: returns a string for debugging
  `value_tostring` is an optional function for converting an element to a
  string, `tostring` is used if it is omitted


### FIFO queue

#### Initialization

* `datastructures.Queue()` returns an empty FIFO queue.
* To initialize a queue with given data, a table can be passed whose
  `input` field containing the data is internally reused,
  the `n` field can be used to explicitly pass the queue size, e.g.
  `datastructures.Queue({input = mytable})` returns a FIFO queue and
  `mytable` should no longer be used for other purposes.


#### Methods

* `add(v)`: adds `v` to the queue, it can be `nil`
* `take()`: removes the oldest element from the queue and returns it
* `peek()`: returns the oldest element from the queue
* `is_empty()`: returns a boolean which is true iff the queue is empty
* `size()`: returns the number of elements
* `clone([copy_element])`: returns a duplicate of the queue
  `copy_element` is an optional function used to duplicate the elements.
* `to_table()`: returns a table and the number of elements
  The oldest element of the queue is the first element in the returned
  table.
* `to_string([value_tostring])`: returns a string for debugging
  `value_tostring` is an optional function for converting an element to a
  string, `tostring` is used if it is omitted.


### Implicit Binary Heap

An implementation of a Pairing Heap is available in another branch.
Testing has shown that the Binary Heap is ca. 3.6 times as fast as the Pairing
Heap in practice,
probably due to less table allocations,
so there is only a Binary Heap for now.

#### Initialization

* `datastructures.BinaryHeap(compare)` returns an empty binary heap.
* To initialize a binary heap with given data, a table can be passed whose
  `input` field is changed into a binary heap,
  the `input_sorted` field should be set to true if `input` is sorted,
  the `compare` field contains the comparison function
  and the `n` field can be used to explicitly pass the size.
* The compare function takes two elements as arguments;
  it should return true if the first one has a higher priority than the
  second one; if the priority is the same or less, false should be returned


#### Methods

* `peek()`: returns an element with the highest priority
* `add(v)`: adds `v` to the priority queue
* `take()`: takes the element with highest priority from the heap
* `find(cond)`: returns the current index of an element `e` where `cond(e)`
  returns true; nil is returned if no element is found
  The found index likely becomes invalid once the heap is changed by,
  for example, the add or take method.
* `change_element(v[, i])`: changes the element in the given index to `v`
  The element with the highest priority is changed if `i` is omitted.
  This method can be used to change an element's priority.
* `merge(other)`: adds all elements from the binary heap `other`
* `is_empty()`: returns a boolean which is true iff the heap is empty
* `size()`: returns the number of elements
* `clone([copy_element])`: returns a duplicate of the binary heap
  `copy_element` is an optional function used to duplicate the elements.
* `to_table()`: returns a table and the number of elements
  An element with the highest priority is the first element in the returned
  table.
* `sort()`: changes the binary heap into a sorted table (heap sort)
  The last element of the table has the highest priority.
* `to_string([value_tostring])`: returns a string for debugging
  `value_tostring` is an optional function for converting an element to a
  string, `tostring` is used if it is omitted.
