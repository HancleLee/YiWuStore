//
//  ShoppingCartCell.h
//  MyStore
//
//  Created by Hancle on 16/8/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"

@protocol ShoppingCartCellDelegate <NSObject>

- (void)shopSelectBtnClick:(UIButton *)button shopId:(NSString *)shopId isSelected:(BOOL)isSelected;
- (void)goodSelectBtnClick:(UIButton *)button good:(SCGoodsList *)good isSelected:(BOOL)isSelected;
- (void)changeGoodAmountWith:(SCGoodsList *)good amount:(NSString *)amount;

@end

@interface ShoppingCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *storeBackView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *shopSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *storeImgview;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImgview;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, assign) id<ShoppingCartCellDelegate> delegate;

- (void)configureCellWith:(ShopCart *)shopcart index:(NSInteger)index ;

@end
