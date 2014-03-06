_3Model  = require('_3Model')
superagent = require("superagent/superagent")

queueRequest= 
  get: (params, options) -> executeRequest("get",params, options)
  post: (params, options) -> executeRequest("post",params, options)
  put: (params, options) -> executeRequest("pull",params, options)
  del: (params, options) -> executeRequest("del",params, options)
  
executeRequest= (type, params, options ) ->
  request = superagent[type](options.url)
    .type('json')
    .set('X-Requested-With','XMLHttpRequest')
    .on("error", options.error)

  if Ajax.enableCORS then request = request.withCredentials()  
  if params.query then request = request.query(params.query)
  if params.data then request = request.send(JSON.stringify(params.data))

  return request


class Collection
  constructor: (@model) ->

  find: (id, params, options = {}) ->
    console.log(arguments)
    record = new @model(id: id)
    options.url = record.url if !options.url
    queueRequest.get(params, options)

  all: (params, options = {}) ->
    options.url = @model.url() if !options.url
    queueRequest.get(params, options)

  fetch: (params = {}, options = {}) ->
    options.error = @failResponse
    if id = params.id
      delete params.id
      @find(id, params, options).end (err, res) =>
        @model.refresh(res.body, options)
        @recordsResponse(res)
        
    else
      @all(params, options).end (res) =>
        @model.refresh(res.body, options)
        @recordsResponse(res);

  # Private

  recordsResponse: (data, status, xhr) =>
    console.log(@model)
    @model.trigger('ajaxSuccess', data, status, xhr)

  failResponse: (xhr, statusText, error) =>
    @model.trigger('ajaxError', null, xhr, statusText, error)

Include =
  ajax: -> 

  url: (args...) ->
    args.unshift(encodeURIComponent(@id))
    generateURL(@, args...)
    
Extend =
  ajax: -> new Collection(this)
    
  url: (args...) ->
    generateURL(@, args...)

Ajax =
  options:
    enableCORS: true;

  extended: ->
    @fetch @ajaxFetch

    @extend Extend
    @include Include

  # Private

  ajaxFetch: ->
    @ajax().fetch(arguments...)

module.exports = Ajax

getScope= (object) ->
  object.scope?() or object.scope

generateURL= (object, args...) ->
  if object.className
    collection = object.className.toLowerCase() + 's'
    scope = getScope(object)
  else
    if typeof object.constructor.url is 'string'
      collection = object.constructor.url
    else
      collection = object.constructor.className.toLowerCase() + 's'
    scope = getScope(object) or getScope(object.constructor)
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
    
