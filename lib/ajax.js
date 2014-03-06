(function() {
  var Ajax, Collection, Extend, Include, executeRequest, generateURL, getScope, queueRequest, superagent, _3Model,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  _3Model = require('_3Model');

  superagent = require("superagent/superagent");

  queueRequest = {
    get: function(params, options) {
      return executeRequest("get", params, options);
    },
    post: function(params, options) {
      return executeRequest("post", params, options);
    },
    put: function(params, options) {
      return executeRequest("pull", params, options);
    },
    del: function(params, options) {
      return executeRequest("del", params, options);
    }
  };

  executeRequest = function(type, params, options) {
    var request;
    request = superagent[type](options.url).type('json').set('X-Requested-With', 'XMLHttpRequest').on("error", options.error);
    if (Ajax.enableCORS) {
      request = request.withCredentials();
    }
    if (params.query) {
      request = request.query(params.query);
    }
    if (params.data) {
      request = request.send(JSON.stringify(params.data));
    }
    return request;
  };

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
      return queueRequest.get(params, options);
    };

    Collection.prototype.all = function(params, options) {
      if (options == null) {
        options = {};
      }
      if (!options.url) {
        options.url = this.model.url();
      }
      return queueRequest.get(params, options);
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
          return function(err, res) {
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

  Include = {
    ajax: function() {},
    url: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      args.unshift(encodeURIComponent(this.id));
      return generateURL.apply(null, [this].concat(__slice.call(args)));
    }
  };

  Extend = {
    ajax: function() {
      return new Collection(this);
    },
    url: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return generateURL.apply(null, [this].concat(__slice.call(args)));
    }
  };

  Ajax = {
    options: {
      enableCORS: true
    },
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

  module.exports = Ajax;

  getScope = function(object) {
    return (typeof object.scope === "function" ? object.scope() : void 0) || object.scope;
  };

  generateURL = function() {
    var args, collection, object, path, scope;
    object = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (object.className) {
      collection = object.className.toLowerCase() + 's';
      scope = getScope(object);
    } else {
      if (typeof object.constructor.url === 'string') {
        collection = object.constructor.url;
      } else {
        collection = object.constructor.className.toLowerCase() + 's';
      }
      scope = getScope(object) || getScope(object.constructor);
    }
    args.unshift(collection);
    args.unshift(scope);
    path = args.join('/');
    path = path.replace(/(\/\/)/g, "/");
    path = path.replace(/^\/|\/$/g, "");
    if (path.indexOf("../") !== 0) {
      return _3Model.Model.host + "/" + path;
    } else {
      return path;
    }
  };

}).call(this);
