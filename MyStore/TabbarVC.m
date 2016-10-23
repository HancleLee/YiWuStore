//
//  TabbarVC.m
//  QiCheng51
//
//  Created by Hancle on 16/4/21.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "TabbarVC.h"
#import "NavSuperVC.h"
#import "HomeVC.h"
#import "SocialVC.h"
#import "ShoppingCartVC.h"
#import "MeVC.h"

@interface TabbarVC ()

@end

@implementation TabbarVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    HomeVC *vc0 = [[HomeVC alloc] init];
    SocialVC *vc1 = [[SocialVC alloc] init];
    ShoppingCartVC *vc2 = [[ShoppingCartVC alloc] init];
    MeVC *vc3 = [[MeVC alloc] init];
    
    NavSuperVC *nav0 = [[NavSuperVC alloc] initWithRootViewController:vc0];
    NavSuperVC *nav1 = [[NavSuperVC alloc] initWithRootViewController:vc1];
    NavSuperVC *nav2 = [[NavSuperVC alloc] initWithRootViewController:vc2];
    NavSuperVC *nav3 = [[NavSuperVC alloc] initWithRootViewController:vc3];
    
    self.viewControllers = @[nav0, nav1, nav2, nav3];
    
    /// 设置标签栏
    [self setTabBarItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
/// 自定义标签栏
- (void)setTabBarItems {
    UITabBar *tabbar = self.tabBar;
    tabbar.backgroundColor = WhiteColor;
//    tabbar.shadowImage = [UIImage new];
//    tabbar.backgroundImage = [[UIImage imageNamed:@"nav_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    
    NSArray *titleArray = @[NSLocalizedString(@"首页", nil),
                            NSLocalizedString(@"社区", nil),
                            NSLocalizedString(@"购物车", nil),
                            NSLocalizedString(@"我的", nil)];
    NSArray *imageArr0  = @[@"tabbar00", @"tabbar10", @"tabbar20", @"tabbar30"];
    NSArray *imageArr1  = @[@"tabbar01", @"tabbar11", @"tabbar21", @"tabbar31"];

    UIColor *color0 = RGBColor(145, 145, 145);
    UIColor *color1 = RGBColor(237, 57, 74);
    
    for(int i = 0; i < self.viewControllers.count; i++)
    {
        UINavigationController *one = (UINavigationController *)[self.viewControllers objectAtIndex:i];
        //        one.navigationBar.hidden = YES;
        
        /// 以下设置标签栏图片及文字
        UIImage *image         = ImageNamed([imageArr0 objectAtIndex:i]); // 未选中 时图片
        UIImage *selectedImage = ImageNamed([imageArr1 objectAtIndex:i]); //  选中 时图片
        
        /// 声明这张图片用原图(别渲染)
        image         = [image         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        /// 标签栏按钮
        one.tabBarItem = [[UITabBarItem alloc]initWithTitle:[titleArray objectAtIndex:i] image:image selectedImage:selectedImage];
        
        /// 设置常态下文字的颜色
        [one.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:color0 forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        
        /// 设置选中时文字的颜色
        [one.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:color1 forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
        
        /// 设置Tag值 以便在点击标签栏时的特殊处理
        one.tabBarItem.tag = i;
    }
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
