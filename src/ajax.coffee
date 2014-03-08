_3Model  = require('3vot-model')
AjaxUtils = require("./ajax_utils")
Collection = require("./ajax_collection")
Singleton = require("./ajax_singleton")
Action = require("./ajax_action")

View = require("./ajax_view")

ajax_request = require("./ajax_request")

Include =
  ajax: -> new Singleton(this)

  url: (args...) ->
    args.unshift(encodeURIComponent(@id))
    AjaxUtils.generateURL(@, args...)
    
Extend =
  ajax: -> new Collection(this)
  view: -> new View(this)
  action: -> new Action(this)
    
  url: (args...) ->
    AjaxUtils.generateURL(@, args...)

Ajax =

  extended: ->
    @fetch @ajaxFetch

    @extend Extend
    @include Include

  # Private

  ajaxFetch: ->
    @ajax().fetch(arguments...)

  callAction: ->
    @action().call(arguments...)

  callView: ->
    @view().call(arguments...)

Ajax.Auto =
  extended: ->
    @change @ajaxChange

  # Private

  ajaxChange: (record, type, options = {}) ->
    return if options.ajax is false
    record.ajax()[type](options.ajax || {}, options)


if !_3Model.Model.host then _3Model.Model.host = ""


#for testing
Ajax.request  = ajax_request;

module.exports = Ajax
