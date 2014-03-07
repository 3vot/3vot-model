(function() {
  var AjaxUtils, Singleton, ajax_request, _3Model,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ajax_request = require("./ajax_request");

  AjaxUtils = require("./ajax_utils");

  _3Model = require("_3Model");

  Singleton = (function() {
    function Singleton(record) {
      this.record = record;
      this.failResponse = __bind(this.failResponse, this);
      this.recordResponse = __bind(this.recordResponse, this);
      this.model = this.record.constructor;
    }

    Singleton.prototype.reload = function(params, options) {
      if (options == null) {
        options = {};
      }
      options.data = this.record.toJSON();
      options.url = options.url || AjaxUtils.getURL(this.record);
      options.error = this.failResponse;
      return ajax_request.queueRequest.get(params, options).end((function(_this) {
        return function(res) {
          return _this.recordResponse(res.body, options);
        };
      })(this));
    };

    Singleton.prototype.create = function(params, options) {
      if (options == null) {
        options = {};
      }
      options.data = this.record.toJSON();
      options.url = options.url || AjaxUtils.getCollectionURL(this.record);
      ajax_request.queueRequest.post(params, options).end((function(_this) {
        return function(err, res) {
          if (err || res.status >= 400) {
            return _this.failResponse(res.body, options);
          }
          return _this.recordResponse(res.body, options);
        };
      })(this));
      return "ok";
    };

    Singleton.prototype.update = function(params, options) {
      if (options == null) {
        options = {};
      }
      options.data = this.record.toJSON();
      options.url = options.url || AjaxUtils.getURL(this.record);
      return ajax_request.queueRequest.put(params, options).end((function(_this) {
        return function(err, res) {
          if (err || res.status >= 400) {
            return _this.failResponse(res.body, options);
          }
          return _this.recordResponse(res.body, options);
        };
      })(this));
    };

    Singleton.prototype.destroy = function(params, options) {
      if (options == null) {
        options = {};
      }
      options.data = this.record.toJSON();
      options.url = options.url || AjaxUtils.getURL(this.record);
      options.error = this.failResponse;
      return ajax_request.queueRequest.del(params, options).end((function(_this) {
        return function(res) {
          return _this.recordResponse(res.body, options);
        };
      })(this));
    };

    Singleton.prototype.recordResponse = function(data, options) {
      var _ref;
      if (options == null) {
        options = {};
      }
      ajax_request.disable((function(_this) {
        return function() {
          if (!(_3Model.isBlank(data) || _this.record.destroyed)) {
            if (data.id && _this.record.id !== data.id) {
              _this.record.changeID(data.id);
            }
            return _this.record.refresh(data);
          }
        };
      })(this));
      this.record.trigger('ajaxSuccess', data);
      return (_ref = options.done) != null ? _ref.apply(this.record) : void 0;
    };

    Singleton.prototype.failResponse = function(error, options) {
      var _ref;
      if (options == null) {
        options = {};
      }
      this.record.trigger('ajaxError', error);
      return (_ref = options.fail) != null ? _ref.apply(this.record) : void 0;
    };

    return Singleton;

  })();

  module.exports = Singleton;

}).call(this);
