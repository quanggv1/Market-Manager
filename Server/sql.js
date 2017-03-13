var errorResp = { 'code': '400', 'status': 'error' };

/*============SQL Query==============*/
module.exports = {
  /*Authentication*/
  authen: function (con, req, res) {
    con.query('SELECT * FROM user WHERE userName = ? AND password = ?', [req.query.userName, req.query.password], function (error, rows) {
      if (error) {
        console.log(error);
        res.send(errorResp);
      } else {
        if (rows.length > 0) {
          console.log('OK');
          res.send({ 'code': '200', 'status': 'OK' });
        } else {
          res.send(errorResp);
        }
      }
    });
  },
  /*select warehouse's products*/
  getWareHouseProductList: function (con, req, onSuccess, onError) {
    var whID = req.query.whID;
    var sql = "SELECT product.productName, warehouse_product.wh_pd_ID, warehouse_product.sockTake, warehouse_product.outQuantity, warehouse_product.inQuantity, warehouse_product.total FROM warehouse_product JOIN product ON warehouse_product.p_ID=product.productID WHERE warehouse_product.wh_ID=?";
    con.query(sql, whID, function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
      }
    });
  },
  updateWareHouseProduct: function (con, params, onSuccess, onError) {
    con.query('UPDATE warehouse_product SET sockTake =?, outQuantity=?, inQuantity=?, total=sockTake+inQuantity-outQuantity WHERE wh_pd_ID=?', [params.stockTake, params.outQuantity, params.outQuantity, params.inQuantity, params.wh_pd_ID], function (err, result) {
      if (err) {
        onError(err);
      } else {
        onSuccess(result);
      }
    })
  },
  /*select shop's products*/
  getShopProductList: function (con, req, onSuccess, onError) {
    var shopID = req.query.shopID;
    var sql = "SELECT shop_product.shopProductID, shop_product.productID, shop_product.shopID, shop_product.stockTake, product.productName, product.price FROM shop_product JOIN product ON shop_product.productID = product.productID WHERE shop_product.shopID=?";
    con.query(sql, shopID, function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
      }
    });
  },

  updateShopProduct: function (con, params, onSuccess, onError) {
    con.query('UPDATE shop_product SET stockTake = ? WHERE shopProductID = ?', [params.stockTake, params.shopProductID], function (err, result) {
      if (err) {
        onError(err);
      } else {
        onSuccess(result);
      }
    })
  },

  /*select order list*/
  getOrderList: function (con, req, onSuccess, onError) {
    var shopID = req.query.shopID;
    console.log(shopID)
    var sql = 'SELECT * FROM orders  WHERE `shopID` = ?';
    con.query(sql, shopID, function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
      }
    });
  },

  getOrderDetail: function (con, req, onSuccess, onError) {
    var orderID = req.query.orderID;
    var sql = 'SELECT order_each_day.*, product.productName FROM `order_each_day` JOIN product ON order_each_day.productID = product.productID WHERE `orderID` = ?';
    con.query(sql, orderID, function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
      }
    });
  },


  /*select from table*/
  getData: function (con, req, res) {
    var table = req.query.tableName;
    con.query('SELECT * FROM ' + table, function (err, rows) {
      if (err) {
        console.log(err);
        res.send(errorResp);
      } else {
        console.log('Data received from Db:\n');
        res.send(rows)
      }
    });
  },
  /*insert to table*/
  insertData: function (con, req, onSuccess, onError) {
    var table = req.query.tableName;
    var query = req.query.params;
    con.query('INSERT INTO ' + table + ' SET ?', query, function (err, res) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        onSuccess(res)
      }
    });
  },
  /*update product description*/
  updateData: function (con, req, onSuccess, onError) {
    var table = req.query.tableName;
    var query = req.query.params;
    var idName = req.query.idName;
    var idValue = req.query.idValue;
    con.query('UPDATE ' + table + ' SET ? Where ' + idName + ' = ' + idValue, query,
      function (err, result) {
        if (err) {
          console.log(err);
          onError(err);
        } else {
          onSuccess(result)
          console.log(result);
        }
      }
    );
  },
  /*delete row*/
  deleteData: function (con, req, response) {
    var table = req.query.tableName;
    var params = req.query;
    var idName = req.query.params.idName;
    var idValue = req.query.params.idValue;
    con.query('DELETE FROM ' + table + ' WHERE ' + idName + ' = ?', [idValue],
      function (err, result) {
        if (err) {
          console.log(err);
          response.send(err);
        } else {
          console.log('Deleted ' + result.affectedRows + ' rows');
          if (result.affectedRows > 0) {
            response.send({ code: 200, status: 'success' });
          } else {
            response.send(errorResp)
          }
        }
      });
  },

  getWarehouseProducts: function (con, req, onSuccess, onError) {
    var whID = req.query.whID;
    var sql = "SELECT warehouse_product.*, product.productName FROM warehouse_product JOIN product ON warehouse_product.productID = product.productID WHERE whID = ?";
    con.query(sql, whID, function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
      }
    });
  },
  checkTotalWarehouseProduct: function (con, req, onSuccess, onError) {
    var pd_ID = req.query.params.productID;
    var whName = req.query.params.whName;
    console.log(req.query)
    console.log(pd_ID)
    console.log(whName)
    con.query('SELECT SUM(wh1) as total FROM order_each_day WHERE order_each_day.productID=24',[whName, pd_ID], function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
      }
    });
  },

  updateShopStock: function (con, shopID, productID, stockTake) {
    con.query('UPDATE shop_product SET stockTake = ? WHERE shopID = ? AND productID = ?', [stockTake, shopID, productID],
      function (err, result) {
        if (err) {
          console.log(err);
        } else {
          console.log(result);
        }
      }
    );
  },

  updateWarehouseStock: function (con, whID, productID, outQuantity) {
    con.query('UPDATE warehouse_product SET outQuantity = outQuantity + ?, total = total - ? WHERE whID = ? AND productID = ?', [outQuantity,outQuantity, whID, productID],
      function (err, result) {
        if (err) {
          console.log(err);
        } else {
          console.log(result);
        }
      }
    );
  },

  reportOrderEachday: function(con, orderID, onSuccess, onError) {
    var sql = 'SELECT product.productName, order_each_day.order_quantity, (order_each_day.wh1 + order_each_day.wh2 + order_each_day.wh3) as received,(order_each_day.wh1 + order_each_day.wh2 + order_each_day.wh3 - order_each_day.order_quantity) as quantity_need, (order_each_day.wh1 + order_each_day.wh2 + order_each_day.wh3 + order_each_day.stockTake) as total, order_each_day.crate_qty, order_each_day.crate_type FROM order_each_day JOIN product ON order_each_day.productID = product.productID WHERE order_each_day.orderID =?';
    con.query(sql, orderID, function(err, result) {
      if (err) {
          console.log(err);
          onError(err)  
        } else {
          console.log(result);
          onSuccess(result);
        }
    });
  }

};

