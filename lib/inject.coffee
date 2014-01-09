require('coffee-script')
extend = require('util')._extend

_ = require('underscore')

String.prototype.trim = ->
    return this.replace(/^\s+|\s+$/g, '')

exports.funcParams = funcParams = (func) ->
  mapped = _.map(/\(([\s\S]*?)\)/.exec(func)[1].replace(/\/\*.*\*\//g, '').split(','), ((arg) -> arg.trim()))
  _.filter mapped, (a) -> a

exports.inheritObject = inheritObject = (fromObj) ->
  F = ->
  F.prototype = fromObj
  new F

# Injector with an interface compatible with angular's (currently a subset)
exports.Injector = class Injector
  @providerOfDep = (name) ->
    ($injector) -> $injector.get(name)

  @providerFromCtor = (ctor) ->
    if not ctor
      throw new Error 'ctor required'
    ($injector) -> $injector.instantiate(ctor)

  @mappedProviders = (mappings) ->
    providers = {}
    for k, v of mappings
      providers[k] = Injector.providerOfDep v
    providers
    

  constructor: (@parent, @values, @providers) ->
    @values.$injector = @

  get: (name) ->
    maybeVal = @resolve name
    return maybeVal if maybeVal
    return @parent.get(name) if @parent
    throw new Error('Unresolved dependency: ' + name)

  resolve: (name) ->
    console.log "Resolving: ", name
    return @values[name] if @values.hasOwnProperty(name)
    if @providers[name]
      @values[name] = @invoke @providers[name], null

    @values[name]

  invoke: (func, self = null) ->
    args = _.map funcParams(func), (p) => @get(p)
    func.apply self, args

  instantiate: (ctor) ->
    Dummy = ->
    Dummy.prototype = ctor.prototype

    instance = new Dummy
    @invoke ctor, instance
    instance
    

  child: (values, providers) -> new Injector @, values, providers
