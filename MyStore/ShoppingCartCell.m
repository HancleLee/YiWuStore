//
//  ShoppingCartCell.m
//  MyStore
//
//  Created by Hancle on 16/8/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShoppingCartCell.h"

@interface ShoppingCartCell ()

@property (nonatomic, strong) ShopCart *shopcart;
@property (nonatomic, strong) SCGoodsList *good;

@end

@implementation ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.storeImgview.layer.cornerRadius = CGRectGetHeight(self.storeImgview.frame) / 2;
    self.storeImgview.clipsToBounds = YES;
    self.storeBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToShop)];
    [self.storeBackView addGestureRecognizer:gesture];
    
    self.goodImgview.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnClick:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
    if ([self.delegate respondsToSelector:@selector(goodSelectBtnClick:good:isSelected:)]) {
        [self.delegate goodSelectBtnClick:sender good:self.good isSelected:self.selectButton.selected];
    }
}

- (IBAction)shopSelectBtnClick:(UIButton *)sender {
    self.shopSelectButton.selected = !self.shopSelectButton.selected;
    if ([self.delegate respondsToSelector:@selector(shopSelectBtnClick:shopId:isSelected:)]) {
        [self.delegate shopSelectBtnClick:sender shopId:self.shopcart.shopId isSelected:self.shopSelectButton.selected];
    }
}

- (IBAction)reduceBtnClick:(id)sender {
    NSInteger num = [self.goodNumLabel.text integerValue];
    if (num == 1) {
        [CommonFunction showHUDIn:[CommonFunction topViewController] text:@"宝贝不能再少了哦～"];
        return;
    }
    if (num > 0)  num --;
    self.goodNumLabel.text = [NSString stringWithFormat:@"%zd", num];
    if ([self.delegate respondsToSelector:@selector(changeGoodAmountWith:amount:)]) {
        [self.delegate changeGoodAmountWith:self.good amount:self.goodNumLabel.text];
    }
}

- (IBAction)addBtnClick:(id)sender {
    NSInteger num = [self.goodNumLabel.text integerValue];
    num ++;
    self.goodNumLabel.text = [NSString stringWithFormat:@"%zd", num];
    if ([self.delegate respondsToSelector:@selector(changeGoodAmountWith:amount:)]) {
        [self.delegate changeGoodAmountWith:self.good amount:self.goodNumLabel.text];
    }
}

// 跳转至商店
- (void)jumpToShop {
    NSLog(@"jump to shop");
}

- (void)configureCellWith:(ShopCart *)shopcart index:(NSInteger)index {
    self.shopcart = shopcart;

    if (index == 0) {
        self.storeNameLabel.text = shopcart.shopName;
        [CommonFunction hk_setImage:shopcart.shopThumb imgview:self.storeImgview];
    }
    if (index < shopcart.goodsList.count) {
        self.good = shopcart.goodsList[index];

        self.goodNameLabel.text = self.good.goodsName;
        self.goodPriceLabel.text = PRICE_TEXT(self.good.curPrice);
        self.goodNumLabel.text = [NSString stringWithFormat:@"%zd",[self.good.amount integerValue]];
        [CommonFunction hk_setImage:self.good.goodsLogoThumb imgview:self.goodImgview];

        NSString *tagStr = @"";
        if ([self.good.tags isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = self.good.tags.allKeys;
            for (NSString *key in keys) {
                NSString *val = self.good.tags[key];
                tagStr = [tagStr stringByAppendingString:key];
                tagStr = [tagStr stringByAppendingString:@":"];
                tagStr = [tagStr stringByAppendingString:val];
                tagStr = [tagStr stringByAppendingString:@" "];
            }
        }
        self.shopSelectButton.selected = _shopcart.isSelected;
        NSString *img0 = @"sc_unselect";
        if (_shopcart.isSelected) {
            img0 = @"sc_select";
        }
        [self.shopSelectButton setImage:ImageNamed(img0) forState:UIControlStateNormal];
        
        self.selectButton.selected = _good.isSelected;
        self.goodDetailLabel.text = tagStr;
        NSString *img = @"sc_unselect";
        if (_good.isSelected) {
            img = @"sc_select";
        }
        [self.selectButton setImage:ImageNamed(img) forState:UIControlStateNormal];
    }
}

@end
