//
//  ShopCartModel.h
//  MyStore
//
//  Created by Hancle on 16/9/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface SCGoodsList : SuperModel <NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSDictionary *tags;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsLogo;
@property (nonatomic, copy) NSString *goodsLogoThumb;
@property (nonatomic, copy) NSString *curPrice;
@property (nonatomic, copy) NSString *prePrice;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *tagsStr;

@end

@interface ShopCart : SuperModel <NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopImage;
@property (nonatomic, copy) NSString *shopThumb;
@property (nonatomic, copy) NSArray *goodsList;

@property (nonatomic, assign) BOOL isSelected;

@end

@interface ShopCartModel : SuperModel <NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSArray *data;
@property (nonatomic, assign) BOOL isSelected;

@end
