var Utils = require('./utils');
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');
var WH = require('./warehouse');
var SHOP = require('./shop');
var CRATE = require('./crate');
var PRODUCT = require('./product');

function getOrderTableName(productType) {
    switch (productType) {
        case Utils.ProductType.VEGETABLES:
            return Utils.Table.ORDERS_VEGETABLE;
        case Utils.ProductType.MEAT:
            return Utils.Table.ORDERS_MEAT;
        case Utils.ProductType.FOOD:
            return Utils.Table.ORDERS_FOOD;
        default:
            return;
    }
}

function getIndividualOrderTableName(productType) {
    switch (productType) {
        case Utils.ProductType.VEGETABLES:
            return Utils.Table.ORDER_INDIVIDUAL_VEGETABLE;
        case Utils.ProductType.MEAT:
            return Utils.Table.ORDER_INDIVIDUAL_MEAT;
        case Utils.ProductType.FOOD:
            return Utils.Table.ORDER_INDIVIDUAL_FOOD;
        default:
            return;
    }
}

var getOrders = function (con, req, res) {
    var shopID = req.query.shopID;
    var productType = req.query.type;

    var sql = 'SELECT * FROM np_orders ' +
        'WHERE shopID = ? AND type = ? ' +
        'ORDER BY id DESC';

    con.query(sql, [shopID, productType], function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

var addNewOrder = function (con, req, res) {
    var params = req.query.params;
    var productType = req.query.type;
    con.query('INSERT INTO np_orders SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: { insertId: result.insertId } });
        }
    });
}

var addNewOrderDetail = function (con, req, res) {
    var params = req.query.params;
    con.query('INSERT INTO np_order_detail SET ?', params, function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            var sql = 'SELECT np_order_detail.*, np_products.name ' +
                'FROM np_order_detail JOIN np_products ON np_order_detail.productID = np_products.id ' +
                'WHERE np_order_detail.id = ?';

            con.query(sql, [result.insertId], function (err, rows) {
                if (err) {
                    console.log(err);
                    res.send(Utils.errorResp);
                } else {
                    res.send({ code: 200, data: rows[0] })
                }
            })
        }
    });
}

var removeOrder = function (con, req, res) {
    var orderID = req.query.id;
    var sql = 'DELETE FROM np_orders ' +
        'WHERE id = ?'

    con.query(sql, [orderID], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            if (result.affectedRows > 0) {
                res.send({ code: 200, status: 'success' });
            } else {
                res.send(Utils.errorResp)
            }
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
                receivedTotalQuery = receivedTotalQuery + ' np_order_detail.`' + whName + '` +';
            })
            receivedTotalQuery = receivedTotalQuery.slice(0, receivedTotalQuery.length - 1);

            sql = 'SELECT np_products.name, ' +
                'np_order_detail.order_quantity, ' +
                '(' + receivedTotalQuery + ') as received, ' +
                '(np_order_detail.order_quantity - (' + receivedTotalQuery + ')) as quantity_need, ' +
                '(' + receivedTotalQuery + ' + np_order_detail.stockTake) as total, ' +
                'np_order_detail.crate_qty, np_order_detail.crateType ' +
                'FROM np_order_detail ' +
                'JOIN np_products ON np_order_detail.productID = np_products.id ' +
                'WHERE np_order_detail.orderID =?';

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

function executeUpdateNewOrder(productOrders, orderID, con, req, res) {
    if (productOrders.length > 0) {
        /** insert product order into order_each_day */
        var params = productOrders[0];
        var individualOrderTable = getIndividualOrderTableName(req.query.productType);
        con.query('INSERT INTO ' + individualOrderTable + ' SET ?', params, function (err, result) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                productOrders = productOrders.splice(1, productOrders.length);
                executeUpdateNewOrder(productOrders, orderID, con, req, res);
            }
        });
    } else {
        /** update order table after insert into order_each_day */
        var orderTable = getOrderTableName(req.query.productType);
        con.query('UPDATE ' + orderTable + ' SET status = 1 Where orderID = ' + orderID, function (err, result) {
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
    executeUpdateNewOrder(productOrders, req.query.orderID, con, req, res);
}

var getOrderDetail = function (con, req, res) {
    var orderID = req.query.orderID;

    sql = 'SELECT np_order_detail.*, np_products.name ' +
        'FROM np_order_detail JOIN np_products ON np_order_detail.productID = np_products.id ' +
        'WHERE `orderID` = ?';

    con.query(sql, [orderID], function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

function executeUpdateOrderDetail(productOrders, shopID, orderID, warehouseNameList, con, req, res) {
    if (productOrders.length > 0) {
        /** update order_each_day */
        delete productOrders[0].name;
        var productOrder = productOrders[0];

        con.query('SELECT * FROM np_order_detail WHERE id = ?', productOrder.id, function (err, rows) {
            if (err) {
                console.log(err);
                res.send(Utils.errorResp);
            } else {
                var data = rows[0];
                var totalReceived = 0;

                /** update wh_product */
                warehouseNameList.forEach(function (whName) {
                    var thisWhReceived = productOrder[whName] - data[whName];
                    WH.updateWarehouseStock(con, whName, productOrder.productID, thisWhReceived, req.query.type)
                    totalReceived += thisWhReceived;
                })

                /** update shop_product */
                SHOP.updateShopStock(con, shopID, productOrder.productID, totalReceived, req.query.type);

                /** update crate */
                // var crateReceived = productOrder.crate_qty - data.crate_qty;
                // CRATE.updateCrateReceivedQty(con, crateReceived, productOrder.crateType);

                /** update order_each_day */
                sql = 'UPDATE np_order_detail ' +
                    'SET ? ' +
                    'WHERE id = ' + productOrder.id;

                con.query(sql, [productOrder], function (err, result) {
                    if (err) {
                        console.log(err);
                        res.send(Utils.errorResp);
                    } else {
                        productOrders = productOrders.splice(1, productOrders.length);
                        executeUpdateOrderDetail(productOrders, shopID, orderID, warehouseNameList, con, req, res);
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
        var warehouseNameList = [];
        success.forEach(function (item) {
            warehouseNameList.push(item.whName)
        });
        executeUpdateOrderDetail(productOrders, req.query.shopID, req.query.orderID, warehouseNameList, con, req, res)
    }, function (error) {
        res.send(Utils.errorResp);
    })
}

var invoiceProductByOrderID = function (con, req, res) {
    var orderID = req.query.orderID;
    sql = 'SELECT np_products.name, np_products.price, np_order_detail.order_quantity as quantity, '+
    'Round((np_products.price * np_order_detail.order_quantity),2) as total '+
    'FROM np_order_detail '+
    'JOIN np_products ON np_products.id = np_order_detail.productID and np_order_detail.orderID=?';

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
    var type = req.query.type;

    var sql = 'SELECT s1.productName, s1.shopName, s1.qty_needed, sum(s2.total) as stockTake ' +
        'FROM (SELECT t1.productID, t1.productName, t2.shopName, sum(t1.order_quantity) as qty_needed ' +
        'FROM (SELECT np_order_detail.productID, np_products.name as productName, np_orders.shopID, np_order_detail.order_quantity ' +
        'FROM np_order_detail ' +
        'JOIN np_products ON np_order_detail.productID = np_products.id ' +
        'JOIN np_orders ON np_order_detail.orderID = np_orders.id ' +
        'WHERE np_orders.date= ? AND np_products.type = ?) t1 ' +
        'INNER JOIN (SELECT shopName, shopID FROM shop) t2 ' +
        'ON t1.shopID = t2.shopID ' +
        'GROUP BY t2.shopName, t1.productName) s1 ' +
        'LEFT JOIN (SElECT productID, total FROM np_warehouse_products) s2 ' +
        'ON s1.productID = s2.productID ' +
        'GROUP BY s1.productID, s1.productName'

    con.query(sql, [tempDate, type], function (err, result) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            var list = [];
            while (result.length > 0) {
                var productName = result[0].productName;
                var total = 0;
                var record = { 'productName': productName, 'stockTake': result[0].stockTake };
                var listProductWithSameName = result.filter(function (item) {
                    return item.productName == productName;
                })

                listProductWithSameName.forEach(function (item) {
                    total += item.qty_needed
                    record[item.shopName] = item.qty_needed;
                })

                record.total = total;
                record.marketNeed = (record.stockTake < total) ? (total - record.stockTake) : 0;

                result = result.filter(function (item) {
                    return item.productName != productName;
                })

                list.push(record);
            }
            con.query('SELECT * FROM shop', function (err, shopList) {
                var titles = [];
                titles.push("productName");
                shopList.forEach(function (item) {
                    titles.push(item.shopName);
                })
                titles.push("total");
                titles.push("stockTake");
                titles.push("marketNeed");

                res.send({ code: 200, data: { titles, list } });
            });
        }
    })
}

var invoiceCratesByOrderID = function (con, req, res) {
    var orderID = req.query.orderID;
    sql = 'SELECT crate_detail.crateType as name, crate_detail.price, '+
    'sum(np_order_detail.crate_qty) as quantity, '+
    'Round((crate_detail.price * sum(np_order_detail.crate_qty)),2) as total '+
    'FROM np_order_detail '+
    'JOIN crate_detail ON crate_detail.crateType = np_order_detail.crateType AND np_order_detail.orderID=? '+
    'GROUP BY crate_detail.crateType';
    con.query(sql, orderID, function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            res.send({ code: 200, data: rows });
        }
    });
}

var getExpectedReceived = function (con, req, res) {
    var orderID = req.query.orderID;
    var date = req.query.date;

    var sql = 'SELECT np_products.name, np_order_detail.productID, orderID, order_quantity, np_orders.shopID, shop.shopName'+
    'FROM np_order_detail '+
    'JOIN np_orders ON np_order_detail.orderID = np_orders.id '+
    'JOIN shop ON np_orders.shopID = shop.shopID '+
    'join np_products ON np_products.id = np_order_detail.productID '+
    'WHERE orderID in (SELECT id FROM np_orders WHERE date = ? AND type = ?)'

    con.query(sql, [date, orderID], function (err, rows) {
        if (err) {
            console.log(err);
            res.send(Utils.errorResp);
        } else {
            rows.forEach(function(item) {

            })

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
    invoiceCratesByOrderID,
    removeOrder,
    addNewOrderDetail,
}