//
//  MJRefreshFooter+More.m
//  QiCheng51
//
//  Created by Hancle on 16/6/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MJRefreshFooter+More.h"

static NSString *refreshingTitle = @"玩命加载中...";
static NSString *noMoreDataTitle = @"没有更多内容";

@implementation MJRefreshFooter (More)

+ (MJRefreshFooter *)mjRefreshFooterWith:(RefreshingBlock)refreshingBlock {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        refreshingBlock();
    }];
    // Set title
    [footer setTitle:refreshingTitle forState:MJRefreshStateRefreshing];
    [footer setTitle:noMoreDataTitle forState:MJRefreshStateNoMoreData];
    
    // Set font
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    //    footer.stateLabel.textColor = [UIColor blueColor];
    
    return footer;
}

@end
