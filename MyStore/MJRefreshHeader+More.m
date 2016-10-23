//
//  HKRefreshHeader.m
//  QiCheng51
//
//  Created by Hancle on 16/6/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MJRefreshHeader+More.h"

static NSString *refreshingTitle = @"玩命加载中...";
static NSString *noMoreDataTitle = @"没有更多内容";

@implementation MJRefreshHeader (More)

+ (MJRefreshHeader *)mjRefreshHeaderWith:(RefreshingBlock)refreshingBlock {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refreshingBlock();
    }];
    // Hide the time
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // Set title
    [header setTitle:refreshingTitle forState:MJRefreshStateRefreshing];
    [header setTitle:noMoreDataTitle forState:MJRefreshStateNoMoreData];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    
    return header;
}



@end
