//
//  MyAvatarCell.m
//  MyStore
//
//  Created by Hancle on 16/8/13.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MyAvatarCell.h"

@implementation MyAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImgView.layer.cornerRadius = CGRectGetHeight(self.avatarImgView.frame) / 2;
    self.avatarImgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
