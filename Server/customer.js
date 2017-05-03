var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var CUSTOMER = {};

CUSTOMER.getCustomers = function (con, req, res) {
    con.query('SELECT * FROM food_customers', function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: result });
        }
    });
}

CUSTOMER.addNewCustomer = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO food_customers SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

CUSTOMER.removeCustomer = function (con, req, res) {
    var id = req.query.id;
    con.query('DELETE FROM food_customers WHERE id = ?', id, function (err, result) {
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

CUSTOMER.updateCustomer = function (con, req, res) {
    var params = req.query.params;
    con.query('UPDATE food_customers SET ? Where id = ' + params.id, params,
        function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                res.send({ code: 200 });
            }
        }
    );
}

module.exports = CUSTOMER;