Provided data structures
========================

* Stack
	* `datastructures.create_stack()` returns an empty stack.
	* To initialize a stack from given data, a table can be passed whose
	  `input` field is changed to be a stack, the `n` field can be used to
	  explicitly pass the stack size, e.g.
	  `datastructures.create_stack({input = mytable})` changes `mytable`
	  into a stack.
	* Following methods are implemented:
    * `push(v)`: pushes the value `v` onto the stack, it can be `nil`
    * `pop()`: pops an element from the stack
    * `is_empty()`: returns a boolean which is true iff the stack is empty
    * `size()`: returns the number of elements
    * `clone([copy_element])`: returns a duplicate of the stack
	  `copy_element` is an optional function used to duplicate the elements.
    * `to_table()`: returns a table and the number of elements
	  the top element of the stack is the last element in the returned table
    * `to_string([value_tostring])`: returns a string for debugging
	  `value_tostring` is an optional function for converting an element to a
	  string, `tostring` is used if it is omitted
* FIFO queue
	* `datastructures.create_queue()` returns an empty FIFO queue.
	* To initialize a queue with given data, a table can be passed whose
	  `input` field containing the data is internally reused,
	  the `n` field can be used to explicitly pass the queue size, e.g.
	  `datastructures.create_queue({input = mytable})` returns a FIFO queue and
	  `mytable` should no longer be used for other purposes.
	* Following methods are implemented:
    * `add(v)`: adds `v` to the queue, it can be `nil`
    * `take()`: takes an element from the queue
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
* Binary heap
	* `datastructures.create_binary_heap(compare)` returns an empty binary heap.
	* To initialize a binary heap with given data, a table can be passed whose
	  `input` field is changed into a binary heap,
	  the `input_sorted` field should be set to true if `input` is sorted,
	  the `compare` field contains the comparison function
	  and the `n` field can be used to explicitly pass the size.
	* The compare function takes two elements as arguments,
	  it should return true if the first one has a higher priority than the
	  second one, if the priority is the same or less, false should be returned
	* Following methods are implemented:
    * `peek()`: returns an element with the highest priority
    * `add(v)`: adds `v` to the priority queue
    * `take()`: takes the element with highest priority from the heap
    * `find(cond)`: returns the current index of an element `e` where `cond(e)`
	  returns true, nil is returned if no element is found
    * `change_element(v[, i])`: changes the element in the given index to `v`
	  The element with the highest priority is changed if `i` is omitted.
	  This method can be used to change an element's priority.
    * `merge(other)`: adds all elements from the binary heap `other`
    * `is_empty()`: returns a boolean which is true iff the heap is empty
    * `size()`: returns the number of elements
    * `clone([copy_element])`: returns a duplicate of the binary heap
	  `copy_element` is an optional function used to duplicate the elements.
    * `to_table()`: returns a table and the number of elements
	  The element with the highest priority is the first element in the returned
	  table.
    * `sort()`: changes the binary heap into a sorted table (heap sort)
      The last element of the table has the highest priority.
    * `to_string([value_tostring])`: returns a string for debugging
	  `value_tostring` is an optional function for converting an element to a
	  string, `tostring` is used if it is omitted.
