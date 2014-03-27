(function() {
  var AjaxUtils, Query, ajax_request, _3Model,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ajax_request = require("./ajax_request");

  AjaxUtils = require("./ajax_utils");

  _3Model = require("3vot-model");

  Query = (function() {
    function Query(model) {
      this.model = model;
      this.failResponse = __bind(this.failResponse, this);
      this.recordsResponse = __bind(this.recordsResponse, this);
      if (typeof Visualforce !== "undefined") {
        ajax_request = require("./vf_request");
      }
    }

    Query.prototype.manualQuery = function(query, options) {
      if (options == null) {
        options = {};
      }
      options.url = _3Model.Model.host + "/query?query=" + query;
      ajax_request.queueRequest.get({}, options, this.model).end((function(_this) {
        return function(err, res) {
          if (err) {
            return _this.failResponse(err, options);
          } else if (res.status >= 400) {
            return _this.failResponse(res.text, options);
          }
          _this.model.refresh(res.body, options);
          return _this.recordsResponse(res, options);
        };
      })(this));
      return true;
    };

    Query.prototype.recordsResponse = function(data, options) {
      var _ref;
      this.model.trigger('ajaxSuccess', data);
      return (_ref = options.done) != null ? _ref.apply(this.model, [data]) : void 0;
    };

    Query.prototype.failResponse = function(error, options) {
      var _ref;
      this.model.trigger('ajaxError', error);
      return (_ref = options.fail) != null ? _ref.apply(this.model, [error]) : void 0;
    };

    return Query;

  })();

  module.exports = Query;

}).call(this);
