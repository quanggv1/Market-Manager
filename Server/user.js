var Utils = require('./utils');

var getUsers = function (con, req, res) {
    con.query('SELECT * FROM user', function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: result });
        }
    });
}

var addNewUser = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO user SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

var removeUser = function (con, req, res) {
    var userID = req.query.userID;
    con.query('DELETE FROM user WHERE userID = ?', userID, function (err, result) {
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

var updateUser = function (con, req, res) {
    var params = req.query.params;
    con.query('UPDATE user SET ? Where userID = ' + params.userID, params,
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

module.exports = {
    getUsers,
    addNewUser,
    removeUser,
    updateUser
}