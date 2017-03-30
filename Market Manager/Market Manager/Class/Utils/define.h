//
//  define.h
//  Canets
//
//  Created by Quang on 11/27/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#ifndef define_h
#define define_h

typedef enum : NSUInteger {
    kPermissionFull = 0,
    kPermissionReadonly,
    kPermissionWritable
} Permission;


#pragma mark - StoryboardIdentifiers
static NSString *const StoryboardMain = @"MarketManager";
static NSString *const StoryboardProductPopover = @"productPopOverId";
static NSString *const StoryboardDatePicker = @"datePickerIdentifier";
static NSString *const StoryboardRecommendList = @"recommendListViewControllerId";
static NSString *const StoryboardProductNavigation = @"productNavigationId";
static NSString *const StoryboardShopNavigation = @"shopNavigationId";
static NSString *const StoryboardSupplyNavigation = @"supplyNavigationId";
static NSString *const StoryboardOrderNavigation = @"orderNavigationId";
static NSString *const StoryboardUserNavigation = @"userNavigationId";
static NSString *const StoryboardAddNewShop = @"AddNewShopViewId";
static NSString *const StoryboardAddNewSupply = @"AddNewSupplyViewId";
static NSString *const StoryboardAddNewUser = @"AddNewUserViewId";
static NSString *const StoryboardMenuView = @"menuViewController";
static NSString *const StoryboardCrateNavigation = @"crateNavigationId";
static NSString *const StoryboardAddNewShopProduct = @"AddNewShopProductViewControllerId";
static NSString *const StoryboardAddNewSupplyProduct = @"AddNewSupplyProductViewControllerId";
static NSString *const StoryboardReportSummaryQtyNeed = @"SummaryNavigationQtyNeedID";


static NSString *const CellMenu = @"menuCell";
static NSString *const CellMenuBanner = @"menuBannerCellID";
static NSString *const CellProduct = @"productCellId";
static NSString *const CellShop = @"shopCellId";
static NSString *const CellSupply = @"supplyCellId";
static NSString *const CellOrder = @"orderCellId";
static NSString *const CellUser = @"userCellId";
static NSString *const CellCrateOrder = @"crateOrderCell";
static NSString *const CellProductOrder = @"productOrderCell";
static NSString *const CellOrderDropDown = @"orderDropdownCell";
static NSString *const CellShopProduct = @"ShopProductTableViewCellId";
static NSString *const CellNewOrder = @"OrderFormTableViewCellId";
static NSString *const CellCrateManager = @"CrateTableViewCellID";
static NSString *const CellWarehouseProduct = @"SupplyProductTableViewCellID";
static NSString *const CellSummaryQtyNeed = @"SummaryQtyNeedTableViewCellID";


#pragma mark - Color
#define appColor [UIColor colorWithRed:75.f/255.f green:192.f/255.f blue:223.f/255.f alpha:1]

#pragma mark - Response status
#define kResSuccess 200
#define kResFailed 400


#pragma mark - Notification
static NSString *const NotifyShowHideMenu = @"showHideMenu";
static NSString *const NotifyProductDeletesItem = @"NotifyProductDeletesItem";
static NSString *const NotifyOrderDeletesItem = @"NotifyOrderDeletesItem";
static NSString *const NotifyProductAddNewItem = @"NotifyProductAddNewItem";
static NSString *const NotifyProductUpdateItem = @"NotifyProductUpdateItem";
static NSString *const NotifyShopProductUpdate = @"NotifyShopProductUpdate";
static NSString *const NotifyNewOrderUpdate = @"NotifyNewOrderUpdate";
static NSString *const NotifyUpdateProfile = @"NotifyUpdateProfile";

#pragma mark - Segue
static NSString *const SegueMain = @"segueMain";
static NSString *const SegueProductDetail = @"showProductDetail";
static NSString *const SegueShopDetail = @"showShopDetail";
static NSString *const SegueSupplyDetail = @"showSupplyDetail";
static NSString *const SegueOrderDetail = @"showOrderDetail";
static NSString *const SegueUserDetail = @"showUserDetail";
static NSString *const SegueShowOrder = @"showOrder";
static NSString *const SegueOrderForm = @"showOrderForm";
static NSString *const SegueReportOrderForm = @"reportOrder";
static NSString *const SegueInvoiceOrderForm = @"toInnvoice";
static NSString *const SegueShowFunctionList = @"showFunctionList";
#pragma mark - Link
//#define SERVER @"http://localhost:5000/"
#define SERVER @"http://172.27.97.149:5000/"
//#define SERVER @"http://192.168.1.17:5000/"
//#define SERVER @"http://172.27.97.165:5000/"

#define API_GETDATA [SERVER stringByAppendingString:@"getData"]
#define API_UPDATEDATA [SERVER stringByAppendingString:@"updateData"]
#define API_DELETEDATA [SERVER stringByAppendingString:@"deleteData"]
#define API_INSERTDATA [SERVER stringByAppendingString:@"insertData"]
#define API_AUTHEN [SERVER stringByAppendingString:@"authen"]
#define API_GET_ORDERS [SERVER stringByAppendingString:@"getOrderList"]
#define API_GETSHOP_PRODUCTS [SERVER stringByAppendingString:@"getShopProducts"]
#define API_EXPORT_SHOP_PRODUCTS [SERVER stringByAppendingString:@"exportShopProducts"]
#define API_GET_ORDER_DETAIL [SERVER stringByAppendingString:@"getOrderDetail"]
#define API_UPDATE_ORDER_DETAIL [SERVER stringByAppendingString:@"updateOrderDetail"]
#define API_GET_WAREHOUSE_PRODUCTS [SERVER stringByAppendingString:@"getWarehouseProducts"]
#define API_UPDATE_WAREHOUSE_PRODUCTS [SERVER stringByAppendingString:@"updateWarehouseProducts"]
#define API_EXPORT_WAREHOUSE_PRODUCTS [SERVER stringByAppendingString:@"exportWarehouseProducts"]
#define API_CHECK_TOTAL_WAREHOUSE_PRODUCTS [SERVER stringByAppendingString:@"checkTotalWarehouseProduct"]
#define API_REPORT_ORDER_EACHDAY [SERVER stringByAppendingString:@"reportOrderEachday"]
#define API_REPORT_SUM_ORDER_EACHDAY [SERVER stringByAppendingString:@"reportSumOrderEachday"]
#define API_UPDATE_CRATES [SERVER stringByAppendingString:@"updateCrates"]
#define API_GET_CRATES [SERVER stringByAppendingString:@"getCrates"]
#define API_EXPORT_CRATES [SERVER stringByAppendingString:@"exportCrates"]
#define API_GET_DATA_DEFAULT [SERVER stringByAppendingString:@"getDataDefault"]
#define API_ADD_NEW_WAREHOUSE [SERVER stringByAppendingString:@"addNewWarehouse"]
#define API_REMOVE_WAREHOUSE [SERVER stringByAppendingString:@"removeWarehouse"]
#define API_INVOICE_PRODUCT [SERVER stringByAppendingString:@"invoiceProductByOrderID"]
#define API_INVOICE_CRATES [SERVER stringByAppendingString:@"invoiceCratesByOrderID"]
#define API_INVOICE_UPLOAD [SERVER stringByAppendingString:@"uploadInvoice"]
#define API_UPDATE_USER [SERVER stringByAppendingString:@"updateUser"]
#define API_UPDATE_SHOP_PRODUCTS [SERVER stringByAppendingString:@"updateShopProducts"]
#define API_GET_SHOPS [SERVER stringByAppendingString:@"getShops"]
#define API_ADD_NEW_SHOP [SERVER stringByAppendingString:@"addNewShop"]
#define API_REMOVE_SHOP [SERVER stringByAppendingString:@"removeShop"]
#define API_GET_USERS [SERVER stringByAppendingString:@"getUsers"]
#define API_ADD_NEW_USER [SERVER stringByAppendingString:@"addNewUser"]
#define API_REMOVE_USER [SERVER stringByAppendingString:@"removeUser"]
#define API_ADD_NEW_ORDER [SERVER stringByAppendingString:@"addNewOrder"]
#define API_UPDATE_NEW_ORDER [SERVER stringByAppendingString:@"updateNewOrder"]
#define API_GET_PRODUCTS [SERVER stringByAppendingString:@"getProducts"]
#define API_REMOVE_PRODUCT [SERVER stringByAppendingString:@"removeProduct"]
#define API_ADD_NEW_PRODUCT [SERVER stringByAppendingString:@"addNewProduct"]
#define API_UPDATE_PRODUCT [SERVER stringByAppendingString:@"updateProduct"]
#define API_REMOVE_SHOP_PRODUCT [SERVER stringByAppendingString:@"removeShopProduct"]
#define API_ADD_NEW_SHOP_PRODUCT [SERVER stringByAppendingString:@"addNewShopProduct"]
#define API_ADD_NEW_WAREHOUSE_PRODUCT [SERVER stringByAppendingString:@"addNewWarehouseProduct"]
#define API_REMOVE_WAREHOUSE_PRODUCT [SERVER stringByAppendingString:@"removeWarehouseProduct"]



#pragma mark - Key
static NSString *const kProductName = @"productName";
static NSString *const kProductDesc = @"description";
static NSString *const kProductPrice = @"price";
static NSString *const kProductTableName = @"product";
static NSString *const kProductID = @"productID";
static NSString *const kProductSTake = @"stockTake";
static NSString *const kProductOrder = @"order_quantity";
static NSString *const kShopProductID = @"shopProductID";
static NSString *const kProductOrderID = @"productOrderID";
static NSString *const kProductWareHouseID = @"wh_pd_ID";
static NSString *const kProduct = @"productType";

static NSString *const kShopID = @"shopID";
static NSString *const kShopName = @"shopName";
static NSString *const kShopDesc = @"description";
static NSString *const kShopTableName = @"shop";

static NSString *const kSupplyID = @"whID";
static NSString *const kSupplyName = @"whName";
static NSString *const kSupplyDesc = @"description";
static NSString *const kSupplyTableName = @"warehouse";

static NSString *const kUserTableName = @"user";
static NSString *const kUserName = @"userName";
static NSString *const kUserPassword = @"password";
static NSString *const kUserID = @"userID";
static NSString *const kUserAdmin = @"admin";
static NSString *const kReadPermission = @"readonly";
static NSString *const kWritePermission = @"writable";

static NSString *const kWarehouseID = @"whID";
static NSString *const kWhName = @"whName";
static NSString *const kWhOutQuantity = @"outQuantity";
static NSString *const kWhInQuantity = @"inQuantity";
static NSString *const kWhTotal = @"total";

static NSString *const kCrateID = @"crateID";
static NSString *const kCrateType = @"crateType";
static NSString *const kCrateTableName = @"crate";
static NSString *const kCrateReceived = @"receivedQty";
static NSString *const kCrateReturned = @"returnedQty";
static NSString *const kCratePrice = @"price";

static NSString *const kOrderTableName = @"orders";
static NSString *const kOrderID = @"orderID";
static NSString *const kOrderQty = @"order_quantity";

static NSString *const kTitleOrderManagement = @"Order Management";
static NSString *const kTitleProductManagement = @"Product Management";

static NSString *const kCode = @"code";
static NSString *const kStatus = @"status";
static NSString *const kData = @"data";
static NSString *const kDate = @"date";
static NSString *const kInsertID = @"insertId";

static NSString *const kCrateQty = @"crate_qty";
static NSString *const kWh1 = @"wh1";
static NSString *const kWh2 = @"wh2";
static NSString *const kWhTL = @"wh3";

static NSString *const kTableName = @"tableName";
static NSString *const kParams = @"params";
static NSString *const kIdName = @"idName";
static NSString *const kIdValue = @"idValue";
static NSString *const kShopProductTableName = @"shop_product";
static NSString *const kWarehouseProductTableName = @"warehouse_product";

#define ShowMsgConnectFailed [CallbackAlertView setCallbackTaget:titleError message:msgConnectFailed target:self okTitle:btnOK okCallback:nil cancelTitle:nil cancelCallback:nil]
#define ShowMsgSomethingWhenWrong [CallbackAlertView setCallbackTaget:titleError message:msgSomethingWhenWrong target:self okTitle:btnOK okCallback:nil cancelTitle:nil cancelCallback:nil]
#define ShowMsgUnavaiableData [CallbackAlertView setCallbackTaget:titleError message:@"Unavaiable data for this day" target:self okTitle:btnOK okCallback:nil cancelTitle:nil cancelCallback:nil]

#endif /* define_h */



