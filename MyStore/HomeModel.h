//
//  HomeModel.h
//  MyStore
//
//  Created by Hancle on 16/8/9.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"
#import "GoodsListModel.h"
#import "StoreModel.h"
#import "SortListModel.h"

@interface Banner : SuperModel

@property (nonatomic, copy) NSString *sortId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *logoThumb;
@property (nonatomic, copy) NSString *title;

@end

@interface HomeData : SuperModel

@property (nonatomic, strong) NSArray *banner;
@property (nonatomic, strong) NSArray *promotion;
@property (nonatomic, strong) NSArray *shop;
@property (nonatomic, strong) NSArray *tags;

@end

@interface HomeModel : SuperModel

@property (nonatomic, strong) HomeData *data;

@end
