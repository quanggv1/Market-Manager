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

  // var targetFilePath = './uploads/products/Workbook1.csv';
  // convertCSV2Json(targetFilePath, function onSuccess(result) {
  //   req.query.tableName = 'warehouse_product';
  //   result.forEach(function (item) {
  //     req.query.params = item
  //     SQL.insertData(con, req, function (success) {
  //       console.log(result)
  //     }, function (error) {
  //       res.send(errorResp);
  //     })
  //   })
  // }, function onError(err) {
  //   res.send(errorResp);
  // })
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
 * warehouse management 
 * 
 * 
 * */
app.get('/getWarehouseProducts', function (req, res) {
  if (today() === req.query.date) {
    SQL.getWarehouseProducts(con, req, function (success) {
      res.send({ code: 200, data: success });
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    var targetFilePath = './uploads/warehouses/' + req.query.whName + req.query.date + '.csv';
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

app.get('/exportWarehouseProducts', function (req, res) {
  SQL.getWarehouseProducts(con, req, function onSuccess(result) {
    var targetFilePath = './uploads/warehouses/' + req.query.whName + today() + '.csv';
    convertJson2CSV(result, targetFilePath, function onSuccess() {
      res.send({ code: 200 });
    }, function onError() {
      res.send(errorResp);
    })
  }, function onError(error) {
    res.send(errorResp);
  })
})

app.get('/updateWarehouseProducts', function (req, res) {
  var warehouseProducts = JSON.parse(req.query.params)
  updateWarehouseProducts(warehouseProducts, res)
})

function updateWarehouseProducts(warehouseProducts, res) {
  var req = { query: {} }
  if (warehouseProducts.length > 0) {
    /** update order_each_day */
    req.query.tableName = 'warehouse_product';
    req.query.params = warehouseProducts[0]
    req.query.idName = 'wh_pd_ID';
    req.query.idValue = warehouseProducts[0].wh_pd_ID;
    SQL.updateData(con, req, function (success) {
      warehouseProducts = warehouseProducts.splice(1, warehouseProducts.length);
      updateWarehouseProducts(warehouseProducts, res);
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    res.send({ code: 200 });
  }
}

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

app.get('/getOrderDetail', function (req, res) {
  SQL.getOrderDetail(con, req, function (success) {
    res.send({ code: '200', data: success })
  }, function (error) {
    res.send(errorResp);
  })
})

app.get('/updateOrderDetail', function (req, res) {
  var productOrders = JSON.parse(req.query.params)
  SQL.getWarehouseNameList(con, function(success) {
    var warehouseNameList = [];
    success.forEach(function (item) {warehouseNameList.push(item.whName)});
    updateOrderDetail(productOrders, req.query.shopID, req.query.orderID, warehouseNameList, res)
  }, function(error) {
    res.send(errorResp);
  })
  
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

/** 
 * 
 * shop managerment 
 * 
 * */
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

app.get('/exportShopProducts', function (req, res) {
  var shopProductIDs = req.query.params[0].shopProductID;
  var stockTakes = req.query.params[0].stockTake;
  updateShopProduct(shopProductIDs, stockTakes, req, res);
});
app.get("/reportOrderEachday", function onSuccess(req, res) {
  var orderID = req.query.orderID;
  SQL.reportOrderEachday(con, orderID, function onError(success) {
    res.send({ code: 200, data: success });
  }, function (error) {
    res.send(errorResp);
  });
})

//private function
function updateShopProduct(shopProductIDs, stockTakes, req, res) {
  if (shopProductIDs.length > 0) {
    /** update data to database */
    SQL.updateShopProduct(con, { shopProductID: shopProductIDs[0], stockTake: stockTakes[0] }, function (success) {
      shopProductIDs = shopProductIDs.splice(1, shopProductIDs.length);
      stockTakes = stockTakes.splice(1, stockTakes.length);
      updateShopProduct(shopProductIDs, stockTakes, req, res);
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    /** export json to excel */
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
}

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
  var data = fs.readFileSync(filePath, { encoding: 'utf8' });
  var options = {
    delimiter: ',',// optional 
    quote: '"' // optional 
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

/**
 * 
 * 
 *  Crate management
 * 
 * 
 */
app.get('/getCrates', function (req, res) {
  if (today() === req.query.date) {
    SQL.getData(con, req, function (success) {
      res.send({ code: 200, data: success });
    }, function (error) {
      res.send(errorResp);
    });
  } else {
    var targetFilePath = './uploads/crates/crate_record' + req.query.date + '.csv';
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
})

app.get('/updateCrates', function (req, res) {
  var updates = JSON.parse(req.query.params);
  updateCrate(updates, res);
})

function updateCrate(updates, res) {
  var req = { query: {} };
  if (updates.length > 0) {
    req.query.tableName = 'crate';
    req.query.params = updates[0];
    req.query.idName = 'crateID';
    req.query.idValue = updates[0].crateID;
    SQL.updateData(con, req, function (success) {
      updates = updates.splice(1, updates.length);
      updateCrate(updates, res);
    }, function (error) {
      res.send(errorResp);
    })
  } else {
    res.send({ code: 200 });
  }
}

app.get('/exportCrates', function (req, res) {
  SQL.getData(con, req, function (success) {
    var targetFilePath = './uploads/crates/crate_record' + today() + '.csv';
    convertJson2CSV(success, targetFilePath, function onSuccess() {
      res.send({ code: 200 });
    }, function onError() {
      res.send(errorResp);
    })
  }, function (error) {
    res.send(errorResp);
  });
})

app.get('/getDataDefault', function (req, res) {
  SQL.getDataDefault(con, function(success) {
    res.send({code:200, data: success});
  }, function(error) {
    res.send(errorResp);
  })
})