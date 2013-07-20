Lru = require('./lru-minimal.coffee').Lru

l = new Lru(3)

l.set 'a', 1
l.set 'b', 2
l.set 'c', 3
console.log l.get 'a' # 1
console.log l.get 'd' # undefined
l.set 'd', 4

l.forEach (k, v) -> console.log {k, v} # a, c, d
