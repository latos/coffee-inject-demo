Injector = require('./lib/inject').Injector

class Foo
  constructor: (@bar) ->
    console.log "Hey I'm here, ", @bar

injector = new Injector null, {bar: 5}, {}

foo1 = new Foo(5)
console.log 'Foo 1: ', foo1

foo2 = injector.instantiate Foo
console.log 'Foo 2: ', foo2
