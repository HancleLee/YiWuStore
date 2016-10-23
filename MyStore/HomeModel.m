//
//  HomeModel.m
//  MyStore
//
//  Created by Hancle on 16/8/9.
//  Copyright © 2016年 Hancle. All rights reserved.
//
#import "HomeModel.h"

@implementation Banner


@end

@implementation HomeData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banner" : [Banner class], @"promotion": [GoodsList class], @"shop" : [Store class], @"tags" : [SortListModel class]};
}

@end

@implementation HomeModel


@end
