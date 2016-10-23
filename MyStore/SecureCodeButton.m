//
//  SecureCodeButton.m
//  QiCheng51
//
//  Created by Hancle on 16/4/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SecureCodeButton.h"

#define kBackViewBorderWith 1.0f
#define kCornusRadius 5.0

@interface SecureCodeButton()
{
    UIColor *unselectedBackColor;
    UIColor *selectedBackColor;
    UIButton *sendCodeButton;
    UIView *backView;
    NSTimer *timer;
    int time;
}
@end

@implementation SecureCodeButton

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        unselectedBackColor = RGBColor(0, 195, 76);
        selectedBackColor = RGBColor(45.0, 51.0, 55.0);
        
        self.backgroundColor = unselectedBackColor;
        
        backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = unselectedBackColor;
        [self addSubview:backView];
        
        [self setCornerRadiusIn:self radius:kCornusRadius];
        [self setCornerRadiusIn:backView radius:kCornusRadius];
        
        sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendCodeButton.frame = CGRectMake(5.0, 5.0, backView.frame.size.width - 10.0, backView.frame.size.height - 10.0) ;
        [sendCodeButton addTarget:self action:@selector(sendCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sendCodeButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [sendCodeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        sendCodeButton.userInteractionEnabled = YES;
        
        [backView addSubview:sendCodeButton];
    }
    return self;
}

#pragma mark - private
/**
 *  点击发送验证码按钮
 */
- (void)sendCodeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(secureCodeBtnClick:)]) {
        [self.delegate secureCodeBtnClick:self];
    }
}

- (void)start {
    time = 80;
    if (sendCodeButton.userInteractionEnabled) {
        sendCodeButton.userInteractionEnabled = NO;
    }
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changedTitle) userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:1.0 animations:^{
            backView.backgroundColor = selectedBackColor;
            [sendCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重发",time] forState:UIControlStateNormal];
        }];
    }
}

/**
 *  更改发送验证码按钮title
 */
- (void)changedTitle {
    time --;
    if (time <= 0) {
        [self reset];
        return;
    }
    [sendCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重发",time] forState:UIControlStateNormal];
}

/**
 *  设置view圆角
 *
 *  @param view
 *  @param radius 圆角
 */
- (void)setCornerRadiusIn:(UIView *)view radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 *  重设按钮样式
 */
- (void)reset {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (sendCodeButton) {
        [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        backView.backgroundColor = unselectedBackColor;
        sendCodeButton.userInteractionEnabled = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
