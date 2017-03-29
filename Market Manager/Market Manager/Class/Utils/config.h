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
    kVegatables = 1,
    kMeats,
    kFood
};


#endif /* config_h */


