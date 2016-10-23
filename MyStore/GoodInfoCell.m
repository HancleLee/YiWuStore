//
//  GoodInfoCell.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodInfoCell.h"
#import "ShopCartModel.h"

@implementation GoodInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgview.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWith:(id)good tags:(NSString *)tags num:(NSString *)num {
    if ([good isKindOfClass:[GoodsList class]]) {
        GoodsList *goodslist = good;
        [CommonFunction hk_setImage:goodslist.logoThumb imgview:self.imgview];

        self.nameLabel.text = goodslist.name;
        self.priceLabel.text = PRICE_TEXT(goodslist.curPrice);
        self.originPriceLabel.text = PRICE_TEXT(goodslist.prePrice);
        
    }else if ([good isKindOfClass:[SCGoodsList class]]) {
        SCGoodsList *goodslist = good;
        [CommonFunction hk_setImage:goodslist.goodsLogo imgview:self.imgview];
        self.nameLabel.text = goodslist.goodsName;
        self.priceLabel.text = PRICE_TEXT(goodslist.curPrice);
        self.originPriceLabel.text = PRICE_TEXT(goodslist.prePrice);
    }
    
    self.infoLabel.text = tags;
    self.numberLabel.text = StringWithFomat2(@"X ", num);
}

@end
