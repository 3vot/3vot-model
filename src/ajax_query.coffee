ajax_request = require("./ajax_request")
AjaxUtils = require("./ajax_utils")
_3Model = require("3vot-model")

class Query
  constructor: (@model) ->
    if( typeof Visualforce != "undefined" ) then ajax_request = require("./vf_request")

  manualQuery: (query, options = {}) ->
    options.url = _3Model.Model.host + "/query?query=" + query
    
    ajax_request.queueRequest.get({}, options, @model).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @model.refresh(res.body, options)
      @recordsResponse(res, options);
    return true

  # Private

  recordsResponse: (data, options) =>
    @model.trigger('ajaxSuccess', data)
    options.done?.apply(@model, [data] )

  failResponse: (error, options) =>
    @model.trigger('ajaxError', error)
    options.fail?.apply(@model, [error] )

module.exports = Query