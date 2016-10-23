//
//  ListButton.m
//  QiCheng51
//
//  Created by Hancle on 16/4/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ListButton.h"
#import "CommonDefine.h"

#define kBadgeViewWH 14.0

@interface ListButton()
{
    UIButton *titleBtn;
    UIView *bottomIndicator;
    UILabel *badgeView;
}
@end

@implementation ListButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"";
        self.titleColor = BlackColor;
        self.backColor = ClearColor;
        self.selectedTitleColor = RedColor;
        self.selectedBackColor = WhiteColor;
        self.textFont = 15.0;
        self.selected = NO;
        self.badgeNum = 0;
        
        self.backgroundColor = self.backColor;
        
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 2.0);
        [titleBtn setTitle:self.title forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:self.textFont]];
        [titleBtn setBackgroundColor:[UIColor clearColor]];
        titleBtn.selected = self.selected;
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:titleBtn];
        
        bottomIndicator = [[UIView alloc] init];
        bottomIndicator.backgroundColor = self.selectedTitleColor;
        bottomIndicator.hidden = !self.selected;
        
        [self addSubview:bottomIndicator];
        
        
        badgeView = [[UILabel alloc] init];
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.backgroundColor = RedColor;
        badgeView.textColor = WhiteColor;
        badgeView.font = FontSize(10);
        badgeView.layer.cornerRadius = kBadgeViewWH / 2;
        badgeView.layer.masksToBounds = YES;
        badgeView.text = [NSString stringWithFormat:@"%d",self.badgeNum];
        badgeView.hidden = (self.badgeNum == 0) ? YES : NO;
        
        [self addSubview:badgeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = self.backColor;

    titleBtn.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 2.0);
    [titleBtn setTitle:self.title forState:UIControlStateNormal];
    [titleBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
    [titleBtn setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
    [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:self.textFont]];
    titleBtn.tag = self.tag;
    titleBtn.selected = self.selected;
    
    CGSize size = [CommonFunction getSizeForText:self.title font:[UIFont systemFontOfSize:self.textFont] withConstrainedSize:CGSizeMake(MAXFLOAT, titleBtn.bounds.size.height)];
    bottomIndicator.frame = CGRectMake((titleBtn.bounds.size.width - size.width) / 2, self.bounds.size.height - 2.0, size.width, 2.0);
    bottomIndicator.backgroundColor = self.selectedTitleColor;
    bottomIndicator.hidden = !self.selected;
    
    badgeView.frame = CGRectMake(bottomIndicator.frame.origin.x + bottomIndicator.frame.size.width + 1.0, (titleBtn.frame.size.height - kBadgeViewWH) / 2, kBadgeViewWH, kBadgeViewWH);
    badgeView.text = [NSString stringWithFormat:@"%d",self.badgeNum];
    badgeView.hidden = (self.badgeNum == 0) ? YES : NO;
}

- (void)titleBtnClick:(UIButton *)sender {
    [self.delegate listBtnClick:self];
}

- (void)setupBadgeView:(int)badgeNum {
    self.badgeNum = badgeNum;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    titleBtn.selected = selected;
    bottomIndicator.hidden = selected ? NO : YES;
}

- (void)setBadgeNum:(int)badgeNum {
    _badgeNum = badgeNum;
    badgeView.text = [NSString stringWithFormat:@"%d",_badgeNum];
    badgeView.hidden = (badgeNum == 0) ? YES : NO;
}

@end
