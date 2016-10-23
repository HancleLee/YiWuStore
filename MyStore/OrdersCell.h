//
//  OrdersCell.h
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@class OrdersCell;

@protocol OrderCellDelegate <NSObject>

@optional
- (void)leftBtnCLick:(OrdersCell *)cell model:(OrderList *)model;
- (void)rightBtnCLick:(OrdersCell *)cell model:(OrderList *)model;
- (void)commentBtnClick:(OrdersCell *)cell model:(SCGoodsList *)model orderId:(NSString *)orderId;
- (void)selectedCellWith:(OrdersCell *)cell index:(NSInteger)index;

@end

@interface OrdersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@property (weak, nonatomic) IBOutlet UITableView *goodsBackView;


@property (weak, nonatomic) IBOutlet UIView *buttonBackView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, assign) id<OrderCellDelegate> delegate;
- (void)configureCellWith:(OrderList *)model;

@end
