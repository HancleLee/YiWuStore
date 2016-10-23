//
//  GoodsListModel.m
//  MyStore
//
//  Created by Hancle on 16/8/28.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imageList" : [NSString class], @"thumbList": [NSString class]};
}

- (NSString *)tagsStr {
    NSString *tagstr = @"";
    if ([self.tags isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = self.tags.allKeys;
        for (NSString *key in keys) {
            id item = self.tags[key];
            if ([item isKindOfClass:[NSString class]]) {
                NSString *val = self.tags[key];
                tagstr = [tagstr stringByAppendingString:key];
                tagstr = [tagstr stringByAppendingString:@":"];
                tagstr = [tagstr stringByAppendingString:val];
                tagstr = [tagstr stringByAppendingString:@" "];
                
            }else if ([item isKindOfClass:[NSArray class]]) {
                NSArray *arr = item;
                tagstr = [tagstr stringByAppendingString:key];
                tagstr = [tagstr stringByAppendingString:@":"];
                int i = 0;
                for (id it in arr) {
                    if ([it isKindOfClass:[NSString class]]) {
                        NSString *vl = arr[i];
                        tagstr = [tagstr stringByAppendingString:vl];
                        tagstr = [tagstr stringByAppendingString:@" "];
                    }
                    i ++;
                }
            }
        }
    }
    return tagstr;
}

@end

@implementation GoodsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [GoodsList class]};
}

- (GoodsListModel *)addObjWith:(GoodsListModel *)model {
    GoodsListModel *sModel = model;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.data];
    for (id item in sModel.data) {
        [dataArr addObject:item];
    }
    sModel.data = dataArr;
    return sModel;
}

@end
