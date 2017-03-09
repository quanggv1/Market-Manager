//
//  AddNewShopViewController.m
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "AddNewShopViewController.h"
#import "ShopManager.h"
#import "Shop.h"

static AddNewShopViewController *addNewShopViewController;
@interface AddNewShopViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *shopDescTextView;
@end

@implementation AddNewShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback {
    if(!addNewShopViewController) {
        addNewShopViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewShop];
        [controller addChildViewController:addNewShopViewController];
        [controller.view addSubview:addNewShopViewController.view];
        addNewShopViewController.saveCallback = saveCallback;
    }
}

- (void)dismiss {
    if(addNewShopViewController) {
        [addNewShopViewController removeFromParentViewController];
        [addNewShopViewController.view removeFromSuperview];
        addNewShopViewController = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _shopNameTextField.text = [_shopNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (IBAction)onCancelClicked:(id)sender {
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender {
    [Utils hideKeyboard];
    if(_shopNameTextField.text.length == 0) {
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Please input shop name" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        return;
    }
    
    Shop *newShop = [[Shop alloc] init];
    newShop.name = _shopNameTextField.text;
    newShop.shopDesc = _shopDescTextView.text;

    [self showActivity];
    NSDictionary *params = @{@"tableName":kShopTableName,
                             @"params": @{kShopName:newShop.name,
                                          kShopDesc: newShop.shopDesc}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:kCode] intValue] == 200) {
            newShop.ID = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:kData] objectForKey:kInsertID]];
            [[ShopManager sharedInstance] insert:newShop];
            [self dismiss];
        } else {
            [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        }
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

@end
