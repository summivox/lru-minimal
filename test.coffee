{
  strictEqual: EQ
  deepEqual: DEQ
  throws: ERR
} = require('assert')

{SMap, Lru} = require('./lru-minimal.coffee')

l = new Lru(3)

dump = ->
  arr = []
  l.forEach (k, v) -> arr.push [k, v]
  arr

EQ l.set('a', 1), true
EQ l.set('b', 2), true
EQ l.set('c', 3), true
EQ l.size, 3
EQ l.get('a'), 1
EQ l.has('a'), true
EQ l.get('d'), undefined
EQ l.has('d'), false
EQ l.set('d', 4), true
EQ l.size, 3
DEQ dump(), [['d', 4], ['a', 1], ['c', 3]]
DEQ l.toArray(), [['d', 4], ['a', 1], ['c', 3]]

DEQ l.shift(), ['c', 3]
DEQ dump(), [['d', 4], ['a', 1]]
EQ l.size, 2
EQ l.get('a'), 1
EQ l.get('a'), 1
DEQ l.toArray(), [['a', 1], ['d', 4]]

EQ l.set('e', 55), true
EQ l.set('d', 44), false
DEQ dump(), [['d', 44], ['e', 55], ['a', 1]]
EQ l.set('a', 11), false
DEQ dump(), [['a', 11], ['d', 44], ['e', 55]]
EQ l.set('f', 66), true
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
EQ l.shift(), undefined

EQ l.set('__proto__', ['p']), true
EQ l.set('prototype', {p: 'p'}), true
EQ l.set('hasOwnProperty', -> 'h'), true
do ->
  [[k0, v0], [k1, v1], [k2, v2]] = dump()
  EQ k0, 'hasOwnProperty'
  EQ k1, 'prototype'
  EQ k2, '__proto__'
  EQ v0(), 'h'
  EQ v1.p, 'p'
  EQ v2[0], 'p'

ERR (-> l.set(undefined, 0)), Error
ERR (-> l.get(undefined)), Error
ERR (-> l.has(undefined)), Error
