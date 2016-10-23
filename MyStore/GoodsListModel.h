//
//  GoodsListModel.h
//  MyStore
//
//  Created by Hancle on 16/8/28.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface GoodsList : SuperModel

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *logoThumb;
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, strong) NSArray *thumbList;
@property (nonatomic, copy) NSString *curPrice;
@property (nonatomic, copy) NSString *prePrice;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopLogo;
@property (nonatomic, copy) NSString *shopThumb;
@property (nonatomic, strong) NSDictionary *tags;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, assign) NSInteger isCollect;  // 是否已收藏

@property (nonatomic, copy) NSString *tagsStr;

@end

@interface GoodsListModel : SuperModel

@property (nonatomic, strong) NSArray *data;
- (GoodsListModel *)addObjWith:(GoodsListModel *)model;

@end
