
_ = require 'lodash'

{createModelCache} = require './property-utils'

parse = JSON.parse

jsonGetter = module.exports = (propName, options) ->
  ## Getter
  customGetter = options?.get
  delete options?.get
  getter = ->
    cache = createModelCache @, propName

    if cache.deserialized
      return cache.deserialized

    model = @
    cache.deserialized = parse @getDataValue(propName)

    if customGetter
      cache.deserialized = customGetter.call @, cache.deserialized

    return cache.deserialized

  ## Setter
  customSetter = options?.set
  delete options?.set
  setter = (value) ->
    if customSetter
      value = customSetter.call @, value

    unless _.isUndefined(value)
      value = JSON.stringify value, null, 2

    cache = createModelCache @, propName
    delete cache.deserialized

    @setDataValue propName, value

  _.extend
    type: 'LONGTEXT'
    get: getter
    set: setter
  , options
