//
//  ListButton.h
//  QiCheng51
//
//  Created by Hancle on 16/4/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListButton;

@protocol ListButtonDelegate <NSObject>

@optional
- (void)listBtnClick:(ListButton *)btn;

@end

@interface ListButton : UIView

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *selectedBackColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign)  CGFloat textFont;
@property (nonatomic) BOOL selected;
@property (nonatomic, assign) int badgeNum;

@property (nonatomic, weak) id<ListButtonDelegate> delegate;

- (void)setupBadgeView:(int)badgeNum;

@end
