//
//  MenuCell.m
//  Canets
//
//  Created by Quang on 12/3/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell {
    MenuCellProp *_content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setMenuWith:(MenuCellProp *)menuCell {
    _content = menuCell;
    _menuTitle.text = _content.cellTitle;
    UIImage *image = [UIImage imageNamed:_content.imageName];
    _menuImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_menuImage setTintColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation MenuCellProp
- (instancetype)initWith:(NSString *)title image:(NSString *)image {
    self = [super init];
    if(self) {
        self.cellTitle = title;
        self.imageName = image;
    }
    return self;
}
@end
