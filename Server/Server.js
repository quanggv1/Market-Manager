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
    console.log('Error connecting to Db' + err);
    return;
  }
  console.log('Connection success');
});

/*============SQL Query==============*/
app.get('/getProduct', function(req, res) {
  con.query('SELECT * FROM product',function(err,rows){
    if(!!err) {
      console.log(err);
    } else {
        console.log('Data received from Db:\n');
        res.send(rows)
    }

  });
});

app.get('/getWareshouse', function(req, res) {
  con.query('SELECT * FROM wareshouse',function(err,rows){
    if(!!err) {
      console.log(err);
    } else {
        console.log('Data received from Db:\n');
        res.send(rows)
    }

  });
});

app.get('/getShop', function(req, res) {
  con.query('SELECT * FROM shop',function(err,rows){
    if(!!err) {
      console.log(err);
    } else {
        console.log('Data received from Db:\n');
        res.send(rows)
    }

  });
});


app.listen(5000);