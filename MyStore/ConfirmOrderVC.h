//
//  ConfirmOrderVC.h
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//
/**
 *  确认订单页
 */

#import "SuperVC.h"
#import "GoodsListModel.h"
#import "ShopCartManager.h"
#import "MeManager.h"

@protocol ConfirmOrderVCDelegate <NSObject>

- (void)creatOrderSuccessWith:(ShopCartModel *)cartmodel;

@end

@interface ConfirmOrderVC : SuperVC

// 购物车跳转
@property (nonatomic, strong) ShopCartModel *cartModel;

// 商品详情页跳转
@property (nonatomic, strong) GoodsList *good;  // 商品
@property (nonatomic, strong) NSDictionary *selctedTags; // 选择的标签
@property (nonatomic, copy) NSString *num;  // 商品数目

@property (nonatomic, assign) id<ConfirmOrderVCDelegate> delegate;

@end
