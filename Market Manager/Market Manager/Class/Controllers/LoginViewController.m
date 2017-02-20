///
//  LoginViewController.m
//  Canets
//
//  Created by Quang on 11/27/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneValidation;
@property (weak, nonatomic) IBOutlet UILabel *labelPasswordValidation;
@property (weak, nonatomic) IBOutlet UIView *phoneSeparator;
@property (weak, nonatomic) IBOutlet UIView *passwordSeparator;
@property (strong, nonatomic) NSMutableArray *products;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Product *product1 = [[Product alloc] initWith:@{@"name":@"product1", @"date":@"2017/02/1"}];
    Product *product2 = [[Product alloc] initWith:@{@"name":@"product2", @"date":@"2017/02/2"}];
    Product *product3 = [[Product alloc] initWith:@{@"name":@"product3", @"date":@"2017/02/2"}];
    Product *product4 = [[Product alloc] initWith:@{@"name":@"product4", @"date":@"2017/02/3"}];
    Product *product5 = [[Product alloc] initWith:@{@"name":@"product5", @"date":@"2017/02/1"}];
    _products = [[NSMutableArray alloc] initWithArray:@[product1, product2, product3, product4, product5]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _phoneTextField.text = @"";
    _passwordTextField.text = @"";
    _labelPhoneValidation.text = @"";
    _labelPasswordValidation.text = @"";

}

- (IBAction)onLoginClicked:(id)sender {
    [self pushToMain];
//    [self sortByDate];
//    [self searchByName:@"1"];
}

- (void)sortByDate {
    NSArray *sortedArray = [_products sortedArrayUsingComparator:^NSComparisonResult(Product *obj1, Product *obj2) {
        NSDate *d1 = [[Utils dateFormatter] dateFromString: obj1.date];
        NSDate *d2 = [[Utils dateFormatter] dateFromString: obj2.date];
        return [d1 compare: d2];
    }];
    _products = [[NSMutableArray alloc] initWithArray:sortedArray];
}

- (void)searchByName:(NSString* )name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains %@", name];
    NSArray *filteredArray = [_products filteredArrayUsingPredicate:predicate];
}

- (void)searchByDate:(NSString *)date {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date contains %@", date];
    NSArray *filteredArray = [_products filteredArrayUsingPredicate:predicate];
}

- (void)pushToMain {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onForgetPasswordClicked:(id)sender {
}

- (IBAction)onSigninClicked:(id)sender {
    
}


@end
