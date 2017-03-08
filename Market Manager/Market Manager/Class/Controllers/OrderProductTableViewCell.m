//
//  OrderProductTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderProductTableViewCell.h"
#import "RecommendListViewController.h"

@interface OrderProductTableViewCell()<UITextFieldDelegate, iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productOrderLabel;
@property (weak, nonatomic) IBOutlet UITextField *wh1TextField;
@property (weak, nonatomic) IBOutlet UITextField *wh2TextField;
@property (weak, nonatomic) IBOutlet UITextField *whTLTextField;
@property (weak, nonatomic) IBOutlet UITextField *crateQtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *crateTypeTextField;
@property (weak, nonatomic) IBOutlet iCarousel *whCarousel;
@property (weak, nonatomic) Product *product;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) id controller;
@end
@implementation OrderProductTableViewCell

- (id)controller {
    if(!_controller) {
        UIView *view = self;
        while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
            view = view.superview;
        }
        _controller = ((UITableView *)view).dataSource;
    }
    return _controller;
}

-(void)setProduct:(Product *)product {
    _product = product;
    _productNameLabel.text = _product.name;
    _productOrderLabel.text = [NSString stringWithFormat:@"%ld", _product.order];
    _items = @[@0, @1, @2];
    [_whCarousel reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _wh1TextField.delegate = self;
    _wh2TextField.delegate = self;
    _whTLTextField.delegate = self;
    _crateQtyTextField.delegate = self;
    _crateTypeTextField.delegate = self;
    _whCarousel.delegate = self;
    _whCarousel.dataSource = self;
    _whCarousel.type = iCarouselTypeRotary;

    
    [_crateTypeTextField addTarget:self
                              action:@selector(crateTypeTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
}

- (void)crateTypeTextFieldDidChange:(UITextField *)textField {
    [RecommendListViewController updateRecommedListWith:textField.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _crateTypeTextField) {
        [RecommendListViewController showRecommendListAt:self.controller viewSource:textField recommends:@[@"type1", @"type2", @"type3"] onSelected:^(NSString *result) {
            [textField setText:result];
            [Utils hideKeyboard];
        }];
        
    }
}

#pragma mark - iCarousel
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UITextField *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, carousel.frame.size.width/2, carousel.frame.size.height*3/4)];
        view.layer.borderWidth = 1;
        view.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        label = [[UITextField alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:13];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UITextField *)[view viewWithTag:1];
    }

    label.text = [self.items[(NSUInteger)index] stringValue];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UITextField *label = nil;
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, carousel.frame.size.width*2/3, carousel.frame.size.height*3/4)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 1;
        view.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
        view.clipsToBounds = YES;
        label = [[UITextField alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:13.0];
        label.tag = 1;
        [view addSubview:label];
    } else {
        //get a reference to the label in the recycled view
        label = (UITextField *)[view viewWithTag:1];
    }
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.01;
        }
        case iCarouselOptionFadeMax:
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }

}




@end
