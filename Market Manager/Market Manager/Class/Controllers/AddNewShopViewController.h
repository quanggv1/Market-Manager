//
//  AddNewShopViewController.h
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Shop.h"
#import "BaseViewController.h"
typedef void(^SaveCallback)(Shop *shop);

@interface AddNewShopViewController : BaseViewController
@property (strong, nonatomic)SaveCallback saveCallback;
+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback;
@end
