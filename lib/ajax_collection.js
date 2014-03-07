(function() {
  var Collection, ajax_request,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ajax_request = require("./ajax_request");

  Collection = (function() {
    function Collection(model) {
      this.model = model;
      this.failResponse = __bind(this.failResponse, this);
      this.recordsResponse = __bind(this.recordsResponse, this);
    }

    Collection.prototype.find = function(id, params, options) {
      var record;
      if (options == null) {
        options = {};
      }
      record = new this.model({
        id: id
      });
      if (!options.url) {
        options.url = record.url;
      }
      return ajax_request.queueRequest.get(params, options);
    };

    Collection.prototype.all = function(params, options) {
      if (options == null) {
        options = {};
      }
      if (!options.url) {
        options.url = this.model.url();
      }
      return ajax_request.queueRequest.get(params, options);
    };

    Collection.prototype.fetch = function(params, options) {
      var id;
      if (params == null) {
        params = {};
      }
      if (options == null) {
        options = {};
      }
      options.error = this.failResponse;
      if (id = params.id) {
        delete params.id;
        this.find(id, params, options).end((function(_this) {
          return function(res) {
            _this.model.refresh(res.body, options);
            return _this.recordsResponse(res);
          };
        })(this));
        return true;
      } else {
        this.all(params, options).end((function(_this) {
          return function(res) {
            _this.model.refresh(res.body, options);
            return _this.recordsResponse(res);
          };
        })(this));
        return true;
      }
    };

    Collection.prototype.recordsResponse = function(data, status, xhr) {
      return this.model.trigger('ajaxSuccess', data, status, xhr);
    };

    Collection.prototype.failResponse = function(xhr, statusText, error) {
      return this.model.trigger('ajaxError', null, xhr, statusText, error);
    };

    return Collection;

  })();

  module.exports = Collection;

}).call(this);
