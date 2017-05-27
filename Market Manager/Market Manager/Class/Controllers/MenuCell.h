//
//  MenuCell.h
//  Canets
//
//  Created by Quang on 12/3/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCellProp : NSObject
@property (nonatomic, strong) NSString *imageName, *cellTitle;
- (instancetype)initWith:(NSString *)title image:(NSString *)image;
@end

@interface MenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView    *menuImage;
@property (weak, nonatomic) IBOutlet UILabel        *menuTitle;
@property (weak, nonatomic) IBOutlet UIImageView    *banner;
- (void)setMenuWith:(MenuCellProp *)menuCell;
@end
