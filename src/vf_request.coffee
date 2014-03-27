AjaxUtils = require("./ajax_utils")
Model  = require('./model')

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
    get: (params, options ) -> AjaxRequest.executeRestRequest("get", params, options )
    post: (params, options ) -> AjaxRequest.executeRestRequest("post", params, options)
    put: (params, options ) -> AjaxRequest.executeRestRequest("put", params, options)
    del: (params, options ) -> AjaxRequest.executeRestRequest("del", params, options)

  @executeRestRequest= (type, params, options, model ) ->
    if @enabled == false then return @promise
    options.url = options.url.replace(Model.host + "/", "")
    delete params.data?.id

    vfCall = 'r2.ThreeVotApiController.handleRest'
    
    fields = "{}"
    fields = JSON.stringify( params.data or "{}" ) if type == "put" or type == "post" 

    request = end: (callback) ->   
      Visualforce.remoting.Manager.invokeAction vfCall, type, options.url, fields, 
      (result, event) ->
        if (event.status)
          if ( type == "put" and result == null or ( type == "del" and result == null ) )
            result = '{}' 
          else if type != "del" and type != "put" and result == null
            return callback("Null return from action method")

          result = JSON.parse(result)
          if ( Array.isArray(result) && result[0].message && result[0].errorCode ) then return callback( result[0].message )
          if ( result && result.message && result.errorCode ) then return callback( result[0].message )

          delete result.errors if result
          delete result.success if result
          callback(null, { body: result } )
        else if event.type == 'exception'
          callback(event.message)
        else
          callback(event.message)
      , escape: false

module.exports = AjaxRequest