var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var getShops = function (con, req, res) {
    con.query('SELECT * FROM shop', function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: result });
        }
    });
}

var addNewShop = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO shop SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

var removeShop = function (con, req, res) {
    var shopID = req.query.shopID;
    con.query('DELETE FROM shop WHERE shopID = ?', shopID, function (err, result) {
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

function executeSelectShopProducts(con, req, onSuccess, onError) {
    var shopID = req.query.shopID;
    var sql = "SELECT shop_product.*, product.productName, product.price FROM shop_product JOIN product ON shop_product.productID = product.productID WHERE shop_product.shopID=?";
    con.query(sql, shopID, function (err, result) {
        if (err) {
            console.log(err);
            onError(err);
        } else {
            onSuccess(result);
        }
    });
}

var getShopProducts = function (con, req, res) {
    if (Utils.today() === req.query.date) {
        executeSelectShopProducts(con, req, function (success) {
            res.send({ code: 200, data: success });
        }, function (error) {
            res.send(Utils.errorResp);
        });
    } else {
        var targetFilePath = './uploads/shops/' + req.query.shopName + req.query.date + '.csv';
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

var exportShopProducts = function (con, req, res) {
    var shopName = req.query.shopName;
    executeSelectShopProducts(con, req, function onSuccess(result) {
        var targetFilePath = './uploads/shops/' + shopName + Utils.today() + '.csv';
        Utils.convertJson2CSV(result, targetFilePath, function onSuccess() {
            res.send({ code: 200 });
        }, function onError() {
            res.send(Utils.errorResp);
        })
    }, function onError(error) {
        res.send(Utils.errorResp);
    })
}


function executeUpdateShopProduct(updatedProducts, con, req, res) {
    if (updatedProducts.length > 0) {
        var params = updatedProducts[0];
        con.query('UPDATE shop_product SET ? WHERE shopProductID = ' + params.shopProductID, params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                updatedProducts = updatedProducts.splice(1, updatedProducts.length);
                executeUpdateShopProduct(updatedProducts, con, req, res);
            }
        })
    } else {
        res.send({ code: 200 });
    }
}

var updateShopProducts = function (con, req, res) {
    var updatedProducts = JSON.parse(req.query.params);
    executeUpdateShopProduct(updatedProducts, con, req, res);
}

var updateShopStock = function (con, shopID, productID, receivedQty) {
    con.query('UPDATE shop_product SET stockTake = stockTake + ? WHERE shopID = ? AND productID = ?', [receivedQty, shopID, productID],
        function (err, result) {
            if (err) { console.log(err) }
        }
    );
}


module.exports = {
    getShops,
    addNewShop,
    removeShop,
    getShopProducts,
    exportShopProducts,
    updateShopProducts,
    updateShopStock
}