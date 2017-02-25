//
//  AddNewSupplyViewController.m
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "AddNewSupplyViewController.h"
#import "SupplyManager.h"
#import "Supply.h"

static AddNewSupplyViewController *addNewSupplyViewController;
@interface AddNewSupplyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *SupplyNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *SupplyDescTextView;
@end

@implementation AddNewSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback {
    if(!addNewSupplyViewController) {
        addNewSupplyViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewSupply];
        [controller addChildViewController:addNewSupplyViewController];
        [controller.view addSubview:addNewSupplyViewController.view];
        addNewSupplyViewController.saveCallback = saveCallback;
    }
}

- (void)dismiss {
    if(addNewSupplyViewController) {
        [addNewSupplyViewController removeFromParentViewController];
        [addNewSupplyViewController.view removeFromSuperview];
        addNewSupplyViewController = nil;
    }
}

- (IBAction)onCancelClicked:(id)sender {
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender {
    [Utils hideKeyboard];
    NSString *SupplyName = [_SupplyNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *SupplyDesc = [_SupplyDescTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!SupplyName || SupplyName.length == 0) {
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Please input Supply name" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        return;
    }
    
    [self showActivity];
    NSDictionary *params = @{@"tableName":kSupplyTableName,
                             @"params": @{kSupplyName:SupplyName,
                                          kSupplyDesc: SupplyDesc}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString *SupplyID = [NSString stringWithFormat:@"%@", [data objectForKey:@"insertId"]];
            [self addNewSupply:SupplyID name:SupplyName description:SupplyDesc];
            [self hideActivity];
            [self dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (void)addNewSupply:(NSString *)SupplyID name:(NSString *)SupplyName description:(NSString *)description {
    Supply *newSupply = [[Supply alloc] initWith:@{kSupplyID:SupplyID,
                                             kSupplyName:SupplyName,
                                             kSupplyDesc: description}];
    [[SupplyManager sharedInstance] insert:newSupply];
    self.saveCallback(newSupply);
}

@end
