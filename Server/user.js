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

var authen = function (con, req, res) {
    con.query('SELECT * FROM user WHERE userName = ? AND password = ?', [req.query.userName, req.query.password], function (error, rows) {
      if (error) {
        console.log(error);
        res.send(Utils.errorResp);
      } else {
        if (rows.length > 0) {
          console.log('OK');
          res.send({ 'code': '200', 'data': rows[0] });
        } else {
          res.send(Utils.errorResp);
        }
      }
    });
  }

module.exports = {
    getUsers,
    addNewUser,
    removeUser,
    updateUser,
    authen
}