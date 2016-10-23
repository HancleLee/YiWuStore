//
//  SelectPayTypeCell.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SelectPayTypeCell.h"

@implementation SelectPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnClick:(id)sender {
    self.selectPayBlock(self.selectButton.tag);
}

@end
