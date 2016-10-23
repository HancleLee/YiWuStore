//
//  SuperVC.m
//  QiCheng51
//
//  Created by Hancle on 16/4/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperVC.h"

@interface SuperVC ()

@end

@implementation SuperVC
#pragma mark - setter/getter
- (void)setRightItemBtnTitle:(NSString *)rightItemBtnTitle {
    _rightItemBtnTitle = rightItemBtnTitle;
    if (nil != rightItemBtnTitle && ![rightItemBtnTitle isEqualToString:@""]) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 35, 20);
        rightButton.titleLabel.font = FontSize(15);
        [rightButton setTitle:rightItemBtnTitle forState:UIControlStateNormal];
        [rightButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MainBackColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : WhiteColor}];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIImage *backImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, 10, 30);
        [backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;   //启用侧滑手势
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s %@",__func__,NSStringFromClass([self class]));
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - private
// 返回按钮
- (void)backBtnClick:(UIButton *)sender {
    if (self.view) {
        [self.view endEditing:YES];
    }
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//// 弹出HUD
//- (void)showHUD {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//}
//
//// 隐藏所有HUD
//- (void)hideHUD {
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    });
//}
//
//// 显示文本提提示框
//- (void)showHUDWith:(NSString *)hudText hideTime:(NSTimeInterval)time inView:(UIView *)view completion:(void(^)())completion {
//    [MBProgressHUD hideAllHUDsForView:view animated:YES];
//    
//    HUD = [[MBProgressHUD alloc] initWithView:view];
//    HUD.mode = MBProgressHUDModeText;
//    HUD.labelText = hudText;
//    [view addSubview:HUD];
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(time);
//    } completionBlock:^{
//        if (completion) {
//            completion();
//        }
//        [HUD removeFromSuperview];
//        HUD = nil;
//    }];
//}

/// push下一视图
- (void)pushViewController:(UIViewController *)vc {
    vc.hidesBottomBarWhenPushed = YES;
    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)]) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// push下一视图
- (void)pushViewControllerNoAnimation:(UIViewController *)vc {
    vc.hidesBottomBarWhenPushed = YES;
    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)]) {
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)popviewControllerWith:(BOOL)isAnimation {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:isAnimation];
    }
}

// 子类重写此方法
- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem {
    
}

#pragma mark - KeyBoardCustomViewDelegate
// 子类重写此方法
- (void)sendButtonClick:(UITextView *)textView {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
