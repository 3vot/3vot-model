THIS REPOSITORY IS NOT BEING MANTAINED

USE [https://github.com/3vot/clay-model](Clay Model instead with Promise Support)


# Documentation

Clay uses an MVC framework to build Javascript web applications that
fully communicate and integrate with Salesforce. This framework is the
3VOT-Model NPM package, which serves as the base to your apps, and the
core of its MVC architecture is based on the Spine.js framework.

Spine.js Framework integrates class support for Javascript, as
internally it uses CoffeeScript classes, which can be used in 3vot Model
aswell.



If you need guidance for more advanced coding patterns and structures
and can’t find it here yet, you can refer to Spine.js documentation, or
send us an e-mail, to which we’ll be happy to answer. 

<p>For a web version, go to http://clayforsalesforce.com.  <br /></p>
  
# Clay for Salesforce
When using 3VOT Model with with Clay and Salesforce this is the Salesforce Package:
https://github.com/3vot/clayforsalesforce

Class methods

### Model.setup(modelName, attributes...)

var User = Model.setup("User", [ "first_name", "last_name" ]);

Set up the model and its attributes. This is required for every model, and should be called before anything else is.

### Model.bind(eventName, function)

Bind event listeners to the model. These are executed in the context of the model.

User.bind("refresh change", function(user){
	alert("#{user.name} changed!"))
}
See events for more information.

### Model.trigger(eventName, data...)

Trigger a custom event, see events for more information.

### Model.unbind([eventName, function])

Unbind events, see the events guide for more information.

### Model.find(id, [notFound])

Find records by ID - returning the record instance. If the record doesn't exist, @notFound will be run unless a custom callback was also passed in.

var user = User.find("1")

### Model.exists(id)

Returns a boolean indicating if the record with the specified ID exists or not.

var user = User.exists("1")


### Model.refresh(recordsArray, [options])

Appends to all the stored records, without calling any create, update, save or destroy events. The only event that will be triggered is the refresh event. You can pass the option {clear: true} to wipe all the existing records. Internally @refresh calls fromJSON(), so you can also pass it JSON instead of an array.

User.refresh([{id: 1, name: "test"}, {id: 2, name: "test2"}])

### Model.select(function)

Select all records that the callback function returns true to.

bobs = User.select(function(user){ 
	return( user.name == "bob" );
}

### Model.findByAttribute(name, value)

Find the first record that has the given attribute & value.

bob = User.findByAttribute("name", "bob")

### Model.findAllByAttribute(name, value)

Find all records that have the given attribute & value.

bobs = User.findAllByAttribute("name", "bob")

### Model.each(callback)

Iterate over every record, passing it to the callback function.

User.each(function(user){
	alert(user.name)
});

### Model.all()

Returns a cloned copy of every instance.

users = User.all()

### Model.slice(begin[, end])

Returns a cloned copies of instances from begin up to but not including end.

allUsersExceptFirst3 = User.slice(3)
users7through13 = User.slice(6,13)

### Model.first([x])

Returns a cloned copy of the first record. or an array of the first x records

### Model.last([x])

Returns a cloned copy of the last record, or an array of the last x records

### Model.count()

Returns the count of total records.

### Model.deleteAll()

Deletes every record without triggering any events.

### Model.destroyAll(options)

Destroys every record, triggering a destroy event on every record.

### Model.update(id, attributes)

Updates the record with the matching ID, with the given attributes.

### Model.create(attributes)

Creates a new record with the given attributes. Returns false if the record's validation fails, or the newly created record if successful.

### Model.destroy(id, options)

Destroys the record with the given ID.

### Model.fetch([function])

If passed a function, @fetch() adds that function as a listener to the fetch event. Otherwise, it triggers the fetch event.

### Model.toJSON()

Utility function so the model has a valid JSON representation (shows all records).

### Model.fromJSON(json)

Pass a JSON string, representing either an array or a singleton, to @fromJSON(). Returns an array or unsaved model instances.


### Model.proxy(function)

Wrap a function in a proxy so it will always execute in the context of the model. This is a JavaScript compatibility feature, and shouldn't be used in CoffeeScript.

create = Model.proxy(Model.create)

### Model.setup
Model.setup(name, [attributes...])

Alternative method for creating a new model class. This is a JavaScript compatibility feature, and shouldn't be used in CoffeeScript.

var User = Model.setup("User", ["first_name", "last_name"])


## Instance methods

### newRecord

Boolean indicating if the record has been saved or not. Use isNew() instead.

### isNew()

Returns a boolean indicating if the record has been saved or not.

### isValid()

Returns a boolean indicating if the record has passed validation.

### validate()

By default a noop. Override this to provide custom validation. Return a string, containing the error message, if the record isn't valid. For example:


  Model.prototype.validate = function(){
    "Name required" unless @name
  }

### load(attributes)

Load a set of properties in, setting attributes.

user = new User
user.load(name: "Sir Bob")
attributes()

Returns a hash of attributes to values.

### eql(record)

Returns a boolean indicating if the other record is equal (i.e. same class and ID) as the current instance.

if(user.eql(anotherUser)) alert("Yah!")

### save()

Creates or updates the record, returning false if the record's validation fails, or self if the record saves successfully. During a save, the beforeSave, change and save events are triggered. Also the create or update events will be fired depending on whether the record was created/updated.

user = new User(name: "Sir Robin")
user.save()

alert("#{user.id} was saved")
user = User.find(user.id)

### updateAttribute(name, value)

Sets a single attribute, saving the instance.

user = new User
user.updateAttribute("name", "Green Knight")

### updateAttributes(attributes)

Updates a record with the given attributes, saving the record.

user = User.create()
user.updateAttributes(name: "Sir Galahad the Pure")

### destroy()

Destroys the record, removing it from the record store and triggering the destroy event.

user = User.create()

### user.destroy()
Destroy will also unbind event listeners for the model and objects it was listening to.

### dup()

Returns a new unsaved record, with the same attributes as the current record, save the ID, which will be null.

user = User.create(name: "Sir Bedevere")
dup  = user.dup()
assertEqual( dup.name, "Sir Bedevere" )

Returns a prototype clone of the record. This is used internally for Dynamic Records, and is probably not something you need to worry about.

### clone()

Returns a prototype clone of the record. This is used internally for Dynamic Records, and is probably not something you need to worry about.

### reload()

Reloads a record's attributes from its saved counterpart.

### toJSON()

Returns the record's attributes. This is used for JSON serialization:

record = new User(name: "Sir Lancelot the Brave")

assertEqual( JSON.stringify(record), '{"id":"foo","name":"Sir Lancelot the Brave"}' )

$.post("/record.json", JSON.stringify(record))

### toString()

Returns a string representation of the record. A utility function used to display the record in the console.

### exists()

Returns a boolean indicating whether the record has saved. Similar to isNew(), but it actually checks the models record store.

### bind(name, function)

Bind to an event specifically on this record. on is an available alias.

### trigger(name, [data...])

Trigger an event specifically on this record. This will propagate up to the model too.

### unbind([events, callback])

Unbind all events, or just certain events (as a comma seperated list), or a specific callback for given events. off is an available alias

### proxy(function)

A JavaScript compatibility function, that will wrap the given function so that it's always executed in the context of the record.


## Ajax

Model comes with an interface for Ajax or other connectors. Define the connector after creating the model with 

Model.ajax = AjaxConnector;

You can find a reference of a Connector in clay-model-vfr

Model.create( values, options ), modelInstance.save( options ) and modelInstance.destroy(options)

All take an options argument, here are some values

ignoreAjax: [true/false]: Will only make modifications locally without sending changes to the server.


## API

Used to execute custom API Calls, is defined by Ajax Connector

```
User.api( arguments... );



