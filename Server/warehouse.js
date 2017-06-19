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
    var type = req.query.type;
    var whID = req.query.whID;
    var sql = 'SELECT  np_warehouse_products.*, np_products.name ' +
        'FROM np_warehouse_products JOIN np_products ON np_warehouse_products.productID = np_products.id ' +
        'WHERE np_warehouse_products.whID = ? AND np_products.type = ?';
    con.query(sql, [whID, type], function (err, rows) {
        if (err) {
            console.log(err);
            onError(err);
        } else {
            onSuccess(rows);
        }
    });
}

var getWarehouseProducts = function (con, req, res) {
    var whName = getWarehouseName(req.query.type, req.query.whName);
    var targetFilePath = './uploads/warehouses/' + whName + req.query.date + '.csv';

    if (Utils.today() === req.query.date) {
        if (fs.existsSync(targetFilePath)) {
            executeSelectWarehouseProducts(con, req, function onSuccess(result) {
                res.send({ code: 200, data: result });
            }, function onError(error) {
                res.send(Utils.errorResp);
            })
        } else {
            refreshDataForNewDay(con, req, res)
        }
    } else {
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

var refreshDataForNewDay = function (con, req, res) {
    var whID = req.query.whID;

    var sql = 'UPDATE np_warehouse_products ' +
        'SET outQuantity = 0, inQuantity = 0, stockTake = total ' +
        'WHERE whID = ?'

    con.query(sql, whID, function (err) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            executeSelectWarehouseProducts(con, req, function onSuccess(result) {
                res.send({ code: 200, data: result });
            }, function onError(error) {
                res.send(Utils.errorResp);
            })
        }
    })
}

var addNewWarehouse = function (con, req, res) {
    var whName = req.query.params.whName;
    var whDesc = req.query.params.description;
    var sql = 'INSERT INTO warehouse SET ?';
    con.query(sql, [req.query.params], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    })
    con.query('ALTER TABLE np_order_detail ADD `' + whName + '` int NOT NULL');
    con.query('ALTER TABLE np_order_detail ADD `' + whName + ' receive expected' + '` int NOT NULL');
}

var removeWarehouse = function (con, req, res) {
    var whName = req.query.whName;
    con.query('DELETE FROM warehouse WHERE whName = ?', whName, function (err) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200 });
        }
    })
    con.query('ALTER TABLE np_order_detail DROP COLUMN `' + whName + '`')
    con.query('ALTER TABLE np_order_detail DROP COLUMN `' + whName + ' receive expected' + '`');
}

var addNewWarehouseProduct = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO np_warehouse_products SET ?', params, function (err, result) {
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
    var sql = 'DELETE FROM np_warehouse_products WHERE wh_pd_ID = ?';
    con.query(sql, [wh_pd_ID], function (err, result) {
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

var updateWarehouseProducts = function (con, req, res) {
    var updatedProducts = JSON.parse(req.query.params)
    var whName = getWarehouseName(req.query.type, req.query.whName);
    var targetFilePath = './uploads/warehouses/' + whName + Utils.today() + '.csv';
    Utils.convertJson2CSV(updatedProducts, targetFilePath, function onSuccess() {
        executeUpdateWarehouseProducts(updatedProducts, con, req, res);
    }, function onError() {
        console.log(err);
        res.send(Utils.errorResp);
    })
}

function executeUpdateWarehouseProducts(updatedProducts, con, req, res) {
    if (updatedProducts.length > 0) {
        var params = updatedProducts[0];
        delete params.name;

        var sql = 'UPDATE np_warehouse_products ' +
            'SET ? ' +
            'WHERE wh_pd_ID = ' + params.wh_pd_ID;

        con.query(sql, params, function (err, result) {
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

var updateWarehouseStock = function (con, whName, productID, outQuantity, productType) {
    var whProductTable = getWarehouseProductTableName(productType);
    var sql = 'UPDATE np_warehouse_products ' +
        'SET outQuantity = outQuantity + ?, total = total - ? ' +
        'WHERE whID IN(SELECT whID FROM warehouse WHERE whName = ?) AND productID = ?';
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
    var sql = 'SELECT total ' +
        'FROM np_warehouse_products ' +
        'WHERE whID IN(SELECT whID FROM warehouse WHERE whName = ?) AND productID = ?';
    con.query(sql, [whName, pd_ID], function (err, result) {
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

var updateWarehouseExpected = function (con, req, res) {
    var params = req.query;
    var shopName = params.shopName;
    var id = params.id;
    var whName = params.whName + ' receive expected';
    var value = params.value;
    var productID = params.productID;
    var date = params.date;


    var sql = 'UPDATE np_wh_expected ' +
        'SET `' + shopName + '` = ? ' +
        'WHERE id = ?'

    con.query(sql, [value, id], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            var updateOrderDetailSQL = 'UPDATE np_order_detail ' +
                'SET `' + whName + '` = ? ' +
                'WHERE productID = ? ' +
                'AND orderID in (SELECT id ' +
                'FROM np_orders ' +
                'WHERE date = ? ' +
                'AND shopID IN (SELECT shopID FROM shop WHERE shopName = ?))'
            con.query(updateOrderDetailSQL, [value, productID, date, shopName], function (err) {
                if (err) {
                    console.log(err);
                    res.send(Utils.errorResp);
                } else {
                    res.send({ code: 200 });
                }
            });
        }
    })
}

var getWarehouseExpected = function (con, req, res) {
    var date = req.query.date;
    var whID = req.query.whID;

    var sqlGetProductsByWhID = 'SELECT np_wh_expected.*, np_products.name ' +
        'FROM np_wh_expected ' +
        'JOIN np_products ON productID = np_products.id ' +
        'WHERE whID = ?';

    var sqlGetProductsByDefault = 'SELECT * FROM `np_wh_expected` WHERE whID = 0';

    con.query(sqlGetProductsByWhID, [whID], function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            if (rows.length > 0) {
                res.send({ code: 200, data: rows });
            } else {
                con.query(sqlGetProductsByDefault, function (err, rows) {
                    if (err) {
                        console.log(err);
                        res.send(Utils.errorResp);
                    } else {
                        if (rows.length > 0) {
                            rows.forEach(function (item) {
                                delete item.id;
                                item.whID = whID;
                            })
                            console.log(rows);
                            insertWhExpected(con, req, res, rows);
                        } else {
                            console.log('Khong co du lieu');
                            res.send(Utils.errorResp);
                        }
                    }
                })
            }
        }
    })
}

function insertWhExpected(con, req, res, rows) {
    if (rows.length > 0) {
        var sqlInsert = 'INSERT INTO np_wh_expected SET ?'
        con.query(sqlInsert, rows[0], function (err) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                rows.shift()
                insertWhExpected(con, req, res, rows);
            }
        })
    } else {
        getWarehouseExpected(con, req, res);
    }
}
    
module.exports = {
    getWarehouseProducts,
    addNewWarehouse,
    removeWarehouse,
    updateWarehouseProducts,
    getWarehouseNameList,
    updateWarehouseStock,
    checkTotalWarehouseProduct,
    addNewWarehouseProduct,
    removeWarehouseProduct,
    getWarehouseProductTableName,
    updateWarehouseExpected,
    getWarehouseExpected
}