//
//  ProductDetailViewController.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "Product.h"

@interface ProductDetailViewController : BaseViewController
@property (weak, nonatomic) Product *product;
@end
