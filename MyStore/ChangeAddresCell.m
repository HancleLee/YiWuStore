//
//  ChangeAddresCell.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ChangeAddresCell.h"

@implementation ChangeAddresCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButton.hidden = YES;
    self.selectButton.selected = NO;
    [self.selectButton setImage:ImageNamed(@"sc_unselect") forState:UIControlStateNormal];
    [self.selectButton setImage:ImageNamed(@"sc_select") forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnClick:(id)sender {
    NSLog(@"select button click");
    self.selectButton.selected = !self.selectButton.selected;
}

@end
