//
//  GDHeaderView.h
//  MyStore
//
//  Created by Hancle on 16/10/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"
#import "GoodsListModel.h"

@protocol GDHeaderViewDelegate <NSObject>

- (void)headerViewDidSelectAt:(NSIndexPath *)indexPath good:(GoodsList *)good;

@end

@interface GDHeaderView : SuperView

@property (nonatomic, assign) id<GDHeaderViewDelegate> delegate;

- (void)configureViewWith:(GoodsList *)good;

@end
