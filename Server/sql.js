
/*============SQL Query==============*/
module.exports = {
        /*select from table*/
          getData: function (con, req, res){
                var table = req.query.tableName;
                con.query('SELECT * FROM ' + table, function(err,rows){
                  if(!!err) {
                    console.log(err);
                  } else {
                      console.log('Data received from Db:\n');
                      res.send(rows)
                  }
                });
          },
          /*insert to table*/
          insertData: function (con, req, res){
              var table = req.query.tableName;
              var query = req.query.params;
              con.query('INSERT INTO ' + table +' SET ?', query, function(err,res){
                if(err) {
                  console.log(err);
                } else {
                  console.log('Last insert ID:', res.insertId);
                }
              });
          },
          /*update product description*/
          updateProduct: function (con, req, res){
                var table = req.query.tableName;
                var params = req.query.params;
                var idName = req.query.params.idName;
                var idValue = req.query.params.idValue;
                con.query(
                  'UPDATE ' + table + ' SET description = ? Where ' + idName + ' = ?',
                  [params.description, idValue],
                  function (err, result) {
                    if (err) {
                      console.log(err);
                    } else {
                      console.log('Changed ' + result.changedRows + ' rows');
                    }

                  }
                );
          },
          /*delete row*/
          deleteData: function(con, req, res){
              var table = req.query.tableName;
              var params = req.query;
              var idName = req.query.params.idName;
              var idValue = req.query.params.idValue;
              con.query('DELETE FROM ' + table + ' WHERE '+ idName + ' = ?',[idValue],
                     function (err, result) {
                        if (err){
                          console.log(err);
                        } else {
                          console.log('Deleted ' + result.affectedRows + ' rows');
                        }
               });
          },
  
};