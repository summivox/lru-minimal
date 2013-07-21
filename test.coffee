{
  strictEqual: EQ
  deepEqual: DEQ
} = require('assert')

{SMap, Lru} = require('./lru-minimal.coffee')

l = new Lru(3)

dump = ->
  arr = []
  l.forEach (k, v) -> arr.push [k, v]
  arr

l.set 'a', 1
l.set 'b', 2
l.set 'c', 3
EQ l.size, 3
EQ l.get('a'), 1
EQ l.has('a'), true
EQ l.get('d'), undefined
EQ l.has('d'), false
l.set 'd', 4
EQ l.size, 3
DEQ dump(), [['d', 4], ['a', 1], ['c', 3]]

l.shift()
DEQ dump(), [['d', 4], ['a', 1]]
EQ l.size, 2
EQ l.get('a'), 1
EQ l.get('a'), 1
DEQ dump(), [['a', 1], ['d', 4]]

l.set 'e', 55
l.set 'd', 44
DEQ dump(), [['d', 44], ['e', 55], ['a', 1]]
l.set 'a', 11
DEQ dump(), [['a', 11], ['d', 44], ['e', 55]]
l.set 'f', 66
DEQ dump(), [['f', 66], ['a', 11], ['d', 44]]

DEQ ['a', 'b', 'c', 'd', 'e', 'f'].map((x) -> l.has(x)),
    [true, false, false, true, false, true]

EQ l.delete('b'), false
EQ l.delete('a'), true
EQ l.delete('d'), true
EQ l.size, 1
DEQ dump(), [['f', 66]]

EQ l.delete('f'), true
EQ l.size, 0
DEQ dump(), []
