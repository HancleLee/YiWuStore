//
//  AddressModel.m
//  MyStore
//
//  Created by Hancle on 16/9/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "AddressModel.h"

@implementation Address

@end

@implementation AddressList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"addressList" : [Address class]};
}

@end

@implementation AddressModel



@end
