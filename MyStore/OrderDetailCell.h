//
//  OrderDetailCell.h
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface OrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@property (weak, nonatomic) IBOutlet UIView *contactBackView;

@property (weak, nonatomic) IBOutlet UITableView *goodsBackView;

- (void)configureCellWith:(OrderList *)model;

@end
