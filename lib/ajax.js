(function() {
  var Ajax, AjaxUtils, Collection, Extend, Include, Singleton, ajax_request, _3Model,
    __slice = [].slice;

  _3Model = require('3vot-model');

  AjaxUtils = require("./ajax_utils");

  Collection = require("./ajax_collection");

  Singleton = require("./ajax_singleton");

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

  Ajax.request = ajax_request;

  module.exports = Ajax;

}).call(this);
