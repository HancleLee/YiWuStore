//
//  CustomShareView.h
//  QiCheng51
//
//  Created by Hancle on 16/6/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"

@interface CustomShareView : SuperView

//+(instancetype)shareViewWithPresentedViewController:(UIViewController *)controller items:(NSArray *)items title:(NSString *)title image:(UIImage *)image urlResource:(NSString *)url;

+ (instancetype)customShareViewWithPresentedViewController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(UIImage *)image urlResource:(NSString *)url;

@end
