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
    var shopName = params.shopName;
    console.log(params);
    con.query('INSERT INTO shop SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
    con.query('ALTER TABLE np_wh_expected ADD `' + shopName + '` int NOT NULL')
}

var removeShop = function (con, req, res) {
    var shopID = req.query.shopID;
    var shopName = req.query.shopName;
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
    con.query('ALTER TABLE np_wh_expected DROP COLUMN `' + shopName + '`')
}

var addNewShopProduct = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO np_shop_products SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, status: 'OK', data: { insertId: result.insertId } });
        }
    });
}

var removeShopProduct = function (con, req, res) {
    var id = req.query.id;
    con.query('DELETE FROM np_shop_products WHERE id = ?', [id], function (err, result) {
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
    var productType = req.query.type;
    var shopID = req.query.shopID;
    var sql = "SELECT np_shop_products.*, np_products.name, np_products.price " +
                "FROM np_shop_products JOIN np_products ON np_shop_products.productID = np_products.id " +
                "WHERE np_shop_products.shopID = ? AND np_products.type = ?";
    con.query(sql, [shopID, productType], function (err, result) {
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
        var shopName = getShopName(req.query.type, req.query.shopName);
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
    var shopName = getShopName(req.query.type, req.query.shopName);
    var targetFilePath = './uploads/shops/' + shopName + Utils.today() + '.csv';
    Utils.convertJson2CSV(updatedProducts, targetFilePath, function onSuccess() {
        executeUpdateShopProduct(updatedProducts, con, req, res);
    }, function onError() {
        res.send(Utils.errorResp);
    })
}

function executeUpdateShopProduct(updatedProducts, con, req, res) {
    if (updatedProducts.length > 0) {
        delete updatedProducts[0].name;
        var params = updatedProducts[0];
        con.query('UPDATE np_shop_products SET ? WHERE id = ' + params.id, params, function (err, result) {
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
    var sql = 'UPDATE np_shop_products '+
    'SET stockTake = stockTake + ? '+
    'WHERE shopID = ? AND productID = ?';
    con.query(sql, [receivedQty, shopID, productID],
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