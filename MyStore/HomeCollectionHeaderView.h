//
//  HomeCollectionHeaderView.h
//  MyStore
//
//  Created by Hancle on 16/8/3.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@class HomeCollectionHeaderView;

@protocol HomeCollectionHeaderViewDelegate <NSObject>

- (void)headerView:(HomeCollectionHeaderView *)headerView selectedAtSection:(NSInteger)section row:(NSInteger)row shop:(Store *)shop;
- (void)carouseViewAt:(NSInteger)index banner:(Banner *)banner;

@end

@interface HomeCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) UICollectionView *sortCollectionView;
@property (nonatomic, strong) UICollectionView *shopCollectionView;

@property (nonatomic, assign) id<HomeCollectionHeaderViewDelegate> delegate;

- (void)configureWith:(HomeModel *)model;

@end
