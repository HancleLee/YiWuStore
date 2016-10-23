//
//  QQApiManager.h
//  QiCheng51
//
//  Created by Hancle on 16/5/5.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@protocol QQApiManagerDelegate <NSObject>

@optional

- (void)managerDidGetQQUserData:(NSDictionary *)datas;
- (void)managerDidFailLogin:(NSString *)title;
- (void)managerDidLoginWith:(TencentOAuth *)tencentOAuth;

@end

@interface QQApiManager : NSObject <TencentSessionDelegate>

@property (nonatomic,weak) id<QQApiManagerDelegate> delegate;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
- (void)qqLogin;

@end
