_3Model  = require('_3Model')
AjaxUtils = require("./ajax_utils")
Collection = require("./ajax_collection")
Singleton = require("./ajax_singleton")


Include =
  ajax: -> new Singleton(this)

  url: (args...) ->
    args.unshift(encodeURIComponent(@id))
    AjaxUtils.generateURL(@, args...)
    
Extend =
  ajax: -> new Collection(this)
    
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

Ajax.Auto =
  extended: ->
    @change @ajaxChange

  # Private

  ajaxChange: (record, type, options = {}) ->
    return if options.ajax is false
    record.ajax()[type](options.ajax || {}, options)

module.exports = Ajax
