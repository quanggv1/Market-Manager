var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var getCrates = function (con, req, res) {
    var targetFilePath = './uploads/crates/crate_record_' + req.query.date + '.csv';

    if (Utils.today() === req.query.date) {
        executeSelectCrates(con, req, res);
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

// var refreshDataForNewDay = function (con, req, res) {
//     con.query('DELETE FROM crate WHERE total = 0', function (err) {
//         if (err) {
//             console.log(err);
//             res.send(Utils.errorResp);
//         } else {
//             executeSelectCrates(con, req, res);
//         }
//     })
// }

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

var updateCrates = function (con, req, res) {
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

var updateCrateReceivedQty = function (con, crateReceived, crateType) {
    con.query('UPDATE crate SET receivedQty = receivedQty + ? WHERE crateType = ?', [crateReceived, crateType], function (err, result) {
        if (err) { console.log(err) }
    })
}

var getCratesDetail = function (con, req, res) {
    var type = req.query.type;

    con.query('SELECT * FROM crate_detail WHERE type = ?', [type], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
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

var addNewSupply = function (con, req, res) {
    var name = req.query.provider;
    var sql = 'INSERT INTO crate SET provider = ?';
    con.query(sql, [name], function(err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            con.query('ALTER TABLE np_warehouse_products ADD `In from ' + name + '` int NOT NULL');
            con.query('ALTER TABLE np_warehouse_products ADD `Pallet type From ' + name + '` int NOT NULL');
            con.query('ALTER TABLE np_warehouse_products ADD `Number of pallet From ' + name + '` int NOT NULL');
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    })
}

var removeSupply = function (con, req, res) {
    var crateID = req.query.crateID;
    var name = req.query.provider;

    var sql = 'DELETE FROM crate WHERE crateID = ?';

    con.query(sql, [crateID], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            if (result.affectedRows > 0) {
                res.send({ code: 200 });
                con.query('ALTER TABLE np_warehouse_products DROP COLUMN `In from ' + name + '`')
                con.query('ALTER TABLE np_warehouse_products DROP COLUMN `Pallet type From ' + name + '`');
                con.query('ALTER TABLE np_warehouse_products DROP COLUMN `Number of pallet From ' + name + '`');
            } else {
                res.send(Utils.errorResp);
            }
        }
    });
}

module.exports = {
    getCrates,
    updateCrates,
    updateCrateReceivedQty,
    getCratesDetail,
    updateCratesDetail,
    addNewSupply,
    removeSupply,
}