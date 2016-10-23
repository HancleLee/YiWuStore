//
//  AppDelegate.m
//  MyStore
//
//  Created by Hancle on 16/7/6.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarVC.h"
#import "LoginVC.h"
#import "NavSuperVC.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApiManager.h"
#import "UMSocialSinaSSOHandler.h"
#import <UMMobClick/MobClick.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMessage_Sdk_1.3.0/UMessage.h"
#import <WeiboSDK.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate () 

@property (nonatomic, strong) LoginVC *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configureMainVC];
    [self setupNavigationBarAppearance];
    [self setupWeixin];
    [self setupUmengWith:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 保存进入后台时间
    [CommonFunction saveEnterBackTime];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 友盟分享
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == YES) {
        return result;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    BOOL tencentResult = [TencentOAuth HandleOpenURL:url];
    if (tencentResult) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 友盟分享
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == YES) {
        return result;
    }

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    BOOL tencentResult = [TencentOAuth HandleOpenURL:url];
    if (tencentResult) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    // 友盟分享
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == YES) {
        return result;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    BOOL tencentResult = [TencentOAuth HandleOpenURL:url];
    if (tencentResult) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma mark - private
/**
 *  设置主控制器
 */
- (void)configureMainVC {
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    self.loginVC = [LoginVC new];
    NavSuperVC *navVC = [[NavSuperVC alloc] initWithRootViewController:self.loginVC];
    self.window.rootViewController = navVC;
}

/**
 *  设置导航栏样式
 */
- (void)setupNavigationBarAppearance {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    NSFontAttributeName: [UIFont systemFontOfSize:20]
    [[UINavigationBar appearance] setBackgroundImage: [[UIImage imageNamed:@"nav_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)] forBarMetrics:UIBarMetricsDefault];
        UINavigationBar.appearance.tintColor = [UIColor whiteColor];
        UINavigationBar.appearance.shadowImage = [UIImage new];
}

/**
 *  设置微信
 */
- (void)setupWeixin {
    [WXApi registerApp:WXAppID];    // 向微信注册
}

/**
 *  设置友盟
 */
- (void)setupUmengWith:(NSDictionary *)launchOptions {
    // 分享
    UMConfigInstance.appKey = UMAppKey;
    UMConfigInstance.channelId = @"App Store";
    //    UMConfigInstance.eSType = E_UM_NORMAL;   // 仅适用于游戏场景
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:[CommonFunction getVersion]];
    
    [UMSocialData setAppKey:UMAppKey];
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:ShareUrl];
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:ShareUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WBAppID secret:WBAppSecret RedirectURL:ShareUrl];
    
    // 推送
    [UMessage startWithAppkey:UMAppKey launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    [UMessage setAutoAlert:NO];
    
    //for log
    //    [UMessage setLogEnabled:YES];
}

@end
