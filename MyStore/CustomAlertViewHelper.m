//
//  CustomAlertViewHelper.m
//  MyStore
//
//  Created by Hancle on 16/9/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CustomAlertViewHelper.h"

@implementation CustomAlertViewHelper

+ (CustomAlertView *)show:(NSString *)title {
    CustomAlertView *alertView = [CustomAlertView customViewWith:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:title];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC && ![rootVC.view.subviews containsObject:alertView]) {
        [rootVC.view addSubview:alertView];
    }
    return alertView;
}

@end
