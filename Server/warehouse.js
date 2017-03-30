var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');
var PRODUCT = require('./product');

function getWarehouseProductTableName(productType) {
    switch (productType) {
        case Utils.ProductType.VEGETABLES:
            return Utils.Table.WAREHOUSE_VEGETABLES;
        case Utils.ProductType.MEAT:
            return Utils.Table.WAREHOUSE_MEATS;
        case Utils.ProductType.FOOD:
            return Utils.Table.WAREHOUSE_FOODS;
        default:
            return;
    }
}

function getWarehouseName(productType, whName) {
    switch (productType) {
        case Utils.ProductType.VEGETABLES:
            return whName + '_Vegetables_';
        case Utils.ProductType.MEAT:
            return whName + '_meat_';
        case Utils.ProductType.FOOD:
            return whName + '_food_';
        default:
            return;
    }
}

function executeSelectWarehouseProducts(con, req, onSuccess, onError) {
    var warehouseProductTable = getWarehouseProductTableName(req.query.productType);
    var productTable = PRODUCT.getProductTableName(req.query.productType);
    var whID = req.query.whID;
    con.query('SELECT  ' + warehouseProductTable + '.*, ' + productTable + '.productName FROM ' + warehouseProductTable + ' JOIN ' + productTable + ' ON ' + warehouseProductTable + '.productID = ' + productTable + '.productID WHERE ' + warehouseProductTable + '.whID = ?', whID,
        function (err, rows) {
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
        executeSelectWarehouseProducts(con, req, function onSuccess(result) {
            res.send({ code: 200, data: result });
        }, function onError(error) {
            res.send(Utils.errorResp);
        })
    } else {
        var whName = getWarehouseName(req.query.productType, req.query.whName);
        var targetFilePath = './uploads/warehouses/' + whName + req.query.date + '.csv';
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
    var whName = req.query.params.whName;
    var whDesc = req.query.params.description;
    con.query('INSERT INTO warehouse SET ?', req.query.params, function (err, result) {
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

var addNewWarehouseProduct = function (con, req, res) {
    var warehouseProductTable = getWarehouseProductTableName(req.query.productType);
    var params = req.query.params;
    con.query('INSERT INTO ' + warehouseProductTable + ' SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, status: 'OK', data: { insertId: result.insertId } });
        }
    });
}

var removeWarehouseProduct = function (con, req, res) {
    var wh_pd_ID = req.query.wh_pd_ID;
    var warehouseProductTable = getWarehouseProductTableName(req.query.productType);
    con.query('DELETE FROM ' + warehouseProductTable + ' WHERE wh_pd_ID = ?', [wh_pd_ID], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            if (result.affectedRows > 0) {
                res.send({ code: 200 });
            } else {
                res.send(Utils.errorResp);
            }
        }
    });
}

var exportWarehouseProducts = function (con, req, res) {
    executeSelectWarehouseProducts(con, req, function onSuccess(result) {
        var whName = getWarehouseName(req.query.productType, req.query.whName);
        var targetFilePath = './uploads/warehouses/' + whName + Utils.today() + '.csv';
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
        var warehouseProductTable = getWarehouseProductTableName(req.query.productType);
        con.query('UPDATE ' + warehouseProductTable + ' SET ? WHERE wh_pd_ID = ' + params.wh_pd_ID, params, function (err, result) {
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

var updateWarehouseStock = function (con, whName, productID, outQuantity) {
    var sql = 'UPDATE warehouse_product SET outQuantity = outQuantity + ?, total = total - ? WHERE whID IN(SELECT whID FROM warehouse WHERE whName = ?) AND productID = ?';
    con.query(sql, [outQuantity, outQuantity, whName, productID],
        function (err, result) {
            if (err) { console.log(err) }
        }
    );
}

var checkTotalWarehouseProduct = function (con, req, res) {
    var pd_ID = req.query.productID;
    var whName = req.query.whName;
    var receivedQty = req.query.receivedQty;
    con.query('SELECT total FROM warehouse_product WHERE whID IN(SELECT whID FROM warehouse WHERE whName = ?) AND productID = ?', [whName, pd_ID], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            if (!result || result.length == 0 || receivedQty > result[0].total) {
                res.send(Utils.errorResp);
            } else {
                res.send({ code: 200 });
            }
        }
    });
}

module.exports = {
    getWarehouseProducts,
    addNewWarehouse,
    removeWarehouse,
    exportWarehouseProducts,
    updateWarehouseProducts,
    getWarehouseNameList,
    updateWarehouseStock,
    checkTotalWarehouseProduct,
    addNewWarehouseProduct,
    removeWarehouseProduct
}