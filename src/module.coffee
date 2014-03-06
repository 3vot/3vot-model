moduleKeywords = ['included', 'extended']


class Module
  @include: (obj) ->
    throw new Error('include(obj) requires obj') unless obj
    for key, value of obj when key not in moduleKeywords
      @::[key] = value
    obj.included?.apply(this)
    this

  @extend: (obj) ->
    throw new Error('extend(obj) requires obj') unless obj
    for key, value of obj when key not in moduleKeywords
      @[key] = value
    obj.extended?.apply(this)
    this

  @proxy: (func) ->
    => func.apply(this, arguments)

  proxy: (func) ->
    => func.apply(this, arguments)

  constructor: ->
    @init?(arguments...)

Module.create = Module.sub = (instances, statics) ->
  class Result extends this
  Result.include(instances) if instances
  Result.extend(statics) if statics
  Result.unbind?()
  Result
  
module.exports = Module