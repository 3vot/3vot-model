ajax_request = require("./ajax_request")
AjaxUtils = require("./ajax_utils")
_3Model = require("3vot-model")

class Singleton
  
  constructor: (@record) ->
    @model = @record.constructor

  reload: (params, options = {}) ->
    options.data = @record.toJSON()
    options.url= options.url or AjaxUtils.getURL(@record)
    options.error = @failResponse
    ajax_request.queueRequest.get(params, options).end (res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @recordResponse(res.body, options)
    
  create: (params, options = {}) ->
    options.data = @record.toJSON()
    options.url= options.url or AjaxUtils.getCollectionURL(@record)
    ajax_request.queueRequest.post(params, options).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @recordResponse(res.body, options)

  update: (params, options = {}) ->
    options.data = @record.toJSON()
    options.url= options.url or AjaxUtils.getURL(@record)
    ajax_request.queueRequest.put(params, options).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @recordResponse(res.body, options)

  destroy: (params, options = {}) ->
    options.data = @record.toJSON()
    options.url= options.url or AjaxUtils.getURL(@record)
    options.error = @failResponse
    ajax_request.queueRequest.del(params, options).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @recordResponse(res.body, options)

  # Private
  recordResponse: (data, options = {}) =>
    ajax_request.disable =>
      unless _3Model.isBlank(data) or @record.destroyed
        # ID change, need to do some shifting
        if data.id and @record.id isnt data.id
          @record.changeID(data.id)
        # Update with latest data
        @record.refresh(data)

    @record.trigger('ajaxSuccess', data)
    options.done?.apply(@record)

  failResponse: (error, options = {}) =>
    @record.trigger('ajaxError', error)
    options.fail?.apply(@record, [error] )

module.exports = Singleton