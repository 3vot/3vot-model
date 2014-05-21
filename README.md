**Documentation**

Clay uses an MVC framework to build Javascript web applications that
fully communicate and integrate with Salesforce. This framework is the
3VOT-Model NPM package, which serves as the base to your apps, and the
core of its MVC architecture is based on the Spine.js framework.

Spine.js Framework integrates class support for Javascript, as
internally it uses CoffeeScript classes, which can be used in 3vot Model
aswell.

\

If you need guidance for more advanced coding patterns and structures
and can’t find it here yet, you can refer to Spine.js documentation, or
send us an e-mail, to which we’ll be happy to answer. 

\

**Directory structure of the model app**

\

\

|-app

|-assets

|-code

|  |-controllers

|  |-models

|  |-views

|-node\_modules

|  |-3vot

|  |-3vot-model

|  |-jqueryify

|-start

|  |-3vot.js

|  |-desktop.js

|  |-phone.js

|  |-tablet.js

|-templates

|  |-head.html

|  |-layout.html

|-package.json

\

**App folder** is where the compiled app goes. Don’t edit the files in
this folder. They will be overwritten everytime the app is compiled.
(folder is not showing expanded).

\

**Assets folder** is where you put the assets for your app, such as
images and stylesheets. It’s empty by default when the app is created.

\

**Code folder** is where you should put all your scripts files, such as
the controllers, models and views files for the 3VOT Model. On the root
of the code folder is the index.js file, which is the main controller
that gets called when the app starts and where you can define the models
and controllers to be used and initialized, as well as making initial
data requests to Salesforce.

\

**Node\_modules** is the directory for your dependencies (not showing
expanded), which are defined on the package.json file on the root of
your app folder. By default, Clay requires 3VOT, 3VOT-Model and
Jqueryify packages. To install dependencies for your app, see below
reference for package.json file.

\

**Start folder** is where you setup how you want your app to show in
each platform. 

3vot.js is the main app starter file, and desktop.js, phone.js and
tablet.js is where you define the controllers and layouts for each of
this platforms, and whether you need to login oAuth providers, define
api tokens, etc.

\

**Templates folder** is where you have the head and layout html files
for you app. If your app has different layouts for different platforms,
this is where you should store them. Note that inside layout.html or
head.html you need not to include \<head\> or \<body\> tags, and while
having different layouts, it’s not possible to change the head file for
every one of them, it has to be the same.

\

Package.json file is where you define your dependencies and other
compile options for your app:

"**platforms**": "The file that will be dynamically loaded once we know
the screen size. Located in the /start folder";

"**extensions**": "Compile Option: require files with using it's
extension";

"**transforms**": "Compile Option: The NPM Browserify Transforms applied
when compiling App";

"**external**": "Performance Option: Allows to extract the common
depedencies between apps ex: jquery, cache and speed all apps";

"**gitDependencies**": "Bower and Github based Libraries that can be
required within an app. ex: Angular";

"**dependencies**": "NPM Browser Compatible Dependencies that can be
required within an app. ex: 3vot-model";

\

\

**3VOT-Model MVC specifics**

\

**Models **

Models should be the viewed only as a connector to Salesforce, and
should not include other logics, such as controller logic. Inside the
Model file you should only declare the model and the fields required, 
HYPERLINK "http://nodejs.org/api/modules.html" \\l
"modules\_module\_exports" and then export it to be required by the
controllers.

Model data is obtained through Ajax connection to Salesforce.

**Implementation**

3vot-model is an NPM Dependency that connects with Visualforce API
Controller.

\

Hence, it’s necessary to initiate it, by requiring 3vot-model on your
model file.

var \_3Model = require("3vot-model");

\

After that, we have to create a model, which is done by subclassing the
3vot-model Model object through the setup method, passing the desired
model name (string) and the desired attributes:

NewModel = \_3Model.Model.*setup*("ModelName", “attribute1”, “attribute
2”, …, “attribute n”);

\

This Model is a constructor for new instances of the model.

\

For better standards, we advise on the following code structure:

//Declare the desired attributes inside an array

var fields = [“attribute1”, “attribute 2”, …, “attribute n”];

\

//Create the Model

NewModel = \_3Model.Model.*setup*("ModelName", fields);

\

**Methods and classes can be added to the model.**

\

Use the extend method for adding/overriding class methods, and the
include method to add/override instance methods.

NewModel.extend({

  find: function(){

    /\* ... \*/ 

  }

});

\

NewModel.find(); //calling the new method 

\

NewModel.include({

  name: "Default Name"

});

\

((new NewModel).name === "Default Name" ); //returns true

\

**New Model Instances and Classes**

\

You can create new Model instances using the constructor method, via
new:

\

var model = new Model({object\_attributes: “optional”});

\

You can also utilize the Model.create method:

\

var model = Model.create({object\_attributes: “optional”});

\

\

To add classes to Models, use the Model.setup method:

\

NewModel = \_3Model.Model.setup("NewModel", fields);

\

NewModel.Setup(“NewModelName”);

\

Saving and Retrieving Objects

\

\

\

**Saving and retrieving records**

\

Saving and updating

var \_3Model = require("3vot-model") //requiring npm package

var fields = ["Name","Type", "Website"] // declaring the fields

Account = \_3Model.Model.setup("Account", fields); // creating the
account Model

\

var account = new Account({first\_name: “John”, last\_name: “Smith”});
//Account.create(); can be used aswell

\

account.save(); //Saves the object in Salesforce.

\

When you save the instance, an id property is created for the object if
one isn’t created already. 

\

If you change a property, use the same method to update the model.

\

account.last\_name  = “Doe”;

\

account.save(); //

\

account; // {first\_name: “John”, last\_name: “Doe”}

Retrieving Records

\

Model Methods to retrieve matching instances: 

.first(integer(opcional)), ex: Account.first(); / Account.first(10);

.last(integer(opcional)), ex: Account.last(); / Account.last(3);

.all(), ex: Account.all()

.splice(start\_position(integer, optional), ex: Account.splice(10); /
Account.splice(2,6);

.each(CallbackFunction()) – the function should be returning
this.desiredProperty or argument.desiredPropery, ex: return
account.firstname; This iterates every record on the model, and returns
their disered property values

ex: 

Account.each(CallbackFunction(account) {

  return account.first\_name;

});

\

.select(function()) – will select the instances that have the property
you 

ex:

Account.select(function(account) {

  return account.first\_name;

});

\

\

**EVENTS**

****\

It’s easy to implement callback functions on Model events. Using the
Model.bind method, callbacks will be automatically associated.

\

Use: Model.bind(“event”,callbackFunction());

 

Available events:

save - record was saved (either created/updated)

update - record was updated

create - record was created

destroy - record was destroyed

change - any of the above, record was created/updated/destroyed

refresh - when records are invalidated or appended using the refresh
method

error - validation failed

 

ex: PartyGuests.bind(“create”,buyMoreBooze());

\

You can trigger events manually with the Model.trigger method, passing
as arguments the event and the arguments required for the callback
function thats going to be executed. You can use this to create custom
events.

\

You can use the Model.listenTo method to have objects waiting for events
on other objects. Use Model.listenTo(object,”event”,callbackFunction());
ex:
Invites.listenTo(PartyGuests,”create”,sendInvitationEmail(newPartyGuest));

\

Model.ListenToOnce will be listening for the next time the event occurs,
and only that one. Same arguments as the previous model.

\

Events can be unbind using Model.unbind method.

For deeper incursion on the SpineJs Models:
http://spinejs.com/api/models

\

\

**Controllers**

\

Generally, controllers deal with adding and responding to DOM events,
rendering templates and keeping views and models in sync.

\

To connect to the DOM objects, 3vot Model, like Spine, uses the el
property. El represents the current controller's HTML element, and is
instantiated when the former is first created. You can attribute el to
CSS classes or HTML tags. You assign the el object property as argument
when instanciating, or later:

var contacts = Contact.create({el: \$(“div\>li”)}); //JQuery selector

var Contact.el = \$(".contact-list"); 

var Contact.el = \$("\#contactThingy");

\

The el property should be attached to a html tag, which is stored on the
Model’s tag property. By default it’s set to “div”, but you can change
it:

\

var Contact.tag = “li”;

\

**3Vot Model has events on controllers too**

****\

Just set the events property to an array of object literals, in the
following format: {"eventType selector": "functionName"}. If no selector
is provided, then the event will be set directly on el. Otherwise the
events will be delegated to any of el's children matching the selector.

\

\

**Model methods apply to controllers as well.**

****\

**Controller methods which change el and elements property.**

\

Controller.html(html)

\

Replaces el's property’s html by passing in either a piece of HTML, a
jQuery element, or another controller instance. 

\

Controller.append(elementOrController)

\

Appends the given element, or controller instance, to el property. 

\

Controller.appendTo(elementOrController)

\

Appends el property to the given element or controller instance.

\

Controller.prepend(elementOrController)

\

Prepends el to the given element or controller instance.

\

replace(element)

\

Replaces el’s current value with the given element.

\

**Views / Templates**

\

Views are defined through small html templates that get dinamically
rendered and refreshed.

\

3vot Model uses  HYPERLINK "https://github.com/sstephenson/eco" Eco:
Embedded CoffeeScript templates for its ease of use and
integration/versatility, compiling the templates via node.js.

\

To compile the views, you have to require it and than pass it the Model
instances to fill the assigned el elements, passing them to the html.
Like so:

\

render: function(){

  var accounts = Account.all();

  var tempEl = "";

  for(index in accounts){

    var account = accounts[index];

    tempEl += accountItemTemplate(account); //returns each rendered
template as a string

  }

  el.html( tempEl ); //updates the el.property’s element in the app’s
html.

}

\

For more info, you should refer to the website for more information on
the use, but here are a few importante directions on integrating it on
.eco template files:

\

\<% expression %\>: Evaluate a CoffeeScript expression without printing
its return value.

\<%= expression %\>: Evaluate a CoffeeScript expression, escape its
return value, and print it.

\<%- expression %\>: Evaluate a CoffeeScript expression and print its
return value without escaping it.

\<%= @property %\>: Print the escaped value of the property property
from the context object passed to render.

\<%= @helper() %\>: Call the helper method helper from the context
object passed to render, then print its escaped return value.

\<% @helper -\> %\>...\<% end %\>: Call the helper method helper with a
function as its first argument. When invoked, the function will capture
and return the content ... inside the tag.

\<%% and %%\> will result in a literal \<% and %\> in the rendered
template, respectively.

\

An exemple for a Salesforce contact list template view:

\

\<li class="list-group-item contact-item"\>

  \<span data-id="\<%= @id %\>" class="editable btn\_edit"\>

    \<%= @Name %\>

    \<%= @Email%\>

  \</span\>

  \<span class="badge btn\_delete" data-id="\<%= @id %\>"\>x\</span\>

\</li\>

\

If you need to use JQuery to manipulate your templates DOM, just use a
.jeco extension for your template file instead of .eco.

