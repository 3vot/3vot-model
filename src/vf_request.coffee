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
    get: (params, options ) -> AjaxRequest.executeRestRequest("get", params, options)
    post: (params, options ) -> AjaxRequest.executeRestRequest("post", params, options)
    put: (params, options ) -> AjaxRequest.executeRestRequest("put", params, options)
    del: (params, options ) -> AjaxRequest.executeRestRequest("del", params, options)
  

  @executeRestRequest= (type, params, options ) ->
    if @enabled == false then return @promise
    options.url = options.url.replace(Model.host + "/", "")
    delete params.data.id
    vfCall = 'r2.ThreeVotApiController.handleRest'
    
    fields = ""
    if type == "put" or type == "post" then fields = JSON.stringify( params.data )
    else if type == "get" then fields = options.record.attributes.joins(",")
      
    request = end: (callback) ->   
      Visualforce.remoting.Manager.invokeAction vfCall, type, options.url, JSON.stringify( params.data ), 
      (result, event) ->
        if (event.status)
          callback(null, result)
        else if event.type == 'exception'
          callback(event.message)
        else
          callback(event.message)
      , escape: true
   
    
   
module.exports = AjaxRequest