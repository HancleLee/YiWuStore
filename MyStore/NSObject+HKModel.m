//
//  NSObject+HKModel.m
//  MyStore
//
//  Created by Hancle on 16/9/29.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "NSObject+HKModel.h"
#import <objc/message.h>

@implementation NSObject (HKModel)

- (id)hk_modelToJsonObject {
    id jsonObject = ModelToJSONObjectRecursive(self);
    if ([jsonObject isKindOfClass:[NSArray class]]) return jsonObject;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) return jsonObject;
    return nil;
}

static id ModelToJSONObjectRecursive(NSObject *model) {
    if (!model || model == (id)kCFNull) return model;
    if ([model isKindOfClass:[NSString class]]) return model;
    if ([model isKindOfClass:[NSNumber class]]) return model;
    if ([model isKindOfClass:[NSDictionary class]]) {
        if ([NSJSONSerialization isValidJSONObject:model]) return model;

        NSDictionary *tdic = (NSDictionary *)model;
        __block id val;
        
        [tdic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // 类型经常变，抽出来            
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
                val = obj;
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
                val = ModelToJSONObjectRecursive(obj);
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
                val = obj;
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
                val = ModelToJSONObjectRecursive(obj);
            }
        }];
        
        return val;
//        NSMutableDictionary *newDic = [NSMutableDictionary new];
//        [((NSDictionary *)model) enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
//            NSString *stringKey = [key isKindOfClass:[NSString class]] ? key : key.description;
//            if (!stringKey) return;
//            id jsonObj = ModelToJSONObjectRecursive(obj);
//            if (!jsonObj) jsonObj = (id)kCFNull;
//            newDic[stringKey] = jsonObj;
//        }];
//        return newDic;
    }
    if ([model isKindOfClass:[NSSet class]]) {
        NSArray *array = ((NSSet *)model).allObjects;
        if ([NSJSONSerialization isValidJSONObject:array]) return array;
        NSMutableArray *newArray = [NSMutableArray new];
        for (id obj in array) {
            if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                [newArray addObject:obj];
            } else {
                id jsonObj = ModelToJSONObjectRecursive(obj);
                if (jsonObj && jsonObj != (id)kCFNull) [newArray addObject:jsonObj];
            }
        }
        return newArray;
    }
    if ([model isKindOfClass:[NSArray class]]) {
        if ([NSJSONSerialization isValidJSONObject:model]) return model;
        NSMutableArray *newArray = [NSMutableArray new];
        for (id obj in (NSArray *)model) {
            if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                [newArray addObject:obj];
            } else {
                id jsonObj = ModelToJSONObjectRecursive(obj);
                if (jsonObj && jsonObj != (id)kCFNull) [newArray addObject:jsonObj];
            }
        }
        return newArray;
    }
    if ([model isKindOfClass:[NSURL class]]) return ((NSURL *)model).absoluteString;
    if ([model isKindOfClass:[NSAttributedString class]]) return ((NSAttributedString *)model).string;
    if ([model isKindOfClass:[NSData class]]) return nil;
    return nil;
}

@end
