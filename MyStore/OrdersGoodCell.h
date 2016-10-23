//
//  OrdersGoodCell.h
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"
@class OrdersGoodCell;

@protocol OrdersGoodCellDelegate <NSObject>

- (void)commentBtnClick:(OrdersGoodCell *)cell good:(SCGoodsList *)good;

@end

@interface OrdersGoodCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodDescTrailConstraint;
@property (nonatomic, assign) id<OrdersGoodCellDelegate> delegate;

- (void)configureCellWith:(SCGoodsList *)good showComment:(BOOL)showCommentButton;

@end
