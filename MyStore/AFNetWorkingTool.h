//
//  AFNetWorkingTool.h
//  QiCheng51
//
//  Created by Hancle on 16/4/25.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

typedef void (^DownloadProgress) (int64_t bytesRead,
                                  int64_t totalBytesRead);
typedef void(^ResponseSuccess)(id responseObjects);
typedef void(^ResponseFail)(NSError *error);

@interface AFNetWorkingTool : NSObject

+ (NSURLSessionDataTask *)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

+ (NSURLSessionDataTask *)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

+ (NSURLSessionDataTask *)postFileWithUrl:(NSString *)urlStr parameters:(id)parameters files:(id)file progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

@end
