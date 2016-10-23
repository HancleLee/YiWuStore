//
//  GlobalRequestHelper.m
//  MyStore
//
//  Created by Hancle on 16/9/20.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GlobalRequestHelper.h"

@implementation GlobalRequestHelper

+ (void)getGlobalData {
    if ([CommonFunction shouldUpdateCache]) {
        [self requestForGetSortList];
    }
}

+ (void)requestForGetSortList {
    
}

@end
