var request = require('supertest')
  , express = require('express');

var app = express();

app.get('/user', function(req, res){
  res.send(200, { name: 'tobi' });
});

request(app)
  .get('/user')
  .expect('Content-Type', /json/)
  .expect('Content-Length', '20')
  .expect(200)
  .end(function(err, res){
    if (err) throw err;
  });