//
//  ShipAddressCell.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShipAddressCell.h"

@implementation ShipAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.editButton.layer.cornerRadius = 5.0;
    self.editButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editBtnClick:cell:)]) {
        [self.delegate editBtnClick:sender cell:self];
    }
}


@end
