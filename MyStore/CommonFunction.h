//
//  CommonFunction.h
//
//
//  Created by hubin on 15/1/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CommonDefine.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
//#import "MBProgressHUD.h"

@interface  CommonFunction: NSObject

#pragma mark - 常用方法

/// 获取当前语言
+ (NSString *)getCurrentLanguage;

/// 显示简单弹窗
+ (void)showAlertViewWithMessage:(NSString *)message;

/// 返回应用当前语言是否为中文
+ (BOOL)isChinese;

/// 获取当前版本
+ (NSString *)getVersion;
/// 获取UUID
+ (NSString *) getUUID;
/// 获取当前屏幕上的viewcontroller
+ (UIViewController*)topViewController;

#pragma mark - 手机号 邮箱 验证方法

/// 邮箱验证 MODIFIED BY HELENSONG
+ (BOOL)isValidateEmail:(NSString *)email;

/// 手机号码验证 MODIFIED BY HELENSONG
+ (BOOL)isValidateMobile:(NSString *)mobile;

/// 手机号码验证
+ (BOOL)isValidateMobileNum:(NSString*)value;

/// 车牌号验证 MODIFIED BY HELENSONG
+ (BOOL)isValidateCarNumber:(NSString *)carNumber;

/// 身份证验证 MODIFIED BY HELENSONG
+ (BOOL)isValidateCardID:(NSString *)strID;

/// 密码验证
+ (BOOL)isValidatePassWord:(NSString *)password;


#pragma mark - 其它

/// 动态获取文字所占长宽
+ (CGSize)getSizeForText:(NSString *)text font:(UIFont *)font withConstrainedSize:(CGSize)size;

/// 自动登录签名
+ (NSString *)getSignWith:(NSArray *)array;

/// 隐藏电池栏
+ (void)setStatusBarHidden:(BOOL)isHide;

/// 设置电池状态栏为默认样式 黑字
+ (void)setStatusBarStyleDefault;

/// 设置电池状态栏为高亮样式 白字
+ (void)setStatusBarStyleLightContent;

/// 手动打开或关闭闪光灯
//+ (void)turnTorchOn:(BOOL)on;

/// 拨打电话
+ (void)phoneCallWith:(NSString *)number;

#pragma mark - 时间
/// 时间戳转时间
+ (NSString *)transformTimeStamp:(double)timeStamp andForm:(NSString *)form;
/// 获取当前时间戳
+ (NSString *)getCurrentTimeStamp;
/// 获取随机字符串
+ (NSString *)getRandomString;

#pragma mark - md5
+ (NSString *)md5HexDigest:(NSString*)input;
+ (NSString *)getSha256Data:(NSData *)data;

#pragma mark - HUD
+ (void)showHUDIn:(UIViewController *)vc;
+ (void)hideAllHUDIn:(UIViewController *)vc;
+ (void)showHUDIn:(UIViewController *)vc text:(NSString *)hudText hideTime:(NSTimeInterval)time  completion:(void(^)())completion;
+ (void)showHUDIn:(UIViewController *)vc text:(NSString *)hudText;
+ (void)showSuccessHUDIn:(UIViewController *)vc;

#pragma mark - 其他
+ (NSString *)getUserToken;
// 将对象（字典\数组）转换成json string
+ (NSString *)transferToJsonStringWith:(id)obj;

+ (void)saveEnterBackTime;
+ (NSString *)getEnterBackTime;
+ (BOOL)shouldUpdateCache;

+ (void)hk_setImage:(NSString *)img imgview:(UIImageView *)imgview;

@end
