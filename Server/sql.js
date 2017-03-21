var errorResp = { 'code': '400', 'status': 'error' };



var getWarehouseNameList = function (con, onSuccess, onError) {
  con.query('SELECT whName FROM warehouse', function (err, rows) {
    if (err) {
      console.log(err);
      onError(err);
    } else {
      console.log('Data received from Db:\n');
      onSuccess(rows);
    }
  });
}

var getShopNameList = function (con, onSuccess, onError) {
  con.query('SELECT shopName FROM shop', function (err, rows) {
    if (err) {
      console.log(err);
      onError(err);
    } else {
      console.log('Data received from Db:\n');
      onSuccess(rows);
    }
  })
}

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
          res.send({ 'code': '200', 'data': rows[0] });
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
    sql = 'SELECT order_each_day.*, product.productName FROM `order_each_day` JOIN product ON order_each_day.productID = product.productID WHERE `orderID` = ?';
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

  getOrderDetailByID: function (con, productOrderID, onSuccess, onError) {
    sql = 'SELECT * FROM `order_each_day` WHERE `productOrderID` = ?';
    con.query(sql, productOrderID, function (err, rows) {
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
  getData: function (con, req, onSuccess, onError) {
    var table = req.query.tableName;
    con.query('SELECT * FROM ' + table, function (err, rows) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        console.log('Data received from Db:\n');
        onSuccess(rows);
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
    var pd_ID = req.query.productID;
    var whName = req.query.whName;
    var receivedQty = req.query.receivedQty;
    con.query('SELECT total FROM warehouse_product WHERE whID IN(SELECT whID FROM warehouse WHERE whName = ?) AND productID = ?', [whName, pd_ID], function (err, result) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        if (!result || result.length == 0 || receivedQty > result[0].total) {
          onError()
        } else {
          onSuccess()
        }
      }
    });
  },

  updateShopStock: function (con, shopID, productID, receivedQty) {
    con.query('UPDATE shop_product SET stockTake = stockTake + ? WHERE shopID = ? AND productID = ?', [receivedQty, shopID, productID],
      function (err, result) {
        if (err) { console.log(err) }
      }
    );
  },

  updateWarehouseStock: function (con, whName, productID, outQuantity) {
    var sql = 'UPDATE warehouse_product SET outQuantity = outQuantity + ?, total = total - ? WHERE whID IN(SELECT whID FROM warehouse WHERE whName = ?) AND productID = ?';
    con.query(sql, [outQuantity, outQuantity, whName, productID],
      function (err, result) {
        if (err) { console.log(err) }
      }
    );
  },

  reportOrderEachday: function (con, orderID, onSuccess, onError) {
    var receivedTotalQuery = '';
    getWarehouseNameList(con, function (success) {
      success.forEach(function (item) {
        var whName = item.whName;
        receivedTotalQuery = receivedTotalQuery + ' order_each_day.`' + whName + '` +';
      })
      receivedTotalQuery = receivedTotalQuery.slice(0, receivedTotalQuery.length - 1);
      sql = 'SELECT product.productName, order_each_day.order_quantity, (' + receivedTotalQuery + ') as received, (order_each_day.order_quantity - (' + receivedTotalQuery + ')) as quantity_need, (' + receivedTotalQuery + ' + order_each_day.stockTake) as total, order_each_day.crate_qty, order_each_day.crateType FROM order_each_day JOIN product ON order_each_day.productID = product.productID WHERE order_each_day.orderID =?'
      console.log(sql);
      con.query(sql, orderID, function (err, result) {
        if (err) {
          console.log(err);
          onError(err)
        } else {
          console.log(result);
          onSuccess(result);
        }
      });
    }, function (error) {
      onError(error);
    })

  },

  getDataDefault: function (con, onSuccess, onError) {
    var data = {};
    con.query('SELECT * FROM `crate`', function (err, result) {
      if (err) {
        console.log(err);
        onError(err)
      } else {
        data.crate = result;
        con.query('SELECT * FROM `warehouse`', function (err, result) {
          if (err) {
            console.log(err);
            onError(err)
          } else {
            data.warehouse = result;
            con.query('SELECT * FROM `shop`', function (err, result) {
              if (err) {
                console.log(err);
                onError(err)
              } else {
                data.shop = result;
                con.query('SELECT * FROM `product`', function (err, result) {
                  if (err) {
                    console.log(err);
                    onError(err)
                  } else {
                    data.product = result;
                    onSuccess(data);
                  }
                });
              }
            });
          }
        });
      }
    });

  },

  updateCrateReceivedQty: function (con, crateReceived, crateType) {
    con.query('UPDATE crate SET receivedQty = receivedQty + ? WHERE crateType = ?', [crateReceived, crateType], function (err, result) {
      if (err) { console.log(err) }
    })
  },

  insertNewWarehouse: function (con, req, onSuccess, onError) {
    var whName = req.query.whName;
    var whDesc = req.query.description;
    con.query('INSERT INTO warehouse SET whName = ?, description = ?', [whName, whDesc], function (err, result) {
      if (err) {
        onError(err);
      } else {
        var insertedID = result.insertId;
        con.query('ALTER TABLE order_each_day ADD ' + whName + ' int NOT NULL', function (err, result) {
          if (err) {
            onError(err);
            con.query('DELETE FROM warehouse WHERE whID = ?', insertedID, function (err) {
              console.log(err);
            });
          } else {
            onSuccess(insertedID);
          }
        })
      }
    })
  },

  removeWarehouse: function (con, req, onSuccess, onError) {
    var whName = req.query.whName;
    con.query('ALTER TABLE order_each_day DROP COLUMN ' + whName, function (err) {
      if (err) {
        console.log(err);
        onError(err);
      } else {
        con.query('DELETE FROM warehouse WHERE whName = ?', whName, function (err) {
          if (err) {
            console.log(err);
            onError(err);
          } else {
            onSuccess()
          }
        })
      }
    })
  },

  getWarehouseNameList,

  invoiceProductByOrderID: function (con, req, onSuccess, onError) {
    var orderID = req.query.orderID;
    sql = "SELECT product.productName as name, product.price, order_each_day.order_quantity as quantity, Round((product.price * order_each_day.order_quantity),2) as total from order_each_day JOIN product ON product.productID = order_each_day.productID and order_each_day.orderID=?";
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

  invoiceCratesByOrderID: function (con, req, onSuccess, onError) {
    var orderID = req.query.orderID;
    sql = "SELECT crate.crateType as name, crate.price, sum(order_each_day.crate_qty) as quantity, Round((crate.price * sum(order_each_day.crate_qty)),2) as total from order_each_day JOIN crate ON crate.crateType = order_each_day.crateType and order_each_day.orderID=? GROUP BY crate.crateType";
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

  updateUserInfo: function (con, req, onSuccess, onError) {
    var query = req.query.params;
    con.query('UPDATE user SET ? Where userID = ' + query.userID, query,
      function (err, result) {
        if (err) {
          console.log(err);
          onError(err);
        } else {
          onSuccess(result)
        }
      }
    );
  }
};

