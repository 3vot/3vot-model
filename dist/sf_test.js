
var _3Model = require("3vot-model")
var _3Ajax = require("_3Ajax")

var accId = '';
Account = _3Model.Model.setup("Account", ["Name","Type"]);
Account.extend(_3Ajax);
Account.extend(_3Ajax.Auto);

function onCreate(){
  var a = Account.first();
  accId = a.id;
  a.Name = "Otjer Name";
  a.save( { done: onUpdate, fail: function(err){ onError(err, "onCreate") } } )
}

function onUpdate(){
  Account.fetch({id: accId }, { done: onFind, fail: function(err){ onError(err, "onUpdate") } } )
}

function onFind(){
  var a = Account.first();
  a.destroy({ done: onDelete, fail: function(err){ onError(err, "onFind") } } )
}

function onDelete(){
  console.log("CRUD COMPLETE")
}

function onError(error, location){
  console.log( "Error on " + location + " " + error )
}

Account.create({Name: "testing 123"} , { done: onCreate, fail: function(err){ onError(err, "onUpdate") } } )

