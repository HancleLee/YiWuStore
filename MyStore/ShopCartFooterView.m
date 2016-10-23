//
//  ShopCartFooterView.m
//  MyStore
//
//  Created by Hancle on 16/8/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShopCartFooterView.h"

@implementation ShopCartFooterView

+ (ShopCartFooterView *)shopcartFooterView {
    ShopCartFooterView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    return view;
}

- (IBAction)selectAllBtnClick:(UIButton *)sender {
//    NSLog(@"select all");
    self.selectAllButton.selected = !self.selectAllButton.selected;

    if ([self.delegate respondsToSelector:@selector(selectAllWith:isSelected:)]) {
        [self.delegate selectAllWith:sender isSelected:self.selectAllButton.selected];
    }
}

- (IBAction)countBtnClick:(id)sender {
//    NSLog(@"count button click");
    if ([self.delegate respondsToSelector:@selector(countOrDeleteBtnClick:)]) {
        [self.delegate countOrDeleteBtnClick:sender];
    }
}


- (void)configureWith:(ShopCartModel *)model {
    ShopCartModel *shopcart = model;
    self.selectAllButton.selected = shopcart.isSelected;
    NSString *img0 = @"sc_unselect";
    if (shopcart.isSelected) {
        img0 = @"sc_select";
    }
    [self.selectAllButton setImage:ImageNamed(img0) forState:UIControlStateNormal];
    
    self.totalPriceLabel.text = PRICE_TEXT([ShopCartManager selectedGoodsPrice:model]);
}

@end
