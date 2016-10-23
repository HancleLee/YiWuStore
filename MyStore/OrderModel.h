//
//  OrderModel.h
//  MyStore
//
//  Created by Hancle on 16/9/11.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface Order : SuperModel

@property (nonatomic, copy) NSArray *orderIds;
@property (nonatomic, copy) NSString *totalPrice;

@end

@interface OrderModel : SuperModel

@property (nonatomic, strong) Order *data;

@end
