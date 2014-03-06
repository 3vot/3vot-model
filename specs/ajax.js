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

    User.one("ajaxSuccess", function(response){ 
      expect(User.first().first).toBe("roberto");
      server.restore();
    })
    
    server.requests[0].respond(
        200,
        { "Content-Type": "application/json" },
        JSON.stringify([{ first: "roberto", last: "Provide examples" }])
    );



  });
  
  
  it("can GET a record on fetch", function(){
    server = sinon.fakeServer.create();
    
    User.refresh([{first: "John", last: "Williams", id: "IDD"}]);

    User.fetch({id: "IDD"});

    User.one("ajaxSuccess", function(response){ 
      server.restore()
      expect(response.body.id).toBe("IDD");
    });
    
    server.requests[1].respond(
      200,
      { "Content-Type": "application/json" },
      JSON.stringify( {first: "John", last: "Williams", id: "IDD"} )
    );


  });

});
