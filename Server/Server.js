var express = require('express');
var mysql = require("mysql");
var app = express();
var SQL = require('./sql');
var errorResp = { 'code': '400', 'status': 'error' };
var json2xls = require('json2xls');
var fs = require('fs');
var xlsx2json = require("xlsx-to-json-lc");

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
  // convertXlsx2Json("./uploads/products/shop-products.xlsx", function callbacnSuccess(result) {
  //   req.query.tableName = "shop_product";
  //   result.forEach(function(item) {
  //     req.query.params = item;
  //     SQL.insertData(con, req, res);
  //   })
  // }, function callbackError(result) {

  // });
  SQL.authen(con, req, res);
});

function convertJson2Xlsx(json, targetFilePath) {
  var xls = json2xls(json);
  fs.writeFileSync(targetFilePath, xls, 'binary')
  // fs.writeFileSync('data.xlsx', xls, 'binary');
}

function convertXlsx2Json(filePath, onSuccess, onError) {
  xlsx2json({
    input: filePath,
    output: null,
    lowerCaseHeaders: false
  }, function (err, result) {
    if (err) {
      onError(err);
    } else {
      onSuccess(result)
    }
  });
}
/** shop managerment */
app.get('/getShopProductList', function (req, res) {
  SQL.getShopProductList(con, req, res);
});
/** order managerment */
app.get('/getOrderList', function (req, res) {
  SQL.getOrderList(con, req, res);
});
app.get('/getOrderListByDate', function (req, res) {
  SQL.getOrderListByDate(con, req, res);
});
app.get('/getOrderListByShopID', function (req, res) {
  SQL.getOrderListByShopID(con, req, res);
});
app.get('/updateOrder', function (req, res) {
  SQL.aupdateOrder(con, req, res);
});
/** common api */
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
