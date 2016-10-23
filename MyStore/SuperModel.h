//
//  SuperModel.h
//  MyStore
//
//  Created by Hancle on 16/7/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface SuperModel : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;

- (id)initWithJson:(id)json;

@end
