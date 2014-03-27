_3Model  = require('3vot-model')
AjaxUtils = require("./ajax_utils")
Collection = require("./ajax_collection")
Singleton = require("./ajax_singleton")
Action = require("./ajax_action")
Query = require("./ajax_query")

View = require("./ajax_view")

ajax_request = require("./ajax_request")

Include =
  ajax: -> new Singleton(@)

  url: (args...) ->
    args.unshift(encodeURIComponent(@id))
    AjaxUtils.generateURL(@, args...)
    
Extend =
  ajax: -> new Collection(this)
  view: -> new View(this)
  action: -> new Action(this)
  queryManager: -> new Query(this)
    
  url: (args...) ->
    AjaxUtils.generateURL(@, args...)

Ajax =

  extended: ->
    @fetch @ajaxFetch
    @change @ajaxChange
    @query = @ajaxQuery
    @extend Extend
    @include Include
    

  # Private

  ajaxFetch: ->
    @ajax().fetch(arguments...)

  callAction: ->
    @action().call(arguments...)

  callView: ->
    @view().call(arguments...)
  
  ajaxQuery: ->
    @queryManager().manualQuery(arguments...)
    
  destroy: ->
    @action().destroy(arguments...)

  ajaxChange: (record, type, options = {}) ->
    return if options.ajax is false or record.constructor.autoAjax is false
    record.ajax()[type](options.ajax || {}, options)


#for testing
Ajax.request  = ajax_request;

module.exports = Ajax
