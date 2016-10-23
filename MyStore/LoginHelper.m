//
//  LoginHelper.m
//  MyStore
//
//  Created by Hancle on 16/8/2.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "LoginHelper.h"
#import "NavSuperVC.h"
#import "LoginVC.h"

@implementation LoginHelper

+ (void)gotoLogin {
    LoginVC *loginVC = [LoginVC new];
    NavSuperVC *navVC = [[NavSuperVC alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
//    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([rootVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabbarVC = (UITabBarController *)rootVC;
//        LoginVC *loginVC = [LoginVC new];
//        NavSuperVC *navVC = [[NavSuperVC alloc] initWithRootViewController:loginVC];
//        if ([tabbarVC respondsToSelector:@selector(presentViewController:animated:completion:)]) {
//            [tabbarVC presentViewController:navVC animated:YES completion:nil];
//        }
//    }
}

@end
