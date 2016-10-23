//
//  HKRefreshHeader.h
//  QiCheng51
//
//  Created by Hancle on 16/6/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

typedef void (^RefreshingBlock)();

@interface  MJRefreshHeader (More)

+ (MJRefreshHeader *)mjRefreshHeaderWith:(RefreshingBlock)refreshingBlock;


@end
