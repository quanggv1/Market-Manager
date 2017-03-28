var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');
var WH = require('./warehouse');
var SHOP = require('./shop');
var CRATE = require('./crate');

var getOrders = function (con, req, res) {
    var shopID = req.query.shopID;
    console.log(shopID)
    var sql = 'SELECT * FROM orders  WHERE `shopID` = ?';
    con.query(sql, shopID, function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

var reportOrderEachday = function (con, req, res) {
    var orderID = req.query.orderID;
    var receivedTotalQuery = '';
    con.query('SELECT whName FROM warehouse', function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            rows.forEach(function (item) {
                var whName = item.whName;
                receivedTotalQuery = receivedTotalQuery + ' order_each_day.`' + whName + '` +';
            })
            receivedTotalQuery = receivedTotalQuery.slice(0, receivedTotalQuery.length - 1);
            sql = 'SELECT product.productName, order_each_day.order_quantity, (' + receivedTotalQuery + ') as received, (order_each_day.order_quantity - (' + receivedTotalQuery + ')) as quantity_need, (' + receivedTotalQuery + ' + order_each_day.stockTake) as total, order_each_day.crate_qty, order_each_day.crateType FROM order_each_day JOIN product ON order_each_day.productID = product.productID WHERE order_each_day.orderID =?';
            con.query(sql, orderID, function (err, result) {
                if (err) {
                    console.log(err);
                    res.send(Utils.errorResp);
                } else {
                    res.send({ code: 200, data: result })
                }
            });
        }
    });
}

var addNewOrder = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO orders SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

function executeUpdateNewOrder(productOrders, orderID, con, res) {
    if (productOrders.length > 0) {
        /** insert product order into order_each_day */
        params = productOrders[0];
        con.query('INSERT INTO order_each_day SET ?', params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                productOrders = productOrders.splice(1, productOrders.length);
                executeUpdateNewOrder(productOrders, orderID, con, res);
            }
        });
    } else {
        /** update order table after insert into order_each_day */
        con.query('UPDATE orders SET status = 1 Where orderID = ' + orderID, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                res.send({ code: 200 });
            }
        });
    }
}

var updateNewOrder = function (con, req, res) {
    var productOrders = JSON.parse(req.query.params);
    console.log(productOrders);
    executeUpdateNewOrder(productOrders, req.query.orderID, con, res);
}

var getOrderDetail = function (con, req, res) {
    var orderID = req.query.orderID;
    sql = 'SELECT order_each_day.*, product.productName FROM `order_each_day` JOIN product ON order_each_day.productID = product.productID WHERE `orderID` = ?';
    con.query(sql, orderID, function (err, rows) {
        if (err) {
            console.log(err);
            es.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

function executeUpdateOrderDetail(productOrders, shopID, orderID, warehouseNameList, con, res) {
    if (productOrders.length > 0) {
        /** update order_each_day */
        delete productOrders[0].productName;
        var productOrder = productOrders[0];

        con.query('SELECT * FROM `order_each_day` WHERE `productOrderID` = ?', productOrder.productOrderID, function (err, rows) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                var data = rows[0];
                var totalReceived = 0;

                /** update wh_product */
                warehouseNameList.forEach(function (whName) {
                    var thisWhReceived = productOrder[whName] - data[whName];
                    WH.updateWarehouseStock(con, whName, productOrder.productID, thisWhReceived)
                    totalReceived += thisWhReceived;
                })

                /** update shop_product */
                SHOP.updateShopStock(con, shopID, productOrder.productID, totalReceived);

                /** update crate */
                var crateReceived = productOrder.crate_qty - data.crate_qty;
                CRATE.updateCrateReceivedQty(con, crateReceived, productOrder.crateType);

                /** update order_each_day */
                con.query('UPDATE order_each_day SET ? WHERE productOrderID = ' + productOrder.productOrderID, productOrder, function (err, result) {
                    if (err) {
                        console.log(err);
                        res.send(Utils.errorResp);
                    } else {
                        productOrders = productOrders.splice(1, productOrders.length);
                        executeUpdateOrderDetail(productOrders, shopID, orderID, warehouseNameList, con, res);
                    }
                });
            }
        });
    } else {
        res.send({ code: 200 });
    }
}

var updateOrderDetail = function (con, req, res) {
    var productOrders = JSON.parse(req.query.params)
    WH.getWarehouseNameList(con, function (success) {
        console.log(success);
        var warehouseNameList = [];
        success.forEach(function (item) { warehouseNameList.push(item.whName) });
        executeUpdateOrderDetail(productOrders, req.query.shopID, req.query.orderID, warehouseNameList, con, res)
    }, function (error) {
        res.send(Utils.errorResp);
    })
}

var invoiceProductByOrderID = function (con, req, res) {
    var orderID = req.query.orderID;
    sql = "SELECT product.productName as name, product.price, order_each_day.order_quantity as quantity, Round((product.price * order_each_day.order_quantity),2) as total from order_each_day JOIN product ON product.productID = order_each_day.productID and order_each_day.orderID=?";
    con.query(sql, orderID, function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

var reportSumOrderEachday = function (con, req, res) {
    var tempDate = req.query.date;
    var receivedTotalQuery = '';
    WH.getWarehouseNameList(con, function (success) {
        success.forEach(function (item) {
            var whName = item.whName;
            receivedTotalQuery = receivedTotalQuery + ' order_each_day.`' + whName + '` +';
        })
        receivedTotalQuery = receivedTotalQuery.slice(0, receivedTotalQuery.length - 1);
        sql = 'SELECT product.productName, order_each_day.order_quantity,  sum(order_each_day.order_quantity - (' + receivedTotalQuery + ')) as quantity_need FROM order_each_day JOIN product ON order_each_day.productID = product.productID JOIN orders ON order_each_day.orderID = orders.orderID WHERE orders.date=?  GROUP BY product.productName';
        con.query(sql, tempDate, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                res.send({ code: 200, data: result });
            }
        });
    }, function (error) {
        console.log(error);
        res.send(Utils.errorResp);
    })
}


var invoiceCratesByOrderID = function (con, req, res) {
    var orderID = req.query.orderID;
    sql = "SELECT crate.crateType as name, crate.price, sum(order_each_day.crate_qty) as quantity, Round((crate.price * sum(order_each_day.crate_qty)),2) as total from order_each_day JOIN crate ON crate.crateType = order_each_day.crateType and order_each_day.orderID=? GROUP BY crate.crateType";
    con.query(sql, orderID, function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

module.exports = {
    getOrders,
    reportOrderEachday,
    addNewOrder,
    updateNewOrder,
    getOrderDetail,
    updateOrderDetail,
    reportSumOrderEachday,
    invoiceProductByOrderID,
    invoiceCratesByOrderID
}