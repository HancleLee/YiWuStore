//
//  SortListModel.m
//  MyStore
//
//  Created by Hancle on 16/9/18.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SortListModel.h"

@implementation SortList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"myId" : @"id"};
}

@end

@implementation SortListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [SortList class]};
}

@end
