//
//  OrderDetailFooterView.h
//  MyStore
//
//  Created by Hancle on 16/10/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"
#import "OrderListModel.h"

@interface OrderDetailFooterView : SuperView

- (void)configureViewWith:(OrderList *)orderlist status:(HKOrderStatus)status;

@end
