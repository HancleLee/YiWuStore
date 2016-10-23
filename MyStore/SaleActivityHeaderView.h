//
//  SaleActivityHeaderView.h
//  MyStore
//
//  Created by Hancle on 16/8/27.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"

@protocol SaleActivityHeaderViewDelegate <NSObject>

- (void)selectedAt:(NSString *)pid title:(NSString *)title;

@end

@interface SaleActivityHeaderView : SuperView

@property (nonatomic, assign) id<SaleActivityHeaderViewDelegate> delegate;
- (void)configureHeaderviewWith:(NSArray *)items;

@end
