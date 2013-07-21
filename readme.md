# Minimal LRU cache for javascript

This is a bare-bones library written in CoffeeScript.  
Works in both browser and node.js.  
One really short file `lru-minimal.coffee` for your sanity.  

Don't tamper with the internal structure and it should Just Work (TM).  
Comes with a simple testsuite, `test.coffee`.  


## `class SMap`

Simple string-keyed map that correctly handles `__proto__` and friends.

### Methods

Keys are converted to string (using `.toString()`).
Method will throw on invalid key.

`constructor()`  
`clear()`  
`set(key, value)`: insert => `true`, update => `false`  
`get(key)`: found => value, else => `undefined`  
`has(key)`: found => `true`, else => `false`  
`delete(key)`: found & deleted => `true`, else => `false`  
`forEach(cb)`: calls `cb(strKey, value)` for each element  
`toArray()`: returns array of `[key, value]`  
`size`  


## `class Lru`

Similar to `SMap`, but with element count limit.  
Elements inserted into a full `Lru` will replace Least Recently Used element.  

### Methods

`constructor(cap)`: element count limit: `cap`  
`clear()`  
`shift()`: removes and returns LRU element as `[key, value]`  

The rest: same as `SMap`
