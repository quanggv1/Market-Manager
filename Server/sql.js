
var Utils = require('./utils');
var PD = require('./product');

/*============SQL Query==============*/
module.exports = {
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

  getDataDefault: function (con, req, res) {
    var data = {};
    con.query('SELECT * FROM `crate_detail`', function (err, result) {
      if (err) {
        console.log(err);
        res.send(Utils.errorResp);
      } else {
        data.crate = result;
        con.query('SELECT * FROM `warehouse`', function (err, result) {
          if (err) {
            console.log(err);
            res.send(Utils.errorResp);
          } else {
            data.warehouse = result;
            con.query('SELECT * FROM `shop`', function (err, result) {
              if (err) {
                console.log(err);
                res.send(Utils.errorResp);
              } else {
                data.shop = result;
                var productTable = PD.getProductTableName(req.query.productType);
                con.query('SELECT * FROM ' + productTable, function (err, result) {
                  if (err) {
                    console.log(err);
                    res.send(Utils.errorResp);
                  } else {
                    data.product = result;
                    res.send({ code: 200, data: data });
                  }
                });
              }
            });
          }
        });
      }
    });
  },
};

