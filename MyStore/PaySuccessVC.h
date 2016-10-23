//
//  PaySuccessVC.h
//  MyStore
//
//  Created by Hancle on 16/8/24.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperVC.h"
#import "OrderModel.h"

@interface PaySuccessVC : SuperVC

@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, assign) HKPayType payType;
@property (nonatomic) id orderIds;

@end
