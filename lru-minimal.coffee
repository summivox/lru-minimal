###!
https://github.com/smilekzs/lru-minimal/
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
      return
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
    toArray: (cb) ->
      for own ek, v of @o
        sk = unesc ek
        [sk, v]

Lru = do ->
  # node: {p(rev), n(ext), k(ey), v(alue)}
  # map: key -> reference to node

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
        @size = @map.size
        return true
      else
        return false
    shift: ->
      x = @tail.p
      if !x.p then return
      unlink x
      @map.delete x.k
      @size = @map.size
      return [x.k, x.v]
    forEach: (cb) ->
      x = @head.n
      while x.n
        cb x.k, x.v
        x = x.n
    toArray: (cb) ->
      ret = []
      x = @head.n
      while x.n
        ret.push [x.k, x.v]
        x = x.n
      ret

((exp) ->
  exp.SMap = SMap
  exp.Lru = Lru
) switch
    when module?.exports then module.exports
    when window? then window
