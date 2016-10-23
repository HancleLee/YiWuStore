//
//  SelectGoodTypeHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/9/11.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SelectGoodTypeHeaderView.h"


@interface SelectGoodTypeHeaderView()
{
    UIView *lineView;
    UILabel *label;
    UIView *line;
}
@end

@implementation SelectGoodTypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WhiteColor;
        
        CGFloat labelY = 5;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        lineView.backgroundColor = MainBackColor;
        [self addSubview:lineView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, labelY, self.frame.size.width, self.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainBlackColor;
        [self addSubview:label];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, ScreenWidth, 1)];
        line.backgroundColor = MainBackColor;
        [self addSubview:line];
    }
    return self;
}

- (void)configureHeagerViewWith:(NSString *)title {
    label.text = title;
}

@end
