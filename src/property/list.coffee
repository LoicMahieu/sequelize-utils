
_ = require 'lodash'

{createModelCache} = require './property-utils'

parse = (value, separator) ->
  if _.isUndefined(value) or !value.length or !_.isFunction(value.split)
    return []
  else
    return value.split separator

stringify = (value, separator) ->
  if _.isArray(value)
    return value.join separator
  else if not _.isString(value)
    return ''
  else
    return value

listGetter = module.exports = (propName, options) ->
  separator = options?.separator or ','

  ## Getter
  customGetter = options?.get
  delete options?.get
  getter = ->
    cache = createModelCache @, propName

    if cache.deserialized
      return cache.deserialized

    model = @
    cache.deserialized = parse @getDataValue(propName), separator

    if customGetter
      cache.deserialized = customGetter.call @, cache.deserialized

    return cache.deserialized

  ## Setter
  customSetter = options?.set
  delete options?.set
  setter = (value) ->
    value = stringify(value, separator)

    if customSetter
      value = customSetter.call @, value

    cache = createModelCache @, propName
    delete cache.deserialized

    @setDataValue propName, value

  ## Default value
  if options?.defaultValue
    options.defaultValue = stringify(options.defaultValue)

  _.extend
    type: 'LONGTEXT'
    get: getter
    set: setter
  , options
