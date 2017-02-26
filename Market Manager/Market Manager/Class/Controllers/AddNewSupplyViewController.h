//
//  AddNewSupplyViewController.h
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "Supply.h"

typedef void(^SaveCallback)(Supply *supply);

@interface AddNewSupplyViewController : BaseViewController
@property (strong, nonatomic)SaveCallback saveCallback;
+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback;
@end
