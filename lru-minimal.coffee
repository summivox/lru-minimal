###!
https://github.com/smilekzs/lru-minimal/

SMap: simple map with arbitrary string as key (properly escaped)
Lru: SMap with element count limit (new element replaces least recently used one)
!###

SMap = do ->
  str = (k) -> k?.toString()
  esc = (s) -> '\0' + s
  unesc = (s) -> s.slice(1)
  bailout = -> throw Error 'SMap: invalid key'

  class SMap
    constructor: -> @clear()
    clear: ->
      @o = {}
      @size = 0
    set: (k, v) ->
      if !(sk = str k)? then bailout()
      ek = esc sk
      ++@size if ret = !(ek of @o)
      @o[ek] = v
      ret
    get: (k) ->
      if !(sk = str k)? then bailout()
      @o[esc sk]
    has: (k) -> @get(k)? 
    delete: (k) ->
      if !(sk = str k)? then bailout()
      ek = esc sk
      if ret = ek of @o
        --@size
        delete @o[ek]
      ret
    forEach: (cb) ->
      for own ek, v of @o
        sk = unesc ek
        cb sk, v
      return

Lru = do ->
  # node: {p(rev), n(ext), k(ey), v(alue)}
  # map: value: reference to node

  # insert `x` between adjacent nodes `p` & `n`
  insert = (p, n, k, v) ->
    link p, n, x = {p, n, k, v}
    x
  link = (p, n, x) ->
    x.p = p
    x.n = n
    p.n = n.p = x
    x

  # remove `x` from linklist
  unlink = (x) ->
    x.p.n = x.n
    x.n.p = x.p
    x

  # move `x` to front
  bump = (x, head) ->
    unlink x
    link head, head.n, x

  class Lru
    constructor: (cap) ->
      @cap = cap
      @clear()
    clear: ->
      @map = new SMap()
      @size = 0
      @head = {p: null, n: null, k: null, v: null}
      @tail = {p: null, n: null, k: null, v: null}
      @head.n = @tail
      @tail.p = @head
    set: (k, v) ->
      if x = @map.get k
        bump x, @head
        x.k = k
        x.v = v
        return false
      else
        if @map.size >= @cap then @shift()
        x = insert @head, @head.n, k, v
        @map.set k, x
        @size = @map.size
        return true
    get: (k) ->
      if x = @map.get k
        bump x, @head
        return x.v
    has: (k) -> @get(k)?
    delete: (k) ->
      if x = @map.get k
        unlink x
        @map.delete k
        return true
      else
        return false
    shift: ->
      x = @tail.p
      if !x.p then return false
      unlink x
      @map.delete x.k
      @size = @map.size
      return true
    forEach: (cb) ->
      @map.forEach (_, x) ->
        cb x.k, x.v

for exp in [this.window, module?.exports]
  if exp
    exp.SMap = SMap
    exp.Lru = Lru
