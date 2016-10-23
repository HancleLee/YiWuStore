//
//  ArchiverHelper.h
//  QiCheng51
//
//  Created by Hancle on 16/7/12.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiverHelper : NSObject

+ (BOOL)archiverModelWith:(nonnull id)model key:(nonnull NSString *)modelKey;
+ (nullable id)unarchiverModelWith:(nonnull id)model key:(nonnull NSString *)modelKey;
+ (void)clearArchiverFileData;

@end
