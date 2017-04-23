var Utils = require('./utils');
var PRODUCT = require('./product');
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
    console.log(params);
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

var addNewShopProduct = function (con, req, res) {
    var shopProductTable = getShopProductTableName(req.query.productType);
    var params = req.query.params;
    con.query('INSERT INTO ' + shopProductTable + ' SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, status: 'OK', data: { insertId: result.insertId } });
        }
    });
}

var removeShopProduct = function (con, req, res) {
    var shopProductID = req.query.shopProductID;
    var shopProductTable = getShopProductTableName(req.query.productType);
    con.query('DELETE FROM ' + shopProductTable + ' WHERE shopProductID = ?', [shopProductID], function (err, result) {
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
    var shopProductTable = getShopProductTableName(req.query.productType);
    var productTable = PRODUCT.getProductTableName(req.query.productType);
    var shopID = req.query.shopID;
    var sql = "SELECT " + shopProductTable + ".*, " + productTable + ".productName, " + productTable + ".price FROM " + shopProductTable + " JOIN " + productTable + " ON " + shopProductTable + ".productID = " + productTable + ".productID WHERE " + shopProductTable + ".shopID=?";
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
        var shopName = getShopName(req.query.productType, req.query.shopName);
        var targetFilePath = './uploads/shops/' + shopName + req.query.date + '.csv';
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

function getShopProductTableName(productType) {
    switch (productType) {
        case Utils.ProductType.VEGETABLES:
            return Utils.Table.SHOP_VEGETABLES;
        case Utils.ProductType.MEAT:
            return Utils.Table.SHOP_MEATS;
        case Utils.ProductType.FOOD:
            return Utils.Table.SHOP_FOODS;
        default:
            return;
    }
}

function getShopName(productType, shopName) {
    switch (productType) {
        case Utils.ProductType.VEGETABLES:
            return shopName + '_Vegetables_';
        case Utils.ProductType.MEAT:
            return shopName + '_meat_';
        case Utils.ProductType.FOOD:
            return shopName + '_food_';
        default:
            return;
    }
}

var updateShopProducts = function (con, req, res) {
    var updatedProducts = JSON.parse(req.query.params);
    var shopName = getShopName(req.query.productType, req.query.shopName);
    console.log(shopName);
    var targetFilePath = './uploads/shops/' + shopName + Utils.today() + '.csv';
    Utils.convertJson2CSV(updatedProducts, targetFilePath, function onSuccess() {
        
        executeUpdateShopProduct(updatedProducts, con, req, res);
    }, function onError() {
        res.send(Utils.errorResp);
    })
}

function executeUpdateShopProduct(updatedProducts, con, req, res) {
    if (updatedProducts.length > 0) {
        delete updatedProducts[0].productName;
        var shopProductTable = getShopProductTableName(req.query.productType);
        var params = updatedProducts[0];
        con.query('UPDATE ' + shopProductTable + ' SET ? WHERE shopProductID = ' + params.shopProductID, params, function (err, result) {
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

var updateShopStock = function (con, shopID, productID, receivedQty, productType) {
    var shopProductTable = getShopProductTableName(productType);
    con.query('UPDATE ' + shopProductTable + ' SET stockTake = stockTake + ? WHERE shopID = ? AND productID = ?', [receivedQty, shopID, productID],
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
    updateShopProducts,
    updateShopStock,
    removeShopProduct,
    addNewShopProduct
}