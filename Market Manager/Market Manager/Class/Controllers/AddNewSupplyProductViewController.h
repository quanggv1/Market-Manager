//
//  AddNewSupplyProductViewController.h
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "Product.h"

typedef void(^SaveCallback)(Product *product);
@interface AddNewSupplyProductViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic)SaveCallback saveCallback;
+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback;
@end
