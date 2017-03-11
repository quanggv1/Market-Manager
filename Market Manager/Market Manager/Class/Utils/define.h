//
//  define.h
//  Canets
//
//  Created by Quang on 11/27/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#ifndef define_h
#define define_h



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

static NSString *const CellMenu = @"menuCell";
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

#pragma mark - Segue
static NSString *const SegueMain = @"segueMain";
static NSString *const SegueProductDetail = @"showProductDetail";
static NSString *const SegueShopDetail = @"showShopDetail";
static NSString *const SegueSupplyDetail = @"showSupplyDetail";
static NSString *const SegueOrderDetail = @"showOrderDetail";
static NSString *const SegueUserDetail = @"showUserDetail";
static NSString *const SegueShowOrder = @"showOrder";
static NSString *const SegueOrderForm = @"showOrderForm";

#pragma mark - Link
#define SERVER @"http://localhost:5000/"
//#define SERVER @"http://172.27.97.149:5000/"
//#define SERVER @"http://192.168.1.17:5000/"

#define API_GETDATA [SERVER stringByAppendingString:@"getData"]
#define API_UPDATEDATA [SERVER stringByAppendingString:@"updateData"]
#define API_DELETEDATA [SERVER stringByAppendingString:@"deleteData"]
#define API_INSERTDATA [SERVER stringByAppendingString:@"insertData"]
#define API_AUTHEN [SERVER stringByAppendingString:@"authen"]
#define API_GET_ORDERS [SERVER stringByAppendingString:@"getOrderList"]
#define API_GETSHOP_PRODUCT_LIST [SERVER stringByAppendingString:@"getShopProductList"]
#define API_EXPORT_SHOP_PRODUCTS [SERVER stringByAppendingString:@"exportShopProducts"]
#define API_ADD_NEW_ORDER [SERVER stringByAppendingString:@"addNewOrder"]
#define API_GET_ORDER_DETAIL [SERVER stringByAppendingString:@"getOrderDetail"]

#pragma mark - Key
static NSString *const kProductName = @"productName";
static NSString *const kProductDesc = @"description";
static NSString *const kProductPrice = @"price";
static NSString *const kProductTableName = @"product";
static NSString *const kProductID = @"productID";
static NSString *const kProductSTake = @"stockTake";
static NSString *const kProductOrder = @"order";
static NSString *const kShopProductID = @"shopProductID";

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

static NSString *const kOrderTableName = @"orders";
static NSString *const kOrderID = @"orderID";
static NSString *const kOrderQty = @"order_quantity";

static NSString *const kTitleOrderManagement = @"Order Management";

static NSString *const kCode = @"code";
static NSString *const kStatus = @"status";
static NSString *const kData = @"data";
static NSString *const kDate = @"date";
static NSString *const kInsertID = @"insertId";

static NSString *const kTableName = @"tableName";
static NSString *const kParams = @"params";
static NSString *const kIdName = @"idName";
static NSString *const kIdValue = @"idValue";
static NSString *const kShopProductTableName = @"shop_product";

#endif /* define_h */



