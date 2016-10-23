//
//  ShopCartManager.h
//  MyStore
//
//  Created by Hancle on 16/9/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartModel.h"

@interface ShopCartManager : NSObject

+ (ShopCartModel *)updateModelSelectStatusAtShop:(NSString *)shopId isSelected:(BOOL)isSelected model:(ShopCartModel *)model;
+ (ShopCartModel *)updateModelSelectStatusAt:(SCGoodsList *)good isSelected:(BOOL)isSelected model:(ShopCartModel *)model;
+ (ShopCartModel *)updateModelAmountAt:(SCGoodsList *)good amount:(NSString *)amount model:(ShopCartModel *)model;
+ (ShopCartModel *)updateModelAllSelectStatusWith:(BOOL)isSelected model:(ShopCartModel *)model;
+ (ShopCartModel *)deleteSelectedGoods:(ShopCartModel *)model;
+ (NSString *)selectedGoodsPrice:(ShopCartModel *)model;
+ (NSArray *)selectedGoods:(ShopCartModel *)model;

+ (ShopCartModel *)selectedCartModel:(ShopCartModel *)cm;
+ (BOOL)isSelectedGoodsIn:(ShopCartModel *)model;

@end
