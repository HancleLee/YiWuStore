//
//  SuperVC.h
//  QiCheng51
//
//  Created by Hancle on 16/4/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperVC : UIViewController

// 返回按钮，字类可重写
- (void)backBtnClick:(UIButton *)sender;
/**
 *  HUD
 */
//- (void)showHUD;
//- (void)hideHUD;
//- (void)showHUDWith:(NSString *)hudText hideTime:(NSTimeInterval)time inView:(UIView *)view completion:(void(^)())completion;

// push到下一页面
- (void)pushViewController:(UIViewController *)vc;
- (void)pushViewControllerNoAnimation:(UIViewController *)vc;

- (void)popviewControllerWith:(BOOL)isAnimation;

// 导航栏右键按钮标题，子类需重写rightItemBtnClick方法
@property (nonatomic, copy) NSString *rightItemBtnTitle;

// 点击导航栏右键按钮,子类重写
- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem;

@end
