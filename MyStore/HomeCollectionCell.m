//
//  HomeCollectionCell.m
//  MyStore
//
//  Created by Hancle on 16/7/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "HomeCollectionCell.h"

@implementation HomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.clipsToBounds = YES;
}

- (void)configureCellWith:(GoodsList *)good {
    [CommonFunction hk_setImage:good.logo imgview:self.imgView];

    self.detailLabel.text = good.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", good.curPrice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",good.prePrice];
}

@end
