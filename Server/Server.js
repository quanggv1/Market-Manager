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

app.get('/authen', function (req, res) {
  SQL.authen(con, req, res);
});

app.get('/checkTotalWarehouseProduct', function (req, res) {
  SQL.checkTotalWarehouseProduct(con, req, function (success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  })
});

/** 
 * 
 * 
 * order management 
 * 
 * 
 * */
app.get('/getOrderList', function (req, res) {
  SQL.getOrderList(con, req, function (success) {
    res.send({ code: '200', data: success })
  }, function (error) {
    res.send(errorResp);
  });
});

app.get('/addNewOrder', function (req, res) {
  var productOrders = JSON.parse(req.query.params);
  addNewOrder(productOrders, req.query.orderID, res);
})

function addNewOrder(productOrders, orderID, res) {
  var req = { query: {} };
  if (productOrders.length > 0) {
    /** insert product order into order_each_day */
    req.query.tableName = 'order_each_day';
    req.query.params = productOrders[0];
    SQL.insertData(con, req, function (success) {
      productOrders = productOrders.splice(1, productOrders.length);
      addNewOrder(productOrders, orderID, res);
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    /** update order table after insert into order_each_day */
    req.query.tableName = 'orders';
    req.query.params = {};
    req.query.params.status = 1;
    req.query.idName = 'orderID';
    req.query.idValue = orderID;
    SQL.updateData(con, req, function (success) {
      res.send({ code: 200 });
    }, function (error) {
      res.send(errorResp);
    })
  }
}

app.get('/getOrderDetail', function (req, res) {
  SQL.getOrderDetail(con, req, function (success) {
    res.send({ code: '200', data: success })
  }, function (error) {
    res.send(errorResp);
  })
})

app.get('/updateOrderDetail', function (req, res) {
  var productOrders = JSON.parse(req.query.params)
  SQL.getWarehouseNameList(con, function (success) {
    var warehouseNameList = [];
    success.forEach(function (item) { warehouseNameList.push(item.whName) });
    updateOrderDetail(productOrders, req.query.shopID, req.query.orderID, warehouseNameList, res)
  }, function (error) {
    res.send(errorResp);
  })
})

function updateOrderDetail(productOrders, shopID, orderID, warehouseNameList, res) {
  var req = { query: {} }
  if (productOrders.length > 0) {
    /** update order_each_day */
    req.query.tableName = 'order_each_day';
    delete productOrders[0].productName;
    req.query.params = productOrders[0];
    req.query.idName = 'productOrderID';
    req.query.idValue = productOrders[0].productOrderID;

    SQL.getOrderDetailByID(con, productOrders[0].productOrderID, function (success) {
      var data = success[0];
      var totalReceived = 0;

      /** update wh_product */
      warehouseNameList.forEach(function (item) {
        var thisWhReceived = req.query.params[item] - data[item];
        console.log(thisWhReceived);
        updateWarehouseStock(item, req.query.params.productID, thisWhReceived)
        totalReceived += thisWhReceived;
      })

      /** update shop_product */
      updateShopStock(shopID, req.query.params.productID, totalReceived);

      /** update crate */
      var crateReceived = req.query.params.crate_qty - data.crate_qty;
      SQL.updateCrateReceivedQty(con, crateReceived, req.query.params.crateType);

      /** update order_each_day */
      SQL.updateData(con, req, function (success) {
        productOrders = productOrders.splice(1, productOrders.length);
        updateOrderDetail(productOrders, shopID, orderID, warehouseNameList, res);
      }, function (error) {
        res.send(errorResp);
      })
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    /** update order table after update order_each_day */
    req.query.tableName = 'orders';
    req.query.params = {};
    req.query.params.status = 1;
    req.query.idName = 'orderID';
    req.query.idValue = orderID;
    SQL.updateData(con, req, function (success) {
      res.send({ code: 200 });
    }, function (error) {
      res.send(errorResp);
    })
  }
}

function updateShopStock(shopID, productID, receivedQty) {
  SQL.updateShopStock(con, shopID, productID, receivedQty);
}

function updateWarehouseStock(whName, productID, outQuantity) {
  SQL.updateWarehouseStock(con, whName, productID, outQuantity);
}

app.get("/reportOrderEachday", function onSuccess(req, res) {
  var orderID = req.query.orderID;
  SQL.reportOrderEachday(con, orderID, function onError(success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  });
})
app.get("/reportSumOrderEachday", function onSuccess(req, res) {
  console.log(req.query)
  var tempDate = req.query.date;
  SQL.reportSumOrderEachday(con, tempDate, function onError(success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  });
})
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

app.get('/invoiceProductByOrderID', function (req, res) {
  SQL.invoiceProductByOrderID(con, req, function (success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  });
})

app.get('/invoiceCratesByOrderID', function (req, res) {
  SQL.invoiceCratesByOrderID(con, req, function (success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  });

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









