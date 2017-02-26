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
@interface AddNewShopViewController ()
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

- (IBAction)onCancelClicked:(id)sender {
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender {
    [Utils hideKeyboard];
    NSString *shopName = [_shopNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *shopDesc = [_shopDescTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!shopName || shopName.length == 0) {
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Please input shop name" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        return;
    }

    [self showActivity];
    NSDictionary *params = @{@"tableName":kShopTableName,
                             @"params": @{kShopName:shopName,
                                          kShopDesc: shopDesc}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString *shopID = [NSString stringWithFormat:@"%@", [data objectForKey:@"insertId"]];
            [self addNewShop:shopID name:shopName description:shopDesc];
            [self hideActivity];
            [self dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (void)addNewShop:(NSString *)shopID name:(NSString *)shopName description:(NSString *)description {
    Shop *newShop = [[Shop alloc] initWith:@{kShopID:shopID,
                                             kShopName:shopName,
                                             kShopDesc: description}];
    [[ShopManager sharedInstance] insert:newShop];
    self.saveCallback(newShop);
}

@end
