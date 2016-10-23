//
//  ArchiverHelper.m
//  QiCheng51
//
//  Created by Hancle on 16/7/12.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ArchiverHelper.h"
#import "User.h"

@implementation ArchiverHelper

+ (BOOL)archiverModelWith:(nonnull id)model key:(NSString *)modelKey {
    if (model) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:model forKey:modelKey];
        [archiver finishEncoding];
        [data writeToFile:[self getFilePathWith:modelKey] atomically:YES];
        if ([model isKindOfClass:[User class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UPDATE_USER_SUCCESS object:nil];
        }
        return YES;
        
    }else {
        return NO;
    }
}

+ (nullable id)unarchiverModelWith:(nonnull id)model key:(NSString *)modelKey {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathWith:modelKey]]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePathWith:modelKey]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        //解档出数据模型
        id model = [unarchiver decodeObjectForKey:modelKey];
        [unarchiver finishDecoding];  //一定不要忘记finishDecoding，否则会报错
        return model;

    }else {
        return nil;
    }
}

/**
 *  清理缓存
 */
+ (void)clearArchiverFileData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //找到缓存所存的路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)lastObject];
        //要清除的文件
        NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:path];//返回这个路径下的所有文件的数组
        for (NSString * p in files) {
            NSError * error = nil;
            NSString * cachPath = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cachPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:cachPath error:&error];//删除
            }
        }
    });
}

+ (NSString *)getFilePathWith:(NSString *)filename {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[array objectAtIndex:0] stringByAppendingPathComponent:filename];
}

@end
