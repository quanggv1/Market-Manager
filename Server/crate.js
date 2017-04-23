var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var CRATE = {};

CRATE.getCrates = function (con, req, res) {
    var targetFilePath = './uploads/crates/crate_record_' + req.query.date + '.csv';

    if (Utils.today() === req.query.date) {
        if (fs.existsSync(targetFilePath)) {
            executeSelectCrates(con, req, res);
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
    con.query('DELETE FROM crate WHERE total = 0', function (err) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            executeSelectCrates(con, req, res);
        }
    })
}

function executeSelectCrates(con, req, res) {
    con.query('SELECT * FROM crate', function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: result });
        }
    })
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

CRATE.updateCrates = function (con, req, res) {
    var updatedCrates = JSON.parse(req.query.params);
    var targetFilePath = './uploads/crates/crate_record_' + Utils.today() + '.csv';
    Utils.convertJson2CSV(updatedCrates, targetFilePath, function onSuccess() {
        console.log(targetFilePath);
        executeUpdateCrates(updatedCrates, con, req, res);
    }, function (error) {
        console.log(error);
        res.send(Utils.errorResp);
    })
}

CRATE.updateCrateReceivedQty = function (con, crateReceived, crateType) {
    con.query('UPDATE crate SET receivedQty = receivedQty + ? WHERE crateType = ?', [crateReceived, crateType], function (err, result) {
        if (err) { console.log(err) }
    })
}

CRATE.getCratesDetail = function (con, req, res) {
    con.query('SELECT * FROM crate_detail', function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            console.log(123);
            res.send({ code: 200, data: result });
        }
    })
}

CRATE.updateCratesDetail = function (con, req, res) {
    var updatedCrates = JSON.parse(req.query.params);
    executeUpdateCratesDetail(updatedCrates, con, req, res);
}

function executeUpdateCratesDetail(updatedCrates, con, req, res) {
    if (updatedCrates.length > 0) {
        var params = updatedCrates[0];
        con.query('UPDATE crate_detail SET ? WHERE crateID = ' + params.crateID, params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                updatedCrates = updatedCrates.splice(1, updatedCrates.length);
                executeUpdateCratesDetail(updatedCrates, con, req, res);
            }
        })
    } else {
        res.send({ code: 200 });
    }
}

module.exports = CRATE