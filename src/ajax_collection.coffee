ajax_request = require("./ajax_request")

class Collection
  constructor: (@model) ->

  find: (id, params, options = {}) ->
    record = new @model(id: id)
    options.url = record.url if !options.url
    ajax_request.queueRequest.get(params, options)

  all: (params, options = {}) ->
    options.url = @model.url() if !options.url
    ajax_request.queueRequest.get(params, options)

  fetch: (params = {}, options = {}) ->
    if id = params.id
      delete params.id
      @find(id, params, options).end (err, res) =>
        if err then return @failResponse(err, options )
        else if res.status >= 400 then return @failResponse(res.body, options )
        @model.refresh(res.body, options)
        @recordsResponse(res)
      return true;
        
    else
      @all(params, options).end (err, res) =>
        if err then return @failResponse(err, options )
        else if res.status >= 400 then return @failResponse(res.body, options )
        @model.refresh(res.body, options)
        @recordsResponse(res);
      return true

  # Private

  recordsResponse: (data, status, xhr) =>
    @model.trigger('ajaxSuccess', data, status, xhr)

  failResponse: (xhr, statusText, error) =>
    @model.trigger('ajaxError', null, xhr, statusText, error)


module.exports = Collection
