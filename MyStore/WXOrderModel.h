//
//  WXOrderModel.h
//  MyStore
//
//  Created by Hancle on 16/10/12.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface WXOrder : SuperModel

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, assign) UInt32 timestamp;

@end

@interface WXOrderModel : SuperModel

@property (nonatomic, strong) WXOrder *data;

@end
