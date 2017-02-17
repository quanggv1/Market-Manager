var express = require('express');
var mysql = require("mysql");
var app = express();

// First you need to create a connection to the db
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: 'MarketManager'
});

con.connect(function(err){
  if(err){
    console.log('Error connecting to Db');
    return;
  }
  console.log('Connection success');
});


app.get('/getEmployees', function(req, res) {
  con.query('SELECT * FROM employees',function(err,rows){
    if(!!err) {
      console.log(err);
    } else {
        console.log('Data received from Db:\n');
        res.send(rows)
    }

  });
});


app.listen(5000);