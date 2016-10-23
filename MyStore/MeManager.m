//
//  MeManager.m
//  MyStore
//
//  Created by Hancle on 16/9/8.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MeManager.h"

@implementation MeManager

+ (MeManager *)shareInstance {
    static MeManager *shareInstanec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstanec = [[MeManager alloc] init];
    });
    return shareInstanec;
}

@end
