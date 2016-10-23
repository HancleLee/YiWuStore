//
//  RequestHelper.m
//  MyStore
//
//  Created by Hancle on 16/7/27.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "RequestHelper.h"

@implementation RequestHelper

//+ (NSURLSessionTask *)requestForRegisterWith:(NSDictionary *)paraDic {

//    NSURLSessionTask *task = [AFNetWorkingTool postJSONWithUrl:[self getUrlStringWith:IPUserRegister] parameters:paraDic progress:<#^(int64_t bytesRead, int64_t totalBytesRead)progress#> success:<#^(id responseObject)success#> fail:<#^(NSError *error)fail#>]
//}

+ (NSString *)getUrlStringWith:(NSString *)url {
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",IP_ADDRESS, url];
    return urlstr;
}

@end
