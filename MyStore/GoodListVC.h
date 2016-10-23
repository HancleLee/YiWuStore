//
//  GoodListVC.h
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//
/**
 *  商品列表页
 */

#import "SuperVC.h"

@interface GoodListVC : SuperVC

// type=1是商品分类，type=2是活动分类
@property (nonatomic, copy, nonnull) NSString *type;
@property (nonatomic, copy, nonnull) NSString *sortId;
@property (nonatomic, copy, nullable) NSString *navTitle;

@end
