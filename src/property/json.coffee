
_ = require 'lodash'


{createModelCache} = require './property-utils'

parse = JSON.parse

isJSONRegex = require 'is-json'
isJSON = (value) ->
  return false unless isJSONRegex(value)
  try
    parse(value)
  catch err
    return false
  return true

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
  indent = 2
  if !_.isUndefined(options?.indent)
    indent = options.indent
    delete options.indent
  setter = (value) ->
    unless isJSON(value)
      if customSetter
        value = customSetter.call @, value

      unless _.isUndefined(value)
        value = JSON.stringify value, null, indent

    cache = createModelCache @, propName
    delete cache.deserialized

    @setDataValue propName, value

  _.extend
    type: 'LONGTEXT'
    get: getter
    set: setter
  , options
