//
//  AddressModel.h
//  MyStore
//
//  Created by Hancle on 16/9/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface Address : NSObject

@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *contact;

@end

@interface AddressList : NSObject

@property (nonatomic, copy) NSString *defaultAddressId;
@property (nonatomic, strong) NSArray *addressList;

@end

@interface AddressModel : SuperModel

@property (nonatomic, strong) AddressList *data;

@end
