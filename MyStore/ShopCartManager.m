//
//  ShopCartManager.m
//  MyStore
//
//  Created by Hancle on 16/9/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShopCartManager.h"

@implementation ShopCartManager

//+ (ShopCartManager *)shareInstance {
//    static ShopCartManager *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[ShopCartManager alloc] init];
//    });
//    return instance;
//}

+ (ShopCartModel *)updateModelSelectStatusAtShop:(NSString *)shopId isSelected:(BOOL)isSelected  model:(ShopCartModel *)model {
    if (!isSelected) {
        model.isSelected = NO;
    }
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            if (cart.shopId.integerValue == shopId.integerValue) {
                cart.isSelected = isSelected;
                for (id item in cart.goodsList) {
                    if ([item isKindOfClass:[SCGoodsList class]]) {
                        SCGoodsList *good = item;
                        good.isSelected = isSelected;
                    }
                }
                break;
            }
        }
    }
    return model;
}

+ (ShopCartModel *)updateModelSelectStatusAt:(SCGoodsList *)good isSelected:(BOOL)isSelected model:(ShopCartModel *)model {
    if (!isSelected) {
        model.isSelected = NO;
    }
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            for (id item in cart.goodsList) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *goodlist = item;
                    if (goodlist == good) {
                        goodlist.isSelected = isSelected;
                        if (!isSelected) {
                            cart.isSelected = NO;
                            
                        }else {
                            cart.isSelected = YES;
                            for (id item in cart.goodsList) {
                                if ([item isKindOfClass:[SCGoodsList class]]) {
                                    SCGoodsList *good1 = item;
                                    if (!good1.isSelected) {
                                        cart.isSelected = NO;
                                        break;
                                    }
                                }
                            }
                        }
                        break;
                    }
                }
            }
        }
    }
    return model;
}

+ (ShopCartModel *)updateModelAllSelectStatusWith:(BOOL)isSelected model:(ShopCartModel *)model {
    model.isSelected = isSelected;
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            cart.isSelected = isSelected;
            for (id item in cart.goodsList) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *good = item;
                    good.isSelected = isSelected;
                }
            }
        }
    }
    return model;
}

+ (ShopCartModel *)updateModelAmountAt:(SCGoodsList *)good amount:(NSString *)amount model:(ShopCartModel *)model {
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            for (id item in cart.goodsList) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *goodlist = item;
                    if (goodlist == good) {
                        goodlist.amount = amount;
                    }
                }
            }
        }
    }
    return model;
}

+ (NSString *)selectedGoodsPrice:(ShopCartModel *)model {
    CGFloat total = 0;
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            for (id item in cart.goodsList) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *good = item;
                    if (good.isSelected == YES) {
                        total = total + (good.curPrice.floatValue * good.amount.floatValue);
                    }
                }
            }
        }
    }
    return [NSString stringWithFormat:@"%.2f",total];
}

+ (ShopCartModel *)deleteSelectedGoods:(ShopCartModel *)model {
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            for (id item in cart.goodsList) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *good = item;
                    if (good.isSelected == YES) {
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:cart.goodsList];
                        [arr removeObject:good];
                        cart.goodsList = arr;
                    }
                }
            }
        }
    }
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            if (cart.goodsList.count == 0) {
                NSMutableArray *arr1 = [NSMutableArray arrayWithArray:model.data];
                [arr1 removeObject:cart];
                model.data = arr1;
            }
        }
    }
    model.isSelected = NO;
    return model;
}

+ (NSArray *)selectedGoods:(ShopCartModel *)model {
    NSMutableArray *selectedArr = [NSMutableArray array];
    for (id item in model.data) {
        if ([item isKindOfClass:[ShopCart class]]) {
            ShopCart *cart = item;
            for (id item in cart.goodsList) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *good = item;
                    if (good.isSelected == YES) {
                        [selectedArr addObject:good];
                    }
                }
            }
        }
    }
    return selectedArr;
}

+ (ShopCartModel *)selectedCartModel:(ShopCartModel *)model {
    ShopCartModel *cm = [ShopCartModel new];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (ShopCart *cart in model.data) {
        ShopCart *ct = [cart mutableCopy];
        NSMutableArray *goods = [NSMutableArray array];
        for (SCGoodsList *good in ct.goodsList) {
            if (good.isSelected == YES) {
                if (![goods containsObject:good]) {
                    [goods addObject:[good mutableCopy]];
                }
            }
        }
        ct.goodsList = goods;
        if (goods.count > 0) {
            if (![arr containsObject:ct]) {
                [arr addObject:ct];
            }
        }
    }
    cm.data = arr;

    return cm;
}


+ (BOOL)isSelectedGoodsIn:(ShopCartModel *)cm {
    for (ShopCart *cart in cm.data) {
        for (SCGoodsList *good in cart.goodsList) {
            if (good.isSelected == YES) {
                return YES;
            }
        }
    }
    return NO;
}


//+ (NSString *)orderTotalPriceWith:(ShopCartModel *)cartModel {
//    ShopCartModel *model = [self selectedCartModelWith:cartModel];
//    
//    CGFloat total = 0;
//    for (id item in model.data) {
//        if ([item isKindOfClass:[ShopCart class]]) {
//            ShopCart *cart = item;
//            for (id item in cart.goodsList) {
//                if ([item isKindOfClass:[SCGoodsList class]]) {
//                    SCGoodsList *good = item;
//                    if (good.isSelected == YES) {
//                        total = total + (good.curPrice.floatValue * good.amount.floatValue);
//                    }
//                }
//            }
//        }
//    }
//    return [NSString stringWithFormat:@"%.2f",total];
//}
//

@end
