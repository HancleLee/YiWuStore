//
//  MeHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/8/8.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MeHeaderView.h"

@interface MeHeaderView()
@property (weak, nonatomic) IBOutlet UIView *lineVIew;
@property (weak, nonatomic) IBOutlet UIView *allOrderView;

@end

@implementation MeHeaderView

+ (MeHeaderView *)initHeaderView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    MeHeaderView *view = [arr objectAtIndex:0];
    view.avatarImgView.layer.cornerRadius = CGRectGetHeight(view.avatarImgView.frame) / 2;
    view.avatarImgView.clipsToBounds = YES;
    view.lineVIew.backgroundColor = MainBackColor;
    
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(myAvatarBtnClick:)];
    view.avatarImgView.userInteractionEnabled = YES;
    [view.avatarImgView addGestureRecognizer:tap0];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(myOrderViewTap:)];
    view.allOrderView.userInteractionEnabled = YES;
    [view.allOrderView addGestureRecognizer:tap1];
    
    for (NSInteger i = 101; i < 106; i ++) {
        UIView *orderview = [view viewWithTag:i];
        if (orderview) {
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(myOrderViewTap:)];
            orderview.userInteractionEnabled = YES;
            [orderview addGestureRecognizer:tap2];
        }
    }
    
    return view;
}

- (void)myAvatarBtnClick:(UITapGestureRecognizer *)tap {
    UIView *view = (UIView *)tap.view;
    if (view) {
        if ([self.delegate respondsToSelector:@selector(myAvatarBtnClick)]) {
            [self.delegate myAvatarBtnClick];
        }
    }
}

- (void)myOrderViewTap:(UITapGestureRecognizer *)tap {
    UIView *view = (UIView *)tap.view;
    if (view) {
        if ([self.delegate respondsToSelector:@selector(myOrderButtonClickAt:)]) {
            [self.delegate myOrderButtonClickAt:(view.tag - 100)];
        }
    }
}

- (void)configureViewWith:(User *)user {
    [CommonFunction hk_setImage:user.avatar imgview:self.avatarImgView];
    self.nicknameLabel.text = user.nickname;
}

@end
