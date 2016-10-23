//
//  OrderModel.m
//  MyStore
//
//  Created by Hancle on 16/9/11.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderModel.h"

@implementation Order

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderIds" : [NSString class]};
}

@end

@implementation OrderModel

@end
