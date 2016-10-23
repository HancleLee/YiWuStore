//
//  AFNetWorkingTool.m
//  QiCheng51
//
//  Created by Hancle on 16/4/25.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "AFNetWorkingTool.h"

@implementation AFNetWorkingTool

+ (NSURLSessionDataTask *)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail {
    return [self requestWithUrl:urlStr refreshCache:YES httpMethod:2 params:parameters progress:progress success:success fail:fail];
}

+ (NSURLSessionDataTask *)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail {
    return [self requestWithUrl:urlStr refreshCache:YES httpMethod:1 params:parameters progress:progress success:success fail:fail];
};

+ (NSURLSessionDataTask *)requestWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache httpMethod:(NSInteger)httpMethod params:(id)params progress:(DownloadProgress)progress success:(ResponseSuccess)success fail:(ResponseFail)fail {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IP_ADDRESS, url];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    id paras = params;
//    if ([params isKindOfClass:[NSDictionary class]]) {
//        if (params) {
//            paras = [NSMutableDictionary dictionaryWithDictionary:params];
//        }else {
//            paras = [[NSMutableDictionary alloc] init];
//        }
//        if (![TOKEN isEqualToString:@""] && TOKEN != nil) {
//            [paras setObject:TOKEN forKey:@"token"];
//        }
//        
//    }
    if (!params) {
        paras = [[NSMutableDictionary alloc] init];
        if (![TOKEN isEqualToString:@""] && TOKEN != nil) {
            [paras setObject:TOKEN forKey:@"token"];
        }
        
    }else {
        if ([params isKindOfClass:[NSDictionary class]]) {
            paras = [NSMutableDictionary dictionaryWithDictionary:params];
            if (![TOKEN isEqualToString:@""] && TOKEN != nil) {
                [paras setObject:TOKEN forKey:@"token"];
            }
        }else {
            /**
             *  将params转化成json格式
             */
            AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
            [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            manager.requestSerializer = serializer;
        }
    }
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSSet *set = manager.responseSerializer.acceptableContentTypes;
    manager.responseSerializer.acceptableContentTypes = [set setByAddingObject:@"text/html"];
    
    NSMutableSet *acceptableSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [acceptableSet addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = acceptableSet;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *session = nil;
    if (1 == httpMethod) {
        session = [manager GET:urlStr parameters:paras progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }else {
                if (error.code != -999) { // code = -999为取消请求
                    [CommonFunction showHUDIn:[CommonFunction topViewController] text:RequestFailTipText hideTime:2 completion:nil];
                }else {
                    NSLog(@"erro：用户取消请求");
                }
            }
            NSLog(@"AFN-url--%@ error-- %@", urlStr,error);
        }];
        
    }else if (2 == httpMethod) {
        session = [manager POST:urlStr parameters:paras progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }else {
                if (error.code != -999) { // code = -999为取消请求
                    [CommonFunction showHUDIn:[CommonFunction topViewController] text:RequestFailTipText hideTime:2 completion:nil];
                }else {
                    NSLog(@"erro：用户取消请求");
                }
            }
            NSLog(@"AFN-url--%@ error-- %@", urlStr,error);
        }];
    }
    
    return session;
}

+ (NSURLSessionDataTask *)postFileWithUrl:(NSString *)urlStr parameters:(id)parameters files:(id)file progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail {
    NSString *url = [NSString stringWithFormat:@"%@%@",IP_ADDRESS, urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  将params转化成json格式
     */
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSURLSessionDataTask *session = nil;
    session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if ([file isKindOfClass:[UIImage class]]) {
            NSData *data = UIImageJPEGRepresentation(file, 0.9);
            // 图片大于200k时进行压缩处理
            CGFloat quality = 0.8;
            for ( int i = 0; i < 12; i ++) {
                if (data.length / 1024 > 200) { // 压缩至小于200KB
                    data = UIImageJPEGRepresentation(file, quality - i * 0.05);
                }else {
                    break;
                }
            }
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"imageList"] fileName:@"imageList.jpg" mimeType:@"image/jpeg"];
            
        }else if ([file isKindOfClass:[NSData class]]) {
            [formData appendPartWithFileData:file name:[NSString stringWithFormat:@"imageList"] fileName:@"imageList.jpg" mimeType:@"image/jpeg"];
            
        }else if([file isKindOfClass:[NSArray class]]) {
            NSArray *dataArr = file;
            int i = 0;
            for (id item in dataArr) {
                i ++;
                if ([item isKindOfClass:[UIImage class]]) {
                    NSData *data = UIImageJPEGRepresentation(item, 0.9);
                    // 图片大于200k时进行压缩处理
                    CGFloat quality = 0.8;
                    for ( int i = 0; i < 12; i ++) {
                        if (data.length / 1024 > 200) { // 压缩至小于200KB
                            data = UIImageJPEGRepresentation(item, quality - i * 0.05);
                        }else {
                            break;
                        }
                    }
                    [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"imageList"] fileName:[NSString stringWithFormat:@"imageList%d.jpg",i] mimeType:@"image/jpeg"];
                }
            }
        }else if([file isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tdic = file;
            for (NSString *key in tdic.allKeys) {
                id item = tdic[key];
                if ([item isKindOfClass:[UIImage class]]) {
                    NSData *data = UIImageJPEGRepresentation(item, 0.9);
                    // 图片大于200k时进行压缩处理
                    CGFloat quality = 0.8;
                    for ( int i = 0; i < 12; i ++) {
                        if (data.length / 1024 > 200) { // 压缩至小于200KB
                            data = UIImageJPEGRepresentation(item, quality - i * 0.05);
                        }else {
                            break;
                        }
                    }
                    [formData appendPartWithFileData:data name:key fileName:@"imageList.jpg" mimeType:@"image/jpeg"];
                }
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ret"] intValue] == 0) {
            success(responseObject);
        }
        NSLog(@"AFN--%@", responseObject[@"msg"]);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        NSLog(@"AFN-error-- %@",error);

    }];

    return session;
}

@end
