//
//  CollectionModel.h
//  MyStore
//
//  Created by Hancle on 16/9/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"
#import "GoodsListModel.h"

@interface CollectionModel : SuperModel

@property (nonatomic, strong) NSArray *data;

- (CollectionModel *)addObjWith:(CollectionModel *)model;

@end
