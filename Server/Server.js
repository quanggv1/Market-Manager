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
  console.log('Connect DB success');
});
app.listen(5000);

/*============SQL Query==============*/
app.get('/getData', function(req, res) {
  var table = req.query.tableName;
  con.query('SELECT * FROM ' + table, function(err,rows){
    if(!!err) {
      console.log(err);
    } else {
        console.log('Data received from Db:\n');
        res.send(rows)
    }

  });
});

/*insert*/
app.get('/insertData', function(req) {
  var table = req.query.tableName;
  console.log(table)
  var product = { productName: 'break'};
  con.query('INSERT INTO ' + table +' SET ?', product, function(err,res){
    if(err) {
      console.log(err);
    } else {
      console.log('Last insert ID:', res.insertId);
    }
  });
});
/*update */
app.get('/updateData', function(req) {
  var table = req.query.tableName;
  var product = { productName: 'Winnie'};
});




