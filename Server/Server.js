var express = require('express');
var mysql = require("mysql");
var app = express();
var SQL = require('./sql');
var errorResp = { 'code': '400', 'status': 'error' };
var json2xls = require('json2xls');
var fs = require('fs');
var xlsx2json = require("xlsx-to-json-lc");

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

/** order managerment */
app.get('/getOrderList', function (req, res) {
  SQL.getOrderList(con, req, function (success) {
    res.send({ code: '200', data: success })
  }, function (error) {
    res.send(errorResp);
  });
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


/** shop managerment */
app.get('/getShopProductList', function (req, res) {
  if (today() === req.query.date) {
    SQL.getShopProductList(con, req, function onSuccess(result) {
      res.send({ code: '200', status: 'OK', data: result });
    }, function onError(error) {
      res.send(errorResp);
    })
  } else {
    var targetFilePath = './uploads/shops/' + req.query.shopName + req.query.date + '.xlsx';
    if (fs.existsSync(targetFilePath)) {
      convertXlsx2Json(targetFilePath, function onSuccess(result) {
        console.log(result);
        res.send({ code: 200, data: result });
      }, function onError(err) {
        res.send(errorResp);
      })
    } else {
      res.send(errorResp);
    }
  }
});

app.get('/exportShopProducts', function (req, res) {
  var updates = req.query.params;
  var shopProductIDs = updates[0].shopProductID;
  var stockTakes = updates[0].stockTake;
  updateShopProduct(shopProductIDs, stockTakes, req, res);
});

function updateShopProduct(shopProductIDs, stockTakes, req, res) {
  if (shopProductIDs.length > 0) {
    /** update data to database */
    SQL.updateShopProduct(con, { shopProductID: shopProductIDs[0], stockTake: stockTakes[0] }, function (success) {
      shopProductIDs = shopProductIDs.splice(1, shopProductIDs.length);
      stockTakes = stockTakes.splice(1, stockTakes.length);
      console.log(shopProductIDs[0]);
      updateShopProduct(shopProductIDs, stockTakes, req, res);
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    /** export json to excel */
    SQL.getShopProductList(con, req, function onSuccess(result) {
      var targetFilePath = './uploads/shops/' + req.query.shopName + today() + '.xlsx';
      convertJson2Xlsx(result, targetFilePath, function onSuccess() {
        res.send({ code: 200 });
      }, function onError() {
        res.send(errorResp);
      })
    }, function onError(error) {
      res.send(errorResp);
    })
  }
}

function convertJson2Xlsx(json, targetFilePath, onSuccess, onError) {
  var xls = json2xls(json);
  fs.writeFile(targetFilePath, xls, 'binary', function (err) {
    if (err) {
      onError();
    } else {
      onSuccess();
    }
  })
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
