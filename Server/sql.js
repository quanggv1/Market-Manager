
/*============SQL Query==============*/
module.exports = {
        /*select from table*/
          getData: function (con, req, res){
                var table = req.query.tableName;
                con.query('SELECT * FROM ' + table, function(err,rows){
                  if(err) {
                    console.log(err);
                  } else {
                      console.log('Data received from Db:\n');
                      res.send(rows)
                  }
                });
          },
          /*insert to table*/
          insertData: function (con, req, response){
              var table = req.query.tableName;
              var query = req.query.params;
              con.query('INSERT INTO ' + table +' SET ?', query, function(err,res){
                if(err) {
                  console.log(err);
                  response.send(err);
                } else {
                  console.log('Last insert ID:', res.insertId);
                  response.send({status: 200, data: {insertId: res.insertId}});
                }
              });
          },
          /*update product description*/
          updateData: function (con, req, res){
                var table = req.query.tableName;
                var params = req.query.params;
                var idName = params.idName;
                var idValue = params.idValue;
                con.query(
                  'UPDATE ' + table + ' SET description = ?, productName = ?, price = ? Where ' + idName + ' = ?',
                  [params.description, params.productName, params.price, idValue],
                  function (err, result) {
                    if (err) {
                      console.log(err);
                      res.send(err);
                    } else {
                      console.log('Changed ' + result.changedRows + ' rows');
                      res.send(result);
                    }

                  }
                );
          },
          /*delete row*/
          deleteData: function(con, req, response){
              var table = req.query.tableName;
              var params = req.query;
              var idName = req.query.params.idName;
              var idValue = req.query.params.idValue;
              con.query('DELETE FROM ' + table + ' WHERE '+ idName + ' = ?',[idValue],
                     function (err, result) {
                        if (err){
                          console.log(err);
                          response.send(err);
                        } else {
                          console.log('Deleted ' + result.affectedRows + ' rows');
                          response.send(result);
                        }
               });
          },
  
};