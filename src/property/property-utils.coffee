
module.exports =
  createModelCache: (model, prop, key = '__getter_cache') ->
    model[key] ?= {}
    model[key][prop] ?= {}
    return model[key][prop]
