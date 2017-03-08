var express = require('express');
var mysql = require("mysql");
var app = express();
var SQL = require('./sql');
var errorResp = { 'code': '400', 'status': 'error' };

// First you need to create a connection to the db
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: 'MarketManager'
});

con.connect(function (err) {
  if (err) {
    console.log('Error connecting to Db' + err);
    return;
  }
  console.log('Connect DB success');
});
app.listen(5000);

app.get('/authen', function (req, res) {
  SQL.authen(con, req, res);
});
app.get('/getShopProductList', function(req, res) {
  SQL.getShopProductList(con, req, res);
});
app.get('/getShopProductListByDate', function(req, res) {
  SQL.getShopProductListByDate(con, req, res);
});
app.get('/getOrderList', function(req, res) {
  SQL.getOrderList(con, req, res);
});
app.get('/getOrderListByDate', function(req, res) {
  SQL.getOrderListByDate(con, req, res);
});
app.get('/getOrderListByShopID', function(req, res) {
  SQL.getOrderListByShopID(con, req, res);
});
app.get('/updateOrder', function (req, res) {
  SQL.aupdateOrder(con, req, res);
});
app.get('/getData', function (req, res) {
  SQL.getData(con, req, res);
});

app.get('/insertData', function (req, res) {
  SQL.insertData(con, req, res);
});
app.get('/updateData', function (req, res) {
  SQL.updateData(con, req, res);
});
app.get('/deleteData', function (req, res) {
  SQL.deleteData(con, req, res);
});
