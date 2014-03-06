describe("Ajax", function(){
  var User;
  var jqXHR;

  beforeEach(function(){
    //_3Model.Ajax.clearQueue();

    User = _3Model.Model.setup("User", ["first", "last"]);
    User.extend(_3Ajax);

  });

  it("can GET a collection on fetch", function(){

    server = sinon.fakeServer.create();
    
    User.fetch({test: "ok"}, { o: true } );

    User.bind("ajaxSuccess", function(response){ console.log(User.all()[0]) })
    
    
    server.requests[0].respond(
            200,
            { "Content-Type": "application/json" },
            JSON.stringify([{ first: "roberto", last: "Provide examples" }])
        );

    server.restore()

  });
  
  
  it("can GET a record on fetch", function(){
    server = sinon.fakeServer.create();
    
    User.refresh([{first: "John", last: "Williams", id: "IDD"}]);

    User.fetch({id: "IDD"});

    User.bind("ajaxSuccess", function(response){ console.log(response) })
    
    server.requests[0].respond(
        200,
        { "Content-Type": "application/json" },
        JSON.stringify( {first: "John", last: "Williams", id: "IDD"} )
    );

    server.restore()

  });

});
