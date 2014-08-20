
_ = require 'lodash'


{createModelCache} = require './property-utils'

parse = JSON.parse
parseSafe = (value) ->
  unless value
    return
  try
    return parse(value)
  catch err
    console.error err

isJSONRegex = require 'is-json'
isJSON = (value) ->
  return false unless isJSONRegex(value)
  try
    parse(value)
  catch err
    return false
  return true

stringify = (value, indent) ->
  unless _.isUndefined(value)
    value = JSON.stringify value, null, indent

jsonGetter = module.exports = (propName, options) ->
  indent = 2
  if !_.isUndefined(options?.indent)
    indent = options.indent
    delete options.indent

  ## Getter
  customGetter = options?.get
  delete options?.get
  getter = ->
    cache = createModelCache @, propName

    if cache.deserialized
      return cache.deserialized

    model = @
    cache.deserialized = parseSafe @getDataValue(propName)

    if customGetter
      cache.deserialized = customGetter.call @, cache.deserialized

    return cache.deserialized

  ## Setter
  customSetter = options?.set
  delete options?.set
  setter = (value) ->
    unless isJSON(value)
      if customSetter
        value = customSetter.call @, value

      value = stringify(value, indent)

    cache = createModelCache @, propName
    delete cache.deserialized

    @setDataValue propName, value

  if options?.defaultValue
    options.defaultValue = stringify(options.defaultValue)

  _.extend
    type: 'LONGTEXT'
    get: getter
    set: setter
  , options
