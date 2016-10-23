//
//  CollectionModel.m
//  MyStore
//
//  Created by Hancle on 16/9/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [GoodsList class]};
}

- (CollectionModel *)addObjWith:(CollectionModel *)model {
    CollectionModel *sModel = model;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.data];
    for (id item in sModel.data) {
        [dataArr addObject:item];
    }
    sModel.data = dataArr;
    return sModel;
}

@end
