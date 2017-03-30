
var csvjson = require('csvjson');
var json2csv = require('json2csv');
var fs = require('fs');

var errorResp = { 'code': '400', 'status': 'error' };

var ProductType = {
  VEGETABLES: "1",
  MEAT: "2",
  FOOD: "3",
}

var Table = {
  VEGETABLES: "product",
  MEATS: "meat",
  FOODS: "food",
  SHOP_VEGETABLES: "shop_product",
  SHOP_MEATS: "meat_shop_product",
  SHOP_FOODS: "food_shop_product",
  WAREHOUSE_VEGETABLES: "warehouse_product",
  WAREHOUSE_MEATS: "meat_warehouse",
  WAREHOUSE_FOODS: "food_warehouse",
}

function convertJson2CSV(json, targetFilePath, onSuccess, onError) {
  var csv = json2csv({ data: json, fields: null });
  fs.writeFile(targetFilePath, csv, function (err) {
    if (err) {
      onError();
    } else {
      onSuccess();
    }
  });
}

function convertCSV2Json(filePath, onSuccess, onError) {
  var data = fs.readFileSync(filePath, { encoding: 'utf8' });
  var options = {
    delimiter: ',',// optional 
    quote: '"' // optional 
  };
  onSuccess(csvjson.toObject(data, options))
}

function today() {
  var date = new Date();
  var year = date.getFullYear();
  var month = date.getMonth() + 1;
  month = (month < 10 ? "0" : "") + month;
  var day = date.getDate();
  day = (day < 10 ? "0" : "") + day;
  date = year + '-' + month + '-' + day;
  return date;
}

module.exports = {
    errorResp,
    convertJson2CSV,
    convertCSV2Json,
    today,
    ProductType,
    Table
}