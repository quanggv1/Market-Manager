var express = require('express');
var mysql = require("mysql");
var app = express();
var SQL = require('./sql');

// First you need to create a connection to the db
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: 'MarketManager'
});

con.connect(function(err){
  if(err){
    console.log('Error connecting to Db' + err);
    return;
  }
  console.log('Connect DB success');
});
app.listen(5000);


app.get('/getData', function(req, res) {
  SQL.getData(con, req, res);
});

app.get('/insertData', function(req, res) {
  SQL.insertData(con, req, res);
});
app.get('/updateData', function(req, res) {
  SQL.updateData(con, req, res);
});
app.get('/deleteData', function(req, res) {
  SQL.deleteData(con, req, res);
});
