//
//  OrderDetailVC.h
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperVC.h"
#import "OrderListModel.h"

@protocol OrderDetailVCDelegate <NSObject>

- (void)cancelOrderSuccessWith:(OrderList *)order;

@end

@interface OrderDetailVC : SuperVC

@property (nonatomic, strong) OrderList *order;
@property (nonatomic, assign) HKOrderStatus orderStatus;
@property (nonatomic, assign) id<OrderDetailVCDelegate> delegate;

@end
