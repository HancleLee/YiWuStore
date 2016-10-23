//
//  ShopListModel.m
//  MyStore
//
//  Created by Hancle on 16/9/3.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopList



@end

@implementation ShopListModel

- (ShopListModel *)addObjWith:(ShopListModel *)model {
    ShopListModel *sModel = model;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.data];
    for (id item in sModel.data) {
        [dataArr addObject:item];
    }
    sModel.data = dataArr;
    return sModel;
}

@end
