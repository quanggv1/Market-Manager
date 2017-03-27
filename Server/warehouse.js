var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

function executeSelectWarehouseProducts(con, req, onSuccess, onError) {
    var whID = req.query.whID;
    var sql = "SELECT warehouse_product.*, product.productName FROM warehouse_product JOIN product ON warehouse_product.productID = product.productID WHERE whID = ?";
    con.query(sql, whID, function (err, rows) {
        if (err) {
            console.log(err);
            onError(err);
        } else {
            onSuccess(rows);
        }
    });
}

var getWarehouseProducts = function (con, req, res) {
    if (Utils.today() === req.query.date) {
        executeSelectWarehouseProducts(con, req, function (success) {
            res.send({ code: 200, data: success });
        }, function (error) {
            res.send(Utils.errorResp);
        })
    } else {
        var targetFilePath = './uploads/warehouses/' + req.query.whName + req.query.date + '.csv';
        if (fs.existsSync(targetFilePath)) {
            Utils.convertCSV2Json(targetFilePath, function onSuccess(result) {
                res.send({ code: 200, data: result });
            }, function onError(err) {
                res.send(Utils.errorResp);
            })
        } else {
            res.send(Utils.errorResp);
        }
    }
}

var addNewWarehouse = function (con, req, res) {
    var whName = req.query.whName;
    var whDesc = req.query.description;
    con.query('INSERT INTO warehouse SET whName = ?, description = ?', [whName, whDesc], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            var insertID = result.insertId;
            con.query('ALTER TABLE order_each_day ADD `' + whName + '` int NOT NULL', function (err, result) {
                if (err) {
                    console.log(err);
                    con.query('DELETE FROM warehouse WHERE whID = ?', insertID);
                    res.send(Utils.errorResp);
                } else {
                    res.send({ code: 200, data: { insertId: insertID } });
                }
            })
        }
    })
}

var removeWarehouse = function (con, req, res) {
    var whName = req.query.whName;
    con.query('ALTER TABLE order_each_day DROP COLUMN `' + whName + '`', function (err) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            con.query('DELETE FROM warehouse WHERE whName = ?', whName, function (err) {
                if (err) {
                    console.log(err);
                    res.send(Utils.errorResp);
                } else {
                    res.send({ code: 200 });
                }
            })
        }
    })
}

var exportWarehouseProducts = function (con, req, res) {
    executeSelectWarehouseProducts(con, req, function onSuccess(result) {
        var targetFilePath = './uploads/warehouses/' + req.query.whName + Utils.today() + '.csv';
        Utils.convertJson2CSV(result, targetFilePath, function onSuccess() {
            res.send({ code: 200 });
        }, function onError() {
            console.log(err);
            res.send(Utils.errorResp);
        })
    }, function onError(error) {
        console.log(err);
        res.send(Utils.errorResp);
    })
}

function executeUpdateWarehouseProducts(updatedProducts, con, req, res) {
    if (updatedProducts.length > 0) {
        var params = updatedProducts[0];
        con.query('UPDATE warehouse_product SET ? WHERE wh_pd_ID = ' + params.wh_pd_ID, params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                updatedProducts = updatedProducts.splice(1, updatedProducts.length);
                executeUpdateWarehouseProducts(updatedProducts, con, req, res);
            }
        })

    } else {
        res.send({ code: 200 });
    }
}

var updateWarehouseProducts = function (con, req, res) {
    var updatedProducts = JSON.parse(req.query.params)
    executeUpdateWarehouseProducts(updatedProducts, con, req, res);
}

module.exports = {
    getWarehouseProducts,
    addNewWarehouse,
    removeWarehouse,
    exportWarehouseProducts,
    updateWarehouseProducts,
}