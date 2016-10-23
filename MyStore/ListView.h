//
//  ListView.h
//  QiCheng51
//
//  Created by Hancle on 16/4/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListButton.h"

@protocol ListViewDelegate <NSObject>

- (void)selectedListButtonAt:(NSInteger)index button:(ListButton *)button;

@end

@interface ListView : UIView <ListButtonDelegate>

@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) int badgeNum;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) CGFloat topDistance;
@property (nonatomic, assign) CGFloat leftDistance;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) CGFloat textFont;
@property (nonatomic, assign) NSInteger itemNum;
@property (nonatomic, strong) ListButton *selectedButton;

@property (nonatomic, weak) id<ListViewDelegate> delegate;

// initial
+ (ListView *)listViewWithFrame:(CGRect)frame items:(NSArray *)items;
+ (ListView *)listViewWithFrame:(CGRect)frame items:(NSArray *)items itemNum:(NSInteger)itemNum;
// 设置未读消息
- (void)setBadgeAtIndex:(NSInteger)index badge:(int)badgeNum;
// 设置选中按钮
- (void)listBtnDidSelectedWith:(int)index;

@end
