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
static NSString *const StoryboardShopPopover = @"shopPopOverId";
static NSString *const StoryboardSupplyPopover = @"supplyPopOverViewControllerId";
static NSString *const StoryboardOrderPopover = @"orderPopOverViewControllerId";
static NSString *const StoryboardUserPopover = @"userPopOverViewControllerId";

static NSString *const CellMenu = @"menuCell";
static NSString *const CellProduct = @"productCellId";
static NSString *const CellShop = @"shopCellId";
static NSString *const CellSupply = @"supplyCellId";
static NSString *const CellOrder = @"orderCellId";
static NSString *const CellUser = @"userCellId";

#pragma mark - Color
#define appColor [UIColor colorWithRed:75.f/255.f green:192.f/255.f blue:223.f/255.f alpha:1]

#pragma mark - Response status


#pragma mark - Notification
static NSString *const NotifyShowHideMenu = @"showHideMenu";
static NSString *const NotifyProductDeletesItem = @"NotifyProductDeletesItem";
static NSString *const NotifyShopDeletesItem = @"NotifyProductDeletesItem";
static NSString *const NotifySupplyDeletesItem = @"NotifySupplyDeletesItem";
static NSString *const NotifyOrderDeletesItem = @"NotifyOrderDeletesItem";
static NSString *const NotifyUserDeletesItem = @"NotifyUserDeletesItem";


#pragma mark - Segue
static NSString *const SegueMain = @"segueMain";
static NSString *const SegueProductDetail = @"showProductDetail";
static NSString *const SegueShopDetail = @"showShopDetail";
static NSString *const SegueSupplyDetail = @"showSupplyDetail";
static NSString *const SegueOrderDetail = @"showOrderDetail";
static NSString *const SegueUserDetail = @"showUserDetail";


#pragma mark - Link

#endif /* define_h */



