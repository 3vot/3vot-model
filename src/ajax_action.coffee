ajax_request = require("./ajax_request")

class Action
  constructor: (@model) ->

  destroy: (values = {}, options = {} ) ->
    options.url = @model.url()
    params= {
      query: values
    }

    ajax_request.queueRequest.del(params, options).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @recordsResponse(res.body, options)

    return true;


  call: ( name, values = {}, options = {} ) ->
    options.url = @model.url() + "/actions/" + name
    params= {
      data: values
    }
  
    ajax_request.queueRequest.post(params, options).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @recordsResponse(res.body, options)
    
    return true;

  # Private

  recordsResponse: (data, options) =>
    @model.trigger('ajaxSuccess', data)
    @model.trigger('actionSuccess', data)
    options.done?.apply(@model, [data] )

  failResponse: (error, options) =>
    @model.trigger('ajaxError', error)
    @model.trigger('actionError', error)
    options.fail?.apply(@model, [error] )

module.exports = Action
