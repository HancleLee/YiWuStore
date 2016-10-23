//
//  HomeHeaderViewCell.m
//  MyStore
//
//  Created by Hancle on 16/7/20.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "HomeHeaderViewCell.h"

@implementation HomeHeaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = MainBlackColor;
}

- (void)configureWithSize:(CGSize)size icon:(id)icon title:(NSString *)title  fontSize:(CGFloat)fontSize {
    self.imgViewHeightConstraint.constant = size.height;
    self.imgViewHeightWidthConstraint.constant = size.width;
    self.titleLabel.text = title;
    self.imgView.layer.cornerRadius = size.height / 2;
    self.imgView.clipsToBounds = YES;
    self.titleLabel.font = FontSize(fontSize);
    if ([icon isKindOfClass:[UIImage class]]) {
        [self.imgView setImage:icon];

    }else if ([icon isKindOfClass:[NSURL class]]) {
        [self.imgView sd_setImageWithURL:icon placeholderImage:DEFAULT_PIC];
    }
}

@end
