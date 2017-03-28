var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var getCrates = function (con, req, res) {
    if (Utils.today() === req.query.date) {
        con.query('SELECT * FROM crate', function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                res.send({ code: 200, data: result });
            }
        });
    } else {
        var targetFilePath = './uploads/crates/crate_record' + req.query.date + '.csv';
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

function executeUpdateCrates(updatedCrates, con, req, res) {
    if (updatedCrates.length > 0) {
        var params = updatedCrates[0];
        con.query('UPDATE crate SET ? WHERE crateID = ' + params.crateID, params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                updatedCrates = updatedCrates.splice(1, updatedCrates.length);
                executeUpdateCrates(updatedCrates, con, req, res);
            }
        })
    } else {
        res.send({ code: 200 });
    }
}

var updateCrates = function (con, req, res) {
    var updatedCrates = JSON.parse(req.query.params);
    executeUpdateCrates(updatedCrates, con, req, res);
}

var exportCrates = function (con, req, res) {
    con.query('SELECT * FROM crate', function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            var targetFilePath = './uploads/crates/crate_record' + Utils.today() + '.csv';
            Utils.convertJson2CSV(result, targetFilePath, function onSuccess() {
                res.send({ code: 200 });
            }, function onError() {
                res.send(Utils.errorResp);
            })
        }
    });
}

var updateCrateReceivedQty = function (con, crateReceived, crateType) {
    con.query('UPDATE crate SET receivedQty = receivedQty + ? WHERE crateType = ?', [crateReceived, crateType], function (err, result) {
        if (err) { console.log(err) }
    })
}

module.exports = {
    getCrates,
    updateCrates,
    exportCrates,
    updateCrateReceivedQty
    
}