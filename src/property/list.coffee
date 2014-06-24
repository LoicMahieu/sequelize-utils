
_ = require 'lodash'

{createModelCache} = require './property-utils'

parse = (value, separator) ->
  if !value.length or !_.isFunction(value.split)
    return []
  else
    return value.split separator

listGetter = module.exports = (propName, options) ->
  ## Getter
  customGetter = options?.get
  delete options?.get
  getter = ->
    cache = createModelCache @, propName

    if cache.deserialized
      return cache.deserialized

    model = @
    cache.deserialized = parse @getDataValue(propName), sep

    if customGetter
      cache.deserialized = customGetter.call @, cache.deserialized

    return cache.deserialized

  ## Setter
  customSetter = options?.set
  delete options?.set
  sep = options?.separator or ','
  setter = (value) ->
    if _.isArray(value)
      value = value.join sep
    else if not _.isString(value)
      value = ''

    if customSetter
      value = customSetter.call @, value

    cache = createModelCache @, propName
    delete cache.deserialized

    @setDataValue propName, value

  _.extend
    type: 'LONGTEXT'
    get: getter
    set: setter
  , options
