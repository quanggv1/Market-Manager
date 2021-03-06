//
//  config.h
//  Canets
//
//  Created by Quang on 11/27/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#ifndef config_h
#define config_h


typedef NS_ENUM(NSInteger, kActivityViewStyle){
    kActivityViewStyleDefault = 0,
    kActivityViewStyleMessage,
    kActivityViewStyleProgress,
};

static CGFloat kActivityViewBaseWidth = 200;
static CGFloat kActivityViewBaseHeight = 100;

typedef NS_ENUM(NSInteger, kOrderStatus){
    kOrderNew = 0,
    kOrderWaiting,
    kOrderDone,
};

typedef NS_ENUM(NSInteger, kProductType){
    kVegetables = 1,
    kMeats,
    kFoods
};

typedef NS_ENUM(NSInteger, kInternalStorage){
    kStorageIPAdress = 0,
};


#endif /* config_h */


