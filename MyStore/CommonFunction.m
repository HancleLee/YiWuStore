//
//  CommonFunction.m
//
//
//  Created by hubin on 15/1/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CommonFunction.h"
#import <CommonCrypto/CommonDigest.h>
#import "User.h"

#define kEnterBackTime @"UHEnterBackTime"
#define kUpdateCacheTime 48     // 更新缓存的时间

@implementation CommonFunction

#pragma mark - 常用方法

/// 获取当前语言
+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

/// 显示简单弹窗
+ (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

/// 返回应用当前语言是否为中文
+ (BOOL)isChinese
{
    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return [language isEqualToString:@"zh-Hans"] ? YES : NO;
}

/// 获取当前版本
+ (NSString *)getVersion
{
    NSString * Version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    return Version;
}


+ (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


#pragma mark - 手机号 邮箱 车牌号 身份证 验证方法

/// 邮箱验证 MODIFIED BY HELENSONG
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/// 手机号码验证 MODIFIED BY HELENSONG
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    if ([mobile isEqualToString:@""]) {
        return NO;
    }
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobile];
}

/// 手机号码验证
+ (BOOL)isValidateMobileNum:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = (int)strlen(cvalue);
    if (len != 11)
        return FALSE;
    if (![self isValidNumber:value])
        return FALSE;
         
    NSString *s0 = [[NSString stringWithFormat:@"%@",value] substringToIndex:2];
    if ([s0 isEqualToString:@"13"] || [s0 isEqualToString: @"15"] || [s0 isEqualToString: @"17"] || [s0 isEqualToString: @"18"]  || [s0 isEqualToString:@"14"])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
+ (BOOL) isValidNumber:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = (int)strlen(cvalue);
    for (int i = 0; i < len; i++)
    {
        if(!isNumber(cvalue[i]))
            return FALSE;
    }
    return TRUE;
}
BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9'))
    {
        return FALSE;
    }
    return TRUE;
}

/// 车牌号验证 MODIFIED BY HELENSONG
+ (BOOL) isValidateCarNumber:(NSString *)carNumber
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNumber];
}

/// 身份证验证 MODIFIED BY HELENSONG
+ (BOOL)isValidateCardID:(NSString *)strID {
    NSString *cardCheck = @"^[0-9]{17}[0-9|xX]{1}$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",cardCheck];
    return [cardTest evaluateWithObject:strID];
}

+ (BOOL)isValidatePassWord:(NSString *)password {
    NSString *passwordCheck = @"@^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,18}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",passwordCheck];
    return [passwordTest evaluateWithObject:password];
}


#pragma mark - // 其它
/// 动态获取文字所占长宽
+ (CGSize)getSizeForText:(NSString *)text font:(UIFont *)font withConstrainedSize:(CGSize)size
{
    CGSize newsize;
#ifdef __IPHONE_7_0
    NSDictionary *attribute = @{NSFontAttributeName: font};
    newsize = [text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
#else
    newsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return newsize;
}

// 设置状态栏文字的样式（要在plist文件中禁用viewController对状态栏的操作）
/// 隐藏电池栏
+ (void)setStatusBarHidden:(BOOL)isHide
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHide];
}

/// 设置电池状态栏为默认样式 黑字
+ (void)setStatusBarStyleDefault
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

/// 设置电池状态栏为高亮样式 白字
+ (void)setStatusBarStyleLightContent
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

/// 手动打开或关闭闪光灯   要导入：#import <AVFoundation/AVFoundation.h>
//+ (void)turnTorchOn:(BOOL)on
//{
//    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
//    if (captureDeviceClass != nil) {
//        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        if ([device hasTorch] && [device hasFlash])
//        {
//            [device lockForConfiguration:nil];
//            if (on)
//            {
//                [device setTorchMode:AVCaptureTorchModeOn];
//                [device setFlashMode:AVCaptureFlashModeOn];
//            }
//            else
//            {
//                [device setTorchMode:AVCaptureTorchModeOff];
//                [device setFlashMode:AVCaptureFlashModeOff];
//            }
//            [device unlockForConfiguration];
//        }
//    }
//}

+ (void)phoneCallWith:(NSString *)number {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", number]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        
    } else {
        [CommonFunction showHUDIn:[CommonFunction topViewController] text:@"暂时无法拨打电话"];
    }
}

#pragma mark 时间戳转时间
+ (NSString *)transformTimeStamp:(double)timeStamp andForm:(NSString *)form {
    timeStamp = timeStamp / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timeStamp];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    //yyyyMMdd  //yyyyMMdd HHmmss
    [inputFormatter setDateFormat:form];
    
    return [inputFormatter stringFromDate:date];
}

/// 获取系统当前时间戳,毫秒级
+ (NSString *)getCurrentTimeStamp {
    double timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *time = [NSString stringWithFormat:@"%f", timestamp];
    NSArray *timeArr = [time componentsSeparatedByString:@"."];
    return [timeArr firstObject];
}

+ (NSString *)getRandomString {
    char data[10];
    for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding];
}


// 自动登录签名
+ (NSString *)getSignWith:(NSArray *)array {
    NSString *sign = @"";
    
    NSArray *sortedKeys = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        return [str1 compare:str2];
    }];
    
    for (NSString *key in sortedKeys) {
        sign = [sign stringByAppendingString:key];
    }
    
    return [self md5HexDigest:sign];
}


#pragma mark - 加密
/// md5 32位
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (unsigned int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

/// sha256加密方式
+ (NSString *)getSha256Data:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    // 类型强转
    CC_LONG  length = (CC_LONG)data.length;
    CC_SHA1(data.bytes, length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

#pragma mark - HUD
+ (void)showHUDIn:(UIViewController *)vc {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSArray *huds = [MBProgressHUD allHUDsForView:vc.view];
    if (huds.count < 1) {
        [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    }
}

+ (void)hideAllHUDIn:(UIViewController *)vc {
    for (UIView *view in [vc.view subviews]) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableview = (UITableView *)view;
            if ([tableview.mj_header isRefreshing]) {
                [tableview.mj_header endRefreshing];
            }
        }
    }
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
    });
}

+ (void)showHUDIn:(UIViewController *)vc text:(NSString *)hudText hideTime:(NSTimeInterval)time  completion:(void(^)())completion {
    
    for (UIView *view in [vc.view subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollview = (UIScrollView *)view;
            if ([scrollview.mj_header isRefreshing]) {
                [scrollview.mj_header endRefreshing];
            }
            if ([scrollview.mj_footer isRefreshing]) {
                [scrollview.mj_footer endRefreshing];
            }
        }
    }
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:vc.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = hudText;
        [vc.view addSubview:HUD];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(time);
        } completionBlock:^{
            if (completion) {
                completion();
            }
            [HUD removeFromSuperview];
        }];
    });
}



+ (void)showHUDIn:(UIViewController *)vc text:(NSString *)hudText {
    
    for (UIView *view in [vc.view subviews]) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableview = (UITableView *)view;
            if ([tableview.mj_header isRefreshing]) {
                [tableview.mj_header endRefreshing];
            }
        }
    }
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:vc.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = hudText;
        [vc.view addSubview:HUD];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    });
}

+ (void)showSuccessHUDIn:(UIViewController *)vc {
    for (UIView *view in [vc.view subviews]) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableview = (UITableView *)view;
            if ([tableview.mj_header isRefreshing]) {
                [tableview.mj_header endRefreshing];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:vc.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = RequestSuccessTip;
        [vc.view addSubview:HUD];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
            if ([vc.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
                [vc.navigationController popViewControllerAnimated:YES];
            }
        }];
    });
}

#pragma mark - 获取设备的UUID
+ (NSString *) getUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *) CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - 其他
+ (NSString *)getUserToken {
    id item = [ArchiverHelper unarchiverModelWith:[User new] key:ARCH_USER];
    if ([item isKindOfClass:[User class]]) {
        User *user = item;
        return user.token;
    }
    return @"";
}

// 转换成json string
+ (NSString *)transferToJsonStringWith:(id)obj {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!error) {
        return jsonString;
    }
    return nil;
}



// enter back time
+ (void)saveEnterBackTime {
    NSString *currentTime = [CommonFunction getCurrentTimeStamp];
    if (nil != currentTime || ![currentTime isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:kEnterBackTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getEnterBackTime {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kEnterBackTime];
}

+ (BOOL)shouldUpdateCache {
    NSString *currentTime = [CommonFunction getCurrentTimeStamp];
    NSString *enterBackTime = [self getEnterBackTime];
    if (nil == enterBackTime || [enterBackTime isEqualToString:@""]) {
        return YES;
    }
    
    int time1 = [[CommonFunction transformTimeStamp:[currentTime doubleValue] andForm:@"yyyyMMdd"] intValue];
    int time2 = [[CommonFunction transformTimeStamp:[enterBackTime doubleValue] andForm:@"yyyyMMdd"] intValue];
    int hour1 = [[CommonFunction transformTimeStamp:[currentTime doubleValue] andForm:@"HH"] intValue];
    int hour2 = [[CommonFunction transformTimeStamp:[enterBackTime doubleValue] andForm:@"HH"] intValue];
    
    if (time1 - time2 > 2) {    // 大于2天
        return YES;
        
    }else if (time1 - time2 == 1) { // 相差一天
        if ((hour1 + 24) - hour2 >= kUpdateCacheTime) {
            return YES;
            
        }else {
            return NO;
        }
        
    }else { // 相差不到一天
        return NO;
    }
}

+ (void)hk_setImage:(NSString *)img imgview:(UIImageView *)imgview {
    if (Is_Url(img)) {
        [imgview sd_setImageWithURL:URLWithString(img) placeholderImage:DEFAULT_PIC];
    }else {
        [imgview sd_setImageWithURL:URL_PIC(img) placeholderImage:DEFAULT_PIC];
    }
}

@end
