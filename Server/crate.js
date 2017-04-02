var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var getCrates = function (con, req, res) {
    con.query('SELECT * FROM crate WHERE date = ?', req.query.date, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            if (result.length > 0) {
                res.send({ code: 200, data: result });
            } else {
                if (req.query.date == Utils.today()) {
                    insertNewData(con, req, res);
                } else {
                    res.send(Utils.errorResp);
                }
            }
        }
    });
}

function insertNewData(con, req, res) {
    con.query('INSERT INTO crate (provider, total) '
        + 'SELECT provider, total '
        + 'FROM crate WHERE date = ? AND total > ?',
        [Utils.yesterday(), 0],
        function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                if (result.affectedRows > 0) {
                    con.query('UPDATE crate '
                        + 'SET date = ? '
                        + 'WHERE date = ""', req.query.date, function (err, result) {
                            if (err) {
                                console.log(err);
                                res.send(Utils.errorResp);
                            } else {
                                getCrates(con, req, res);
                            }
                        })
                } else {
                    res.send(Utils.errorResp);
                }
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

var getCratesDetail = function (con, req, res) {
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

var updateCratesDetail = function (con, req, res) {
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

module.exports = {
    getCrates,
    updateCrates,
    exportCrates,
    updateCrateReceivedQty,
    getCratesDetail,
    updateCratesDetail,
}