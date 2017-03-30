var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

function getProductTableName(productType) {
    switch(productType) {
        case Utils.ProductType.VEGETABLES:
            return Utils.Table.VEGETABLES;
        case Utils.ProductType.MEAT:
            return Utils.Table.MEATS;
        case Utils.ProductType.FOOD:
            return Utils.Table.FOODS;
        default:
            return;
    }
}

var getProducts = function (con, req, res) {
    var tableName = getProductTableName(req.query.productType);
    console.log(tableName);
    con.query('SELECT * FROM ' + tableName, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: result });
        }
    });
}

var removeProduct = function (con, req, res) {
    var tableName = getProductTableName(req.query.productType);
    console.log(tableName);
    var productID = req.query.productID;
    con.query('DELETE FROM '+ tableName +' WHERE productID = ?', productID, function (err, result) {
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
    var tableName = getProductTableName(req.query.productType);
    var params = req.query.params;
    console.log(params);
    con.query('INSERT INTO ' + tableName + ' SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

var updateProduct = function (con, req, res) {
    var tableName = getProductTableName(req.query.productType);
    var params = req.query.params;
    con.query('UPDATE ' + tableName + ' SET ? Where productID = ' + params.productID, params, function (err, result) {
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