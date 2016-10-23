//
//  WXApiManager.h
//  QiCheng51
//
//  Created by Hancle on 16/4/28.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;
// 获取用户资料成功后回调处理
- (void)managerDidRecvGetUserData:(NSDictionary *)datas;

// 支付成功回调处理
- (void)managerDidPaySuccess:(PayReq *)payReq;

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, weak) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
// 调起微信客户端
-(void)sendWechatAuthRequestWith:(NSString *)WXState ;

@end
