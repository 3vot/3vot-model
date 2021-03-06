
var VFR= require("clay-vfr")

var Ajax = function(eventName, model, options){
  if(eventName == "create") return Ajax.post.call(this, model,options )
  else if(eventName == "update") return Ajax.put.call(this, model,options )
  else if(eventName == "destroy") return Ajax.del.call(this, model,options )
  
  //Sho
  var params = model;
  if(eventName == "query") return Ajax.query.call(this, params, options);  
  else if(eventName == "read") return Ajax.get.call(this, params, options);
  else if(eventName == "api") return Ajax.api.call(this, params, options);

}

Ajax.api = function(){
  if(!this.ajax.namespace) this.ajax.namespace = ""
  var args = Array.prototype.slice(arguments);
  var remoteAction = args[0];
  var callArgs = []
  for (var i = 1; i < args.length-1; i++) {
    callArgs.push(args[i]);
  };
  options = args[args.length-1];
  if(typeof remoteAction != "string" ) throw "First Argument should be the Remote Action (string)"
  if(options == remoteAction) options = {};

  var send = VFR( this.namespace + remoteAction, options, options.nullok || false );
  return send.apply( VFR, callArgs );
}

Ajax.query = function(params, options){
  if(!this.ajax.namespace) this.ajax.namespace =""

  var pctEncodeSpaces = true;
  var params = encodeURIComponent(params).replace(/%40/gi, '@').replace(/%3A/gi, ':').replace(/%24/g, '$').replace(/%2C/gi, ',').replace(/%20/g, pctEncodeSpaces ? '%20' : '+');
  
  var send = VFR(this.ajax.namespace + "ThreeVotApiController.handleRest" );
  return send( "get", "/query?query=" + params , "" )
  .then(function(results){ 
    for (var i = results.length - 1; i >= 0; i--) {
      results[i].id = results[i].Id
      delete results[i].Id;
    };
    return results;
   })
}

Ajax.get = function(id, options){
  if(!this.ajax.namespace) this.ajax.namespace =""

  var send = VFR(this.ajax.namespace + "ThreeVotApiController.handleRest" );
  return send( "get", Ajax.generateURL(this) + "/" + id, "" )
  .then(function(data){
    data.id = data.Id;
    delete results[i].Id;
    return data;
  });
}

Ajax.post = function(model, options){
  if(!model.ajax.namespace) model.namespace =""
  var _this = this;

  var id = this.id;
  this.id = null;
  var send = VFR(model.ajax.namespace + "ThreeVotApiController.handleRest" );
  return send( "post", Ajax.generateURL(model) , JSON.stringify(this.toJSON()) )
  .then( function(data){ _this.id = id; return data; } )
}

Ajax.put = function(model, options){
  if(!model.ajax.namespace) model.ajax.namespace =""

  var id = this.id;
  this.id = null;
  var _this = this;

  var send = VFR(model.ajax.namespace + "ThreeVotApiController.handleRest", {}, true );
  return send( "put", Ajax.generateURL(model, id ), JSON.stringify(this.toJSON()) )
  .then( function(data){ _this.id = id; return data; } )
}

Ajax.del = function(model, options){
  if(!model.ajax.namespace) model.ajax.namespace =""

  var send = VFR(model.ajax.namespace + "ThreeVotApiController.handleRest", {}, true );
  return send( "del", Ajax.generateURL(model, this.id ), "" );
}

Ajax.generateURL = function() {
  var args, collection, object, path, scope;
  object = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  collection = object.className;
  
  args.unshift(collection);
  args.unshift(scope);
  path = args.join('/');
  path = path.replace(/(\/\/)/g, "/");
  path = path.replace(/^\/|\/$/g, "");
  return "/"+path;
};

module.exports = Ajax;

