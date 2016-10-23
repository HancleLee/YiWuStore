//
//  QQApiManager.m
//  QiCheng51
//
//  Created by Hancle on 16/5/5.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "QQApiManager.h"

@implementation QQApiManager

//+ (instancetype)sharedManager {
//    static dispatch_once_t onceToken;
//    static QQApiManager *instance;
//    dispatch_once(&onceToken, ^{
//        instance = [[QQApiManager alloc] init];
//    });
//    return instance;
//}
//
//- (void)dealloc {
//    self.delegate = nil;
//}


- (void)qqLogin {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
            [_tencentOAuth authorize:permissions inSafari:YES];
        });
    });
}

// 登录成功后的回调
- (void)tencentDidLogin {
    if ([self.delegate respondsToSelector:@selector(managerDidLoginWith:)]) {
        [self.delegate managerDidLoginWith:_tencentOAuth];
    }
}

// 登录失败后的回调
- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSString *title = @"登录失败";
    if (cancelled) {
        title = @"用户取消登录";
    }
    if ([self.delegate respondsToSelector:@selector(managerDidFailLogin:)]) {
        [self.delegate managerDidFailLogin:title];
    }
}

// 登录时网络有问题的回调
- (void)tencentDidNotNetWork {
    if ([self.delegate respondsToSelector:@selector(managerDidFailLogin:)]) {
        [self.delegate managerDidFailLogin:@"网络异常，请重试"];
    }
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == 0) {
        NSMutableDictionary *parasDic = [NSMutableDictionary dictionary];
        NSString *openId = [_tencentOAuth openId];
        NSString *nickname = response.jsonResponse[@"nickname"];
        NSString *avatar = response.jsonResponse[@"figureurl_2"];
        if (!avatar) {
            avatar = response.jsonResponse[@"figureurl"];
        }
        NSArray *keys = @[@"uid", @"nickname", @"avatar"];
        NSArray *values = @[openId, nickname, avatar];
        for (int i = 0; i < values.count; i ++) {
            NSString *key = keys[i];
            NSString *value = values[i];
            if (![value isEqualToString:@""] && nil != value) {
                [parasDic setObject:value forKey:key];
            }
        }
        if ([self.delegate respondsToSelector:@selector(managerDidGetQQUserData:)]) {
            [self.delegate managerDidGetQQUserData:parasDic];
        }
    }
}

@end
