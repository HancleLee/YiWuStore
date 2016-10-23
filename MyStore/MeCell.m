//
//  MeCell.m
//  MyStore
//
//  Created by Hancle on 16/8/13.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MeCell.h"

@implementation MeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
