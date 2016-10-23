//
//  OrderListModel.m
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderListModel.h"

@implementation AfterSaleService

@end

@implementation OrderList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList":[SCGoodsList class], @"comment":[Comment class] };
}

- (NSString *)createTimeStr {
    return [CommonFunction transformTimeStamp:(double)self.createTime andForm:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)deliverTimeStr {
    return [CommonFunction transformTimeStamp:(double)self.deliverTime andForm:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)payTimeStr {
    return [CommonFunction transformTimeStamp:(double)self.payTime andForm:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)receiveTimeStr {
    return [CommonFunction transformTimeStamp:(double)self.receiveTime andForm:@"yyyy-MM-dd HH:mm"];
}

- (void)details {
    //(1)获取类的属性及属性对应的类型
    NSMutableArray * keys = [NSMutableArray array];
    NSMutableArray * attributes = [NSMutableArray array];
    /*
     * 例子
     * name = value3 attribute = T@"NSString",C,N,V_value3
     * name = value4 attribute = T^i,N,V_value4
     */
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //通过property_getName函数获得属性的名字
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
        //通过property_getAttributes函数可以获得属性的名字和@encode编码
        NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        [attributes addObject:propertyAttribute];
    }
    //立即释放properties指向的内存
    free(properties);
    
    //(2)根据类型给属性赋值
    for (NSString * key in keys) {
//        if ([dict valueForKey:key] == nil) continue;
//        [self setValue:[dict valueForKey:key] forKey:key];
    }
}

@end

@implementation OrderListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [OrderList class]};
}

@end
