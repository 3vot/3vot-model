ajax_request = require("./ajax_request")

class SalesforceRest
  constructor: (@model) ->

  call: ( url, params, options = {} ) ->
    options.url = url;

    ajax_request.queueRequest.get(params, options).end (err, res) =>
        if err then return @failResponse(err, options )
        else if res.status >= 400 then return @failResponse(res.text, options )
        @recordsResponse(res.body, options)
      return true;

  # Private

  recordsResponse: (data, options) =>
    @model.trigger('ajaxSuccess', data)
    @model.trigger('restSuccess', data)
    
    options.done?.apply(@model, [data] )

  failResponse: (error, options) =>
    @model.trigger('ajaxError', error)
    @model.trigger('restError', error)
    options.fail?.apply(@model, [error] )

module.exports = SalesforceRest
