//
//  ShopCartFooterView.h
//  MyStore
//
//  Created by Hancle on 16/8/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"
#import "ShopCartManager.h"

@protocol ShopCartFooterViewDelegate <NSObject>

- (void)selectAllWith:(UIButton *)button isSelected:(BOOL)isSelected;
- (void)countOrDeleteBtnClick:(UIButton *)button;

@end

@interface ShopCartFooterView : SuperView

+ (ShopCartFooterView *)shopcartFooterView;

@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *countButton;

@property (nonatomic, assign) id<ShopCartFooterViewDelegate> delegate;

- (void)configureWith:(ShopCartModel *)model;

@end
