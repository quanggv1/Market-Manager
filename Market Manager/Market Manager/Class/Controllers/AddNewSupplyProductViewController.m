//
//  AddNewSupplyProductViewController.m
//  Market Manager
//
//  Created by Quang on 3/9/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "AddNewSupplyProductViewController.h"
#import "RecommendListViewController.h"
#import "ProductManager.h"
#import "SupplyDetailViewController.h"

static AddNewSupplyProductViewController *addNewSupplyProductViewController;
@interface AddNewSupplyProductViewController ()
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *productDescTextView;
@property (weak, nonatomic) SupplyDetailViewController *supplyDetailViewController;
@end

@implementation AddNewSupplyProductViewController {
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
    if(!addNewSupplyProductViewController) {
        addNewSupplyProductViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewSupplyProduct];
        [controller addChildViewController:addNewSupplyProductViewController];
        [controller.view addSubview:addNewSupplyProductViewController.view];
        addNewSupplyProductViewController.saveCallback = saveCallback;
        addNewSupplyProductViewController.supplyDetailViewController = (SupplyDetailViewController *)controller;
    }
}

- (void)dismiss {
    if(addNewSupplyProductViewController) {
        [addNewSupplyProductViewController removeFromParentViewController];
        [addNewSupplyProductViewController.view removeFromSuperview];
        addNewSupplyProductViewController = nil;
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
    newProduct.whID = _supplyDetailViewController.supply.ID;
    newProduct.productId = [[ProductManager sharedInstance] getProductIdBy:newProduct.name];
    if(newProduct.name == 0) {
        [CallbackAlertView setCallbackTaget:@"Error"
                                    message:@"Please input product name"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return;
    }
    
    [self showActivity];
    NSDictionary *params = @{kTableName:kWarehouseProductTableName,
                                kParams: @{kSupplyID: newProduct.whID,
                                           kProductDesc: newProduct.productDesc,
                                           kProductID: newProduct.productId}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                 newProduct.productWhID = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:kData] objectForKey:kInsertID]];
                 _saveCallback(newProduct);
                 [self dismiss];
             } else {
                 [CallbackAlertView setCallbackTaget:@"Error"
                                             message:@"Can't connect to server"
                                              target:self
                                             okTitle:@"OK"
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [CallbackAlertView setCallbackTaget:@"Error"
                                         message:@"Can't connect to server"
                                          target:self
                                         okTitle:@"OK"
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];    }];
}

- (BOOL)isNewProductSatisfiedReq {
    NSString *productName = _productNameTextField.text;
    if ([productNameList containsObject: productName]) {
        for (Product *product in _supplyDetailViewController.products) {
            if ([product.name isEqualToString: productName]) {
                [CallbackAlertView setCallbackTaget:@"Error" message:@"This product is exist" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
                return NO;
            }
        }
        return YES;
    } else {
        [CallbackAlertView setCallbackTaget:@"Error" message:@"This product is not exist" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        return NO;
    }
}


@end
