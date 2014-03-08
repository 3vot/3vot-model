(function() {
  var Action, Ajax, AjaxUtils, Collection, Extend, Include, Singleton, View, ajax_request, _3Model,
    __slice = [].slice;

  _3Model = require('3vot-model');

  AjaxUtils = require("./ajax_utils");

  Collection = require("./ajax_collection");

  Singleton = require("./ajax_singleton");

  Action = require("./ajax_action");

  View = require("./ajax_view");

  ajax_request = require("./ajax_request");

  Include = {
    ajax: function() {
      return new Singleton(this);
    },
    url: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      args.unshift(encodeURIComponent(this.id));
      return AjaxUtils.generateURL.apply(AjaxUtils, [this].concat(__slice.call(args)));
    }
  };

  Extend = {
    ajax: function() {
      return new Collection(this);
    },
    view: function() {
      return new View(this);
    },
    action: function() {
      return new Action(this);
    },
    url: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return AjaxUtils.generateURL.apply(AjaxUtils, [this].concat(__slice.call(args)));
    }
  };

  Ajax = {
    extended: function() {
      this.fetch(this.ajaxFetch);
      this.extend(Extend);
      return this.include(Include);
    },
    ajaxFetch: function() {
      var _ref;
      return (_ref = this.ajax()).fetch.apply(_ref, arguments);
    },
    callAction: function() {
      var _ref;
      return (_ref = this.action()).call.apply(_ref, arguments);
    },
    callView: function() {
      var _ref;
      return (_ref = this.view()).call.apply(_ref, arguments);
    }
  };

  Ajax.Auto = {
    extended: function() {
      return this.change(this.ajaxChange);
    },
    ajaxChange: function(record, type, options) {
      if (options == null) {
        options = {};
      }
      if (options.ajax === false) {
        return;
      }
      return record.ajax()[type](options.ajax || {}, options);
    }
  };

  if (!_3Model.Model.host) {
    _3Model.Model.host = "";
  }

  Ajax.request = ajax_request;

  module.exports = Ajax;

}).call(this);
