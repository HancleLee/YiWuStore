//
//  ListView.m
//  QiCheng51
//
//  Created by Hancle on 16/4/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ListView.h"

@interface ListView() 
{
    UIScrollView *backview;
    UIView *btnBackView;
    NSInteger badgeIndex;
    NSMutableArray *badgeIndexArr;
}
@end

@implementation ListView

- (void)setSelectedIndex:(int)selectedIndex {
    _selectedIndex = selectedIndex;
    for (id item in [backview subviews]) {
        if ([item isKindOfClass:[ListButton class]]) {
            ListButton *button = item;
            if (button.tag == selectedIndex) {
                self.selectedButton = button;
            }
        }
    }
}

+ (ListView *)listViewWithFrame:(CGRect)frame items:(NSArray *)items itemNum:(NSInteger)itemNum {
    return [[ListView alloc] initWithFrame:frame items:items itemNum:itemNum];
}

+ (ListView *)listViewWithFrame:(CGRect)frame items:(NSArray *)items {
    return [[ListView alloc] initWithFrame:frame items:items];
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items itemNum:(NSInteger)itemsNum {
    self = [super initWithFrame:frame];
    if (self) {
        if (itemsNum > items.count) {
            self.itemNum = items.count;
        }else {
            self.itemNum = itemsNum;
        }
        self.backColor = WhiteColor;
        self.topDistance = 0.0;
        self.leftDistance = 0.0;
        self.titles = items;
        self.selectedIndex = 0;
        self.textFont = 15.0;
        self.textColor = RGBColor(96, 99, 98);
        self.selectedTextColor = RGBColor(180, 134, 18);
        
        backview = [[UIScrollView alloc] initWithFrame:CGRectMake( self.leftDistance, 0, frame.size.width - self.leftDistance * 2, frame.size.height)];
        backview.showsHorizontalScrollIndicator = NO;
        backview.showsVerticalScrollIndicator = NO;
        backview.backgroundColor = [UIColor clearColor];
        [self addSubview:backview];
        badgeIndexArr = [NSMutableArray array];
        
        if (self.itemNum == 0) {
            self.itemNum = self.titles.count;
        }
        CGFloat btnWidth = (CGFloat)backview.bounds.size.width / self.itemNum;
        btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth * self.titles.count, backview.bounds.size.height)];
        [backview addSubview:btnBackView];
        for (int i = 0; i < self.titles.count; i ++) {
            ListButton *btn = [[ListButton alloc] initWithFrame:CGRectMake(btnWidth * i, self.topDistance, btnWidth, btnBackView.bounds.size.height)];
            btn.titleColor = RGBColor(96, 99, 98);
            btn.selectedTitleColor = MainRedColor;
            btn.title = self.titles[i];
            btn.textFont = self.textFont;
            if (i == self.selectedIndex) {
                btn.selected = YES;
            }
            btn.tag = i;
            btn.delegate = self;
            [btnBackView addSubview:btn];
        }
        backview.contentSize = CGSizeMake(btnWidth * self.titles.count, 0);
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    return [self initWithFrame:frame items:items itemNum:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = self.backColor;
    backview.backgroundColor = self.backColor;
    btnBackView.backgroundColor = ClearColor;
    
    int i = 0;
    for (id item in [btnBackView subviews]) {
        if ([item isKindOfClass:[ListButton class]]) {
            ListButton *button = item;
            button.titleColor = self.textColor;
            button.selectedTitleColor = self.selectedTextColor;
            button.selected = (self.selectedIndex == button.tag) ? YES : NO;
            button.textFont = self.textFont;
            
//            CGRect bFrame = btnBackView.frame;
//            bFrame.origin.x = self.leftDistance;
//            bFrame.size.width = self.frame.size.width - self.leftDistance * 2;
//            btnBackView.frame = bFrame;

            CGFloat btnWidth = (CGFloat)backview.bounds.size.width / self.itemNum;
            button.frame = CGRectMake(btnWidth * i, self.topDistance, btnWidth, btnBackView.bounds.size.height);
        }
        i ++;
    }
}

- (void)setBadgeAtIndex:(NSInteger)index badge:(int)badgeNum {
    for (id item in [backview subviews]) {
        if ([item isKindOfClass:[ListButton class]]) {
            ListButton *button = item;
            if (index == button.tag) {
                [badgeIndexArr addObject:[NSString stringWithFormat:@"%zi",index]];
                [button setupBadgeView:badgeNum];
            }
        }
    }
}

- (void)listBtnDidSelectedWith:(int)index {
    self.selectedIndex = index;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark - ListButtonDelegate
- (void)listBtnClick:(ListButton *)btn {
    self.selectedIndex = (int)btn.tag;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if ([self.delegate respondsToSelector:@selector(selectedListButtonAt:button:)]) {
        [self.delegate selectedListButtonAt:self.selectedIndex button:btn];
    }
}

@end
