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
  /*select shop's products*/
  getShopProductList: function (con, req, onSuccess, onError) {
    var shopID = req.query.shopID;
    var sql = "SELECT shop_product.productID, shop_product.shopID, shop_product.stockTake, product.productName, product.price FROM shop_product JOIN product ON shop_product.productID = product.productID WHERE shop_product.shopID=?";
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

  /*select order list*/
  getOrderList: function (con, req, res) {
    var sql = "SELECT order.order_ID, order.shop_ID, shop.shopName, order_each_day.order_quantity FROM order JOIN shop ON order.shop_ID = shop.shopID JOIN order_each_day ON order.order_ID = order_each_day.oderID";
    con.query(sql, function (err, rows) {
      if (err) {
        console.log(err);
        res.send(errorResp);
      } else {
        console.log('Data received from Db:\n');
        res.send({ code: '200', status: 'OK', data: rows });
      }
    });
  },
  /*select order list by shop*/
  getOrderListByShopID: function (con, req, res) {
    var shopID = req.query.shopID;
    var sql = "SELECT order.order_ID, order.shop_ID, shop.shopName, order_each_day.order_quantity FROM order JOIN shop ON order.shop_ID = shop.shopID JOIN order_each_day ON order.order_ID = order_each_day.oderID WHERE order.shop_ID=?";
    con.query(sql, shopID, function (err, rows) {
      if (err) {
        console.log(err);
        res.send(errorResp);
      } else {
        console.log('Data received from Db:\n');
        res.send({ code: '200', status: 'OK', data: rows });
      }
    });
  },

  /*select order list by date*/
  getOrderListByDate: function (con, req, res) {
    var strDate = req.query.date;
    var sql = "SELECT order.order_ID, order.shop_ID, shop.shopName, order_each_day.order_quantity FROM order JOIN shop ON order.shop_ID = shop.shopID JOIN order_each_day ON order.order_ID = order_each_day.oderID WHERE order.date=?";

    con.query(sql, strDate, function (err, rows) {
      if (err) {
        console.log(err);
        res.send(errorResp);
      } else {
        console.log('Data received from Db:\n');
        res.send({ code: '200', status: 'OK', data: rows });
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
  insertData: function (con, req, response) {
    var table = req.query.tableName;
    var query = req.query.params;
    con.query('INSERT INTO ' + table + ' SET ?', query, function (err, res) {
      if (err) {
        console.log(err);
        response.send(errorResp);
      } else {
        response.send({ code:200, status: 'OK', data: { insertId: res.insertId } });
      }
    });
  },
  /*update product description*/
  updateData: function (con, req, res) {
    var table = req.query.tableName;
    var params = req.query.params;
    var idName = params.idName;
    var idValue = params.idValue;
    con.query(
      'UPDATE ' + table + ' SET description = ?, productName = ?, price = ? Where ' + idName + ' = ?',
      [params.description, params.productName, params.price, idValue],
      function (err, result) {
        if (err) {
          console.log(err);
          res.send(err);
        } else {
          console.log('Changed ' + result.changedRows + ' rows');
          res.send(result);
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
          if (result.changedRows > 0) {
            response.send({ 'code': 200, 'status': 'success' });
          } else {
            response.send(errorResp)
          }
        }
      });
  },

};

