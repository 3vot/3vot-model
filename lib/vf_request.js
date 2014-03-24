(function() {
  var AjaxRequest, AjaxUtils, Model;

  AjaxUtils = require("./ajax_utils");

  Model = require('./model');

  AjaxRequest = (function() {
    function AjaxRequest() {}

    AjaxRequest.promise = {
      end: function() {}
    };

    AjaxRequest.enabled = true;

    AjaxRequest.disable = function(callback) {
      var e;
      if (this.enabled) {
        this.enabled = false;
        try {
          return callback();
        } catch (_error) {
          e = _error;
          throw e;
        } finally {
          this.enabled = true;
        }
      } else {
        return callback();
      }
    };

    AjaxRequest.queueRequest = {
      get: function(params, options) {
        return AjaxRequest.executeRestRequest("get", params, options);
      },
      post: function(params, options) {
        return AjaxRequest.executeRestRequest("post", params, options);
      },
      put: function(params, options) {
        return AjaxRequest.executeRestRequest("put", params, options);
      },
      del: function(params, options) {
        return AjaxRequest.executeRestRequest("del", params, options);
      }
    };

    AjaxRequest.executeRestRequest = function(type, params, options) {
      var fields, vfCall;
      if (this.enabled === false) {
        return this.promise;
      }
      options.url = options.url.replace(Model.host + "/", "");
      vfCall = '{!$RemoteAction.ThreeVotApiController.handleRest}';
      fields = "";
      if (type === "put" || type === "post") {
        fields = JSON.stringify(params.data);
      } else if (type === "get") {
        fields = options.record.attributes.joins(",");
      }
      return function(callback) {
        return Visualforce.remoting.Manager.invokeAction(vfCall, type, options.url, JSON.stringify(params.data), function(result, event) {
          if (event.status) {
            return callback(null, result);
          } else if (event.type === 'exception') {
            return callback(event.message);
          } else {
            return callback(event.message);
          }
        }, {
          escape: true
        });
      };
    };

    return AjaxRequest;

  })();

  module.exports = AjaxRequest;

}).call(this);
