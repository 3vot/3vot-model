_3Model = require("3vot-model")

class AjaxUtils

  @getURL: (object) ->
    object.url?() or object.url

  @getScope= (object) ->
    object.scope?() or object.scope

  @generateURL= (object, args...) ->
    if object.className
      collection = object.className.toLowerCase() + 's'
      scope = AjaxUtils.getScope(object)
    else
      if typeof object.constructor.url is 'string'
        collection = object.constructor.url
      else
        collection = object.constructor.className.toLowerCase() + 's'
      scope = AjaxUtils.getScope(object) or AjaxUtils.getScope(object.constructor)
    args.unshift(collection)
    args.unshift(scope)
    # construct and clean url
    path = args.join('/')
    path = path.replace /(\/\/)/g, "/"
    path = path.replace /^\/|\/$/g, ""
    # handle relative urls vs those that use a host
    if path.indexOf("../") isnt 0
      _3Model.Model.host + "/" + path
    else
      path

  @getCollectionURL= (object) ->
    if object
      if typeof object.url is "function"
        AjaxUtils.generateURL(object)
      else
        object.url

module.exports = AjaxUtils