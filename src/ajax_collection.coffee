ajax_request = require("./ajax_request")
AjaxUtils = require("./ajax_utils")

class Collection
  constructor: (@model) ->
    if( typeof Visualforce != "undefined" ) then ajax_request = require("./vf_request")

  find: (id, params, options = {}) ->
    record = new @model(id: id)
    options.url= options.url or AjaxUtils.getURL(record)
    options.model = @model
    params.query = params.query or @model.attributes.join(",")
    ajax_request.queueRequest.get(params, options)

  all: (params, options = {}) ->
    options.url = @model.url() if !options.url
    ajax_request.queueRequest.get(params, options)

  fetch: (params = {}, options = {}) ->
    if id = params.id
      delete params.id
      _this = @;
      @find(id, params, options).end (err, res) ->
        if err then return _this.failResponse(err, options )
        else if res.status >= 400 then return _this.failResponse(res.text, options )
        _this.model.refresh(res.body, options)
        _this.recordsResponse(res, options)
      return true;
        
    else
      @all(params, options).end (err, res) =>
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

module.exports = Collection
