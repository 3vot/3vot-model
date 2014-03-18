superagent = require("superagent")
AjaxUtils = require("./ajax_utils")

class AjaxRequest

  @promise=
    end: -> 

  @enabled = true;

  @disable= (callback) ->
    if @enabled
      @enabled = false
      try
        do callback
      catch e
        throw e
      finally
        @enabled = true
    else
      do callback

  @queueRequest= 
    get: (params, options) -> AjaxRequest.executeRequest("get",params, options)
    post: (params, options) -> AjaxRequest.executeRequest("post",params, options)
    put: (params, options) -> AjaxRequest.executeRequest("put",params, options)
    del: (params, options) -> AjaxRequest.executeRequest("del",params, options)
  
  @executeRequest= (type, params, options ) ->
    if @enabled == false then return @promise
    request = superagent[type](options.url)
      .set('X-Requested-With','XMLHttpRequest')
      
    for header in _3Model.Model.headers
      if( !header.name or !header.value ) then throw "header should be an object with name and value"
      request = request.set( header.name, header.value )

    request.withCredentials?()  

    if type == "put" or type == "post" then request= request.type('json')

    if options.error then request.on("error", options.error)
    if params.query then request = request.query( params.query )
    if params.data
      params.data = JSON.stringify(params.data) if typeof params.data isnt 'string'
      request = request.send( params.data )

    return request
  
module.exports = AjaxRequest