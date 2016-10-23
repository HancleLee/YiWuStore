//
//  CategoryTableViewCell.m
//  MyStore
//
//  Created by Hancle on 16/8/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configigureCellWith:(NSString *)type isSelected:(BOOL)isSelected {
    if (isSelected) {
        self.backgroundColor = WhiteColor;
        self.typeLabel.textColor = MainRedColor;
    }else {
        self.backgroundColor = MainBackColor;
        self.typeLabel.textColor = MainBlackColor;
    }
    self.typeLabel.text = type;
}

@end
