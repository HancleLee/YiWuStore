//
//  SuperDataModel.h
//  MyStore
//
//  Created by Hancle on 16/8/28.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"
#import <YYModel.h>

@interface SuperDataModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;

- (id)initWithJson:(id)json;

@end
