//
//  OrderDetailFooterCell.m
//  MyStore
//
//  Created by Hancle on 16/10/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderDetailFooterCell.h"

@interface OrderDetailFooterCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation OrderDetailFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(NSString *)title detail:(NSString *)detail {
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}

@end
