var express = require('express');
var mysql = require("mysql");
var app = express();
var SQL = require('./sql');
var errorResp = { 'code': '400', 'status': 'error' };
var json2csv = require('json2csv');
var fs = require('fs');
var csvjson = require('csvjson');

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

/** shop managerment */
app.get('/getShopProductList', function (req, res) {
  if (today() === req.query.date) {
    SQL.getShopProductList(con, req, function onSuccess(result) {
      res.send({ code: '200', status: 'OK', data: result });
    }, function onError(error) {
      res.send(errorResp);
    })
  } else {
    var targetFilePath = './uploads/shops/' + req.query.shopName + req.query.date + '.csv';
    if (fs.existsSync(targetFilePath)) {
      convertCSV2Json(targetFilePath, function onSuccess(result) {
        res.send({ code: 200, data: result });
      }, function onError(err) {
        res.send(errorResp);
      })
    } else {
      res.send(errorResp);
    }
  }
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

/** export shop products */
app.get('/exportShopProducts', function (req, res) {
  if (req.query.date != today()) {
    res.send({ code: 300 });
  } else {
    SQL.getShopProductList(con, req, function onSuccess(result) {
      var targetFilePath = './uploads/shops/' + req.query.shopName + today() + '.csv';
      convertJson2CSV(result, targetFilePath, function onSuccess() {
        res.send({ code: 200 });
      }, function onError() {
        res.send(errorResp);
      })
    }, function onError(error) {
      res.send(errorResp);
    })
  }
});
function convertJson2CSV(json, targetFilePath, onSuccess, onError) {
  var csv = json2csv({ data: json, fields: null });
  fs.writeFile(targetFilePath, csv, function (err) {
    if (err) {
      onError();
    } else {
      onSuccess();
    }
  });
}
function convertCSV2Json(filePath, onSuccess, onError) {
  var data = fs.readFileSync(filePath, { encoding : 'utf8'});
  var options = {
    delimiter : ',' ,// optional 
    quote     : '"' // optional 
  };
  onSuccess(csvjson.toObject(data, options))
}

function today() {
  var date = new Date();
  var year = date.getFullYear();
  var month = date.getMonth() + 1;
  month = (month < 10 ? "0" : "") + month;
  var day = date.getDate();
  day = (day < 10 ? "0" : "") + day;
  date = year + '-' + month + '-' + day;
  return date;
}
