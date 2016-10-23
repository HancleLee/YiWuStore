//
//  SuperDataModel.m
//  MyStore
//
//  Created by Hancle on 16/8/28.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperDataModel.h"

@implementation SuperDataModel

- (id)initWithJson:(id)json {
    self = [super init];
    if (self) {
        if (nil != json) {
            [self yy_modelSetWithJSON:json];
        }
    }
    return self;
}

@end
