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

static NSString *const CellMenu = @"menuCell";
static NSString *const CellProduct = @"productCellId";
static NSString *const CellShop = @"shopCellId";

#pragma mark - Color
#define appColor [UIColor colorWithRed:75.f/255.f green:192.f/255.f blue:223.f/255.f alpha:1]

#pragma mark - Response status


#pragma mark - Notification
static NSString *const NotifyShowHideMenu = @"showHideMenu";
static NSString *const NotifyProductDeletesItem = @"NotifyProductDeletesItem";
static NSString *const NotifyShopDeletesItem = @"NotifyProductDeletesItem";

#pragma mark - Segue
static NSString *const SegueMain = @"segueMain";
static NSString *const SegueProductDetail = @"showProductDetail";
static NSString *const SegueShopDetail = @"showShowDetail";


#pragma mark - Link

#endif /* define_h */



