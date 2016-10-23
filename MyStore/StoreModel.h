//
//  StoreModel.h
//  MyStore
//
//  Created by Hancle on 16/9/12.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface Store : SuperModel

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *logoThumb;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *createTime;

@end

@interface StoreModel : SuperModel

@property (nonatomic, strong) Store *data;

@end
