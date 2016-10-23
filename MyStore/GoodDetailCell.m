//
//  GoodDetailCell.m
//  MyStore
//
//  Created by Hancle on 16/9/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodDetailCell.h"

@implementation GoodDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(id)img title:(NSString *)title {
    if ([img isKindOfClass:[UIImage class]]) {
        [self.imgview setImage:img];
        self.imgWidthConstraint.constant = 16.0;
        self.imgHeightConstraint.constant = 16.0;
    }else {
        self.imgview.layer.cornerRadius = CGRectGetHeight(self.imgview.frame) / 2;
        self.imgview.layer.masksToBounds = YES;
        [CommonFunction hk_setImage:img imgview:self.imgview];
    }
    self.titleLabel.text = title;
}

@end
