//
//  MeManager.h
//  MyStore
//
//  Created by Hancle on 16/9/8.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface MeManager : NSObject

@property (nonatomic, strong) AddressModel *addressModel;
+ (MeManager *)shareInstance;

@end
