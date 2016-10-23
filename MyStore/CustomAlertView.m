//
//  CustomAlertView.m
//  MyStore
//
//  Created by Hancle on 16/9/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

+ (CustomAlertView *)customViewWith:(CGRect)frame title:(NSString *)title {
    CustomAlertView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    view.frame = frame;
    view.backgroundColor = RGBColor_a(0, 0, 0, 0.4);
    
    view.mainView.layer.cornerRadius = 5.0f;
    view.titleLabel.text = title;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(tap:)];
    [view addGestureRecognizer:gesture];
    
    return view;
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

- (void)dismiss {
    if ([self respondsToSelector:@selector(removeFromSuperview)]) {
        [self removeFromSuperview];
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    self.buttonBlock(NO);
    [self dismiss];
}

- (IBAction)cancelBtnClick:(id)sender {
    self.buttonBlock(YES);
    [self dismiss];
}

@end
