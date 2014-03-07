describe("Ajax", function(){
  var User;
  var jqXHR;

  beforeEach(function(){
    //_3Model.Ajax.clearQueue();

    User = _3Model.Model.setup("User", ["first", "last"]);
    User.extend(_3Ajax);
    User.extend(_3Ajax.Auto);

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
  
  
  it("can GET a collection on fetch with query", function(){

    server = sinon.fakeServer.create();
    
    User.fetch( { query: { fields: ["id", "first", "last"], where: "name = 'test'" } } );

    User.one("ajaxSuccess", function(response){ 
      expect(User.last().first).toBe("carlos");
      expect(response.req.url).toBe("/users?fields=id%2Cfirst%2Clast&where=name%20%3D%20'test'")
      server.restore();
    })
    
    server.requests[0].respond(
        200,
        { "Content-Type": "application/json" },
        JSON.stringify([{ first: "carlos", last: "Provide examples", id: "IDDa" }])
    );

  });
  
  it("can GET a record on fetch", function(){
    server = sinon.fakeServer.create();
    
    User.refresh([{first: "John", last: "Williams", id: "IDD"}]);

    User.fetch({id: "IDD"});

    User.one("ajaxSuccess", function(response){ 
      expect(response.body.id).toBe("IDD");
      server.restore()
    });
    
    server.requests[1].respond(
      200,
      { "Content-Type": "application/json" },
      JSON.stringify( {first: "John", last: "Williams", id: "IDD"} )
    );

  });

  it("allows undeclared attributes from server", function(){
    User.refresh([{
      id: "12345",
      first: "Hans",
      last: "Zimmer",
      created_by: "rspine_user",
      created_at: "2013-07-14T14:00:00-04:00",
      updated_at: "2013-07-14T14:00:00-04:00"
    }]);

    expect(User.first().created_by).toEqual("rspine_user");
  });
  
  it("should send POST on create", function(){
    server = sinon.fakeServer.create();

    User.create({first: "Hans", last: "Zimmer", id: "IDD"}, { done: function(){ expect(this.id).toEqual("1") }});

    server.requests[0].respond(
      200,
      { "Content-Type": "application/json" },
      JSON.stringify( {first: "John", last: "Williams", id: "1"} )
    );

    
  });



});
