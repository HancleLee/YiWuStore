//
//  ShopListModel.h
//  MyStore
//
//  Created by Hancle on 16/9/3.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface ShopList : SuperModel

@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *createTime;

@end

@interface ShopListModel : SuperModel

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger count;
- (ShopListModel *)addObjWith:(ShopListModel *)model;

@end
