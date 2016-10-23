//
//  OrderAddressCell.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderAddressCell.h"

@implementation OrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWith:(Address *)address {
    if (address) {
        self.contactLabel.text = [NSString stringWithFormat:@"收货人：%@    %@", address.contact, address.phone];
        self.addressLabel.text = StringWithFomat2(address.area, address.address);
    }else {
        self.contactLabel.text = @"收货人：请选择";
        self.addressLabel.text = @"收获地址：请选择";
    }
    
}

@end
