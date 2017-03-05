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
static NSString *const StoryboardOrderDropdownList = @"orderDropDownListViewId";
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


#pragma mark - Color
#define appColor [UIColor colorWithRed:75.f/255.f green:192.f/255.f blue:223.f/255.f alpha:1]

#pragma mark - Response status


#pragma mark - Notification
static NSString *const NotifyShowHideMenu = @"showHideMenu";
static NSString *const NotifyProductDeletesItem = @"NotifyProductDeletesItem";
static NSString *const NotifyOrderDeletesItem = @"NotifyOrderDeletesItem";
static NSString *const NotifyProductAddNewItem = @"NotifyProductAddNewItem";
static NSString *const NotifyProductUpdateItem = @"NotifyProductUpdateItem";
static NSString *const NotifyShopProductUpdate = @"NotifyShopProductUpdate";

#pragma mark - Segue
static NSString *const SegueMain = @"segueMain";
static NSString *const SegueProductDetail = @"showProductDetail";
static NSString *const SegueShopDetail = @"showShopDetail";
static NSString *const SegueSupplyDetail = @"showSupplyDetail";
static NSString *const SegueOrderDetail = @"showOrderDetail";
static NSString *const SegueUserDetail = @"showUserDetail";
static NSString *const SegueShowOrder = @"showOrder";

#pragma mark - Link
static NSString *const API_GETDATA = @"http://localhost:5000/getData";
static NSString *const API_UPDATEDATA = @"http://localhost:5000/updateData";
static NSString *const API_DELETEDATA = @"http://localhost:5000/deleteData";
static NSString *const API_INSERTDATA = @"http://localhost:5000/insertData";
static NSString *const API_AUTHEN  = @"http://localhost:5000/authen";

#pragma mark - Key
static NSString *const kProductName = @"productName";
static NSString *const kProductDesc = @"description";
static NSString *const kProductPrice = @"price";
static NSString *const kProductTableName = @"product";
static NSString *const kProductID = @"productID";
static NSString *const kProductSTake = @"STake";

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


#endif /* define_h */



