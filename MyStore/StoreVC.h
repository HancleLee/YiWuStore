//
//  StoreVC.h
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//
/**
 *  商家页
 */

#import "SuperVC.h"
#import "StoreModel.h"

@interface StoreVC : SuperVC

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) Store *shop;

@end
