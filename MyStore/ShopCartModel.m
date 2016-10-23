//
//  ShopCartModel.m
//  MyStore
//
//  Created by Hancle on 16/9/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShopCartModel.h"

@implementation SCGoodsList

- (NSString *)tagsStr {
    NSString *tagStr = @"";
    if ([self.tags isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = self.tags.allKeys;
        for (NSString *key in keys) {
            NSString *val = self.tags[key];
            tagStr = [tagStr stringByAppendingString:key];
            tagStr = [tagStr stringByAppendingString:@":"];
            tagStr = [tagStr stringByAppendingString:val];
            tagStr = [tagStr stringByAppendingString:@" "];
        }
    }
    return tagStr;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end

@implementation ShopCart

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [SCGoodsList class]};
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end

@implementation ShopCartModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ShopCart class]};
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end
