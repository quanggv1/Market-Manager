//
//  AddNewShopProductViewController.m
//  Market Manager
//
//  Created by Quang on 3/9/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "AddNewShopProductViewController.h"
#import "RecommendListViewController.h"
#import "ProductManager.h"
#import "ShopDetailViewController.h"

static AddNewShopProductViewController *addNewShopProductViewController;
@interface AddNewShopProductViewController ()
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *productDescTextView;
@property (weak, nonatomic) ShopDetailViewController *shopDetailViewController;
@end

@implementation AddNewShopProductViewController {
    NSArray *productNameList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _productNameTextField.delegate = self;
    [_productNameTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    productNameList = [[ProductManager sharedInstance] getProductNameList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback {
    if(!addNewShopProductViewController) {
        addNewShopProductViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewShopProduct];
        [controller addChildViewController:addNewShopProductViewController];
        [controller.view addSubview:addNewShopProductViewController.view];
        addNewShopProductViewController.saveCallback = saveCallback;
        addNewShopProductViewController.shopDetailViewController = (ShopDetailViewController *)controller;
    }
}

- (void)dismiss {
    if(addNewShopProductViewController) {
        [addNewShopProductViewController removeFromParentViewController];
        [addNewShopProductViewController.view removeFromSuperview];
        addNewShopProductViewController = nil;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _productNameTextField) {
        [RecommendListViewController showRecommendListAt:self
                                              viewSource:_productNameTextField
                                              recommends:productNameList
                                              onSelected:^(NSString *result) {
            [textField setText:result];
            [Utils hideKeyboard];
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [RecommendListViewController updateRecommedListWith:textField.text];
}

- (IBAction)onCancelClicked:(id)sender {
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender {
    if(![self isNewProductSatisfiedReq]) return;
    [Utils hideKeyboard];
    Product *newProduct = [[Product alloc] init];
    newProduct.name = _productNameTextField.text;
    newProduct.productDesc = _productDescTextView.text;
    newProduct.shopID = _shopDetailViewController.shop.ID;
    newProduct.productId = [[ProductManager sharedInstance] getProductIdBy:newProduct.name];
    if(newProduct.name == 0) {
        [CallbackAlertView setCallbackTaget:@"Error"
                                    message:@"Please input product name"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil cancelTitle:nil
                             cancelCallback:nil];
        return;
    }
    
    [self showActivity];
    NSDictionary *params = @{kTableName:kShopProductTableName,
                             kParams: @{kShopID: newProduct.shopID,
                                          kShopDesc: newProduct.productDesc,
                                          kProductID: newProduct.productId}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == 200) {
                 newProduct.productWhID = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:kData] objectForKey:kInsertID]];
                 _saveCallback(newProduct);
                 [self dismiss];
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgConnectFailed
                                              target:self
                                             okTitle:btnOK
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:btnOK
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}

- (BOOL)isNewProductSatisfiedReq {
    NSString *productName = _productNameTextField.text;
    if ([productNameList containsObject: productName]) {
        for (Product *product in _shopDetailViewController.products) {
            if ([product.name isEqualToString: productName]) {
                [CallbackAlertView setCallbackTaget:@"Error"
                                            message:@"This product is exist"
                                             target:self
                                            okTitle:@"OK"
                                         okCallback:nil
                                        cancelTitle:nil
                                     cancelCallback:nil];
                return NO;
            }
        }
        return YES;
    } else {
        [CallbackAlertView setCallbackTaget:@"Error"
                                    message:@"This product is not exist"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return NO;
    }
}


@end
