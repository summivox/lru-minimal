// Generated by CoffeeScript 1.6.2
(function() {
  var Lru, l;

  Lru = require('./lru-minimal.coffee').Lru;

  l = new Lru(3);

  l.set('a', 1);

  l.set('b', 2);

  l.set('c', 3);

  console.log(l.get('a'));

  l.set('d', 4);

  l.forEach(function(k, v) {
    return console.log({
      k: k,
      v: v
    });
  });

}).call(this);