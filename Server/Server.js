var express = require('express');
var mysql = require("mysql");
var app = express();
var bodyParser = require('body-parser');
var multiparty = require('multiparty');

var Utils = require('./utils');
var SQL = require('./sql');
var SHOP = require('./shop');
var USER = require('./user');
var WH = require('./warehouse');
var CRATE = require('./crate');
var ORDER = require('./order');
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

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())


/** 
 * 
 * 
 * common api 
 * 
 * 
 * */
app.get('/getData', function (req, res) {
  SQL.getData(con, req, function (success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  });
});

app.get('/insertData', function (req, res) {
  SQL.insertData(con, req, function (success) {
    res.send({ code: 200, status: 'OK', data: { insertId: success.insertId } });
  }, function (error) {
    res.send(errorResp);
  });
});

app.get('/updateData', function (req, res) {
  SQL.updateData(con, req, function (success) {
    res.send({ code: 200 });
  }, function (error) {
    res.send(errorResp);
  });
});

app.get('/deleteData', function (req, res) {
  SQL.deleteData(con, req, res);
});

app.get('/getDataDefault', function (req, res) {
  SQL.getDataDefault(con, function (success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  })
})

/**
 *  SHOP 
 * */
app.get('/getShops', function (req, res) {
  SHOP.getShops(con, req, res);
})

app.get('/addNewShop', function (req, res) {
  SHOP.addNewShop(con, req, res);
})

app.get('/removeShop', function (req, res) {
  SHOP.removeShop(con, req, res);
})

app.get('/getShopProducts', function (req, res) {
  SHOP.getShopProducts(con, req, res);
})

app.get('/exportShopProducts', function (req, res) {
  SHOP.exportShopProducts(con, req, res);
})

app.get('/updateShopProducts', function (req, res) {
  SHOP.updateShopProducts(con, req, res);
})

/** USER */

app.get('/getUsers', function (req, res) {
  USER.getUsers(con, req, res);
})

app.get('/addNewUser', function (req, res) {
  USER.addNewUser(con, req, res);
})

app.get('/removeUser', function (req, res) {
  USER.removeUser(con, req, res);
})

app.get('/updateUser', function (req, res) {
  USER.updateUser(con, req, res);
})

app.get('/authen', function (req, res) {
  USER.authen(con, req, res);
});

/** WARE HOUSE */

app.get('/getWarehouseProducts', function (req, res) {
  WH.getWarehouseProducts(con, req, res);
});

app.get('/addNewWarehouse', function (req, res) {
  WH.addNewWarehouse(con, req, res);
})

app.get('/removeWarehouse', function (req, res) {
  WH.removeWarehouse(con, req, res);
})

app.get('/exportWarehouseProducts', function (req, res) {
  WH.exportWarehouseProducts(con, req, res);
})

app.get('/updateWarehouseProducts', function (req, res) {
  WH.updateWarehouseProducts(con, req, res);
})

app.get('/checkTotalWarehouseProduct', function (req, res) {
  WH.checkTotalWarehouseProduct(con, req, res);
});

/** CRATES */

app.get('/getCrates', function (req, res) {
  CRATE.getCrates(con, req, res);
})

app.get('/updateCrates', function (req, res) {
  CRATE.updateCrates(con, req, res);
})

app.get('/exportCrates', function (req, res) {
  CRATE.exportCrates(con, req, res);
})

/** ORDER */

app.get('/getOrderList', function (req, res) {
  ORDER.getOrders(con, req, res);
});

app.get("/reportOrderEachday", function (req, res) {
  ORDER.reportOrderEachday(con, req, res);
})

app.get('/addNewOrder', function (req, res) {
  ORDER.addNewOrder(con, req, res);
})

app.get('/updateNewOrder', function (req, res) {
  ORDER.updateNewOrder(con, req, res);
})

app.get('/getOrderDetail', function (req, res) {
  ORDER.getOrderDetail(con, req, res);
})

app.get('/updateOrderDetail', function (req, res) {
  ORDER.updateOrderDetail(con, req, res);
})

app.get('/invoiceProductByOrderID', function (req, res) {
  ORDER.invoiceProductByOrderID(con, req, res);
})

app.get("/reportSumOrderEachday", function onSuccess(req, res) {
  ORDER.reportSumOrderEachday(con, req, res);
})

app.get('/invoiceCratesByOrderID', function (req, res) {
  ORDER.invoiceCratesByOrderID(con, req, res);

  var urlencodedParser = bodyParser.urlencoded({ extended: false })
  app.post("/uploadInvoice", urlencodedParser, function (req, res) {
    var form = new multiparty.Form();

    form.parse(req, function (err, fields, files) {
      var targetFilePath = './uploads/invoices/' + files.files[0].originalFilename;
      fs.writeFile(targetFilePath, fs.readFileSync(files.files[0].path), "binary", function (err) {
        if (err) {
          console.log(errorResp)
          res.send(errorResp);
        } else {
          console.log("success")
          res.send({ code: 200, data: "success" });
        }
      });
    });
  });
})










