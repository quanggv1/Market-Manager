var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');
var PRODUCT = {};

function getProductTableName(productType) {
    switch(productType) {
        case Utils.ProductType.VEGETABLES:
            return Utils.Table.VEGETABLES;
        case Utils.ProductType.MEAT:
            return Utils.Table.MEATS;
        case Utils.ProductType.FOOD:
            return Utils.Table.FOODS;
        default:
            return Utils.Table.VEGETABLES;
    }
}

var getProducts = function (con, req, res) {
    var type = req.query.type;
    con.query('SELECT * FROM np_products', [type], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: result });
        }
    });
}

var removeProduct = function (con, req, res) {
    var productID = req.query.id;
    con.query('DELETE FROM np_products WHERE id = ?', productID, function (err, result) {
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

var addNewProduct = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO np_products SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

var updateProduct = function (con, req, res) {
    var params = req.query.params;
    con.query('UPDATE np_products SET ? WHERE id = ' + params.id, params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                res.send({ code: 200 });
            }
        }
    )
}

module.exports = {
    getProducts,
    removeProduct,
    addNewProduct,
    updateProduct,
    getProductTableName
}