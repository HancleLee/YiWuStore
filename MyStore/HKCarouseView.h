//
//  HKCarouseView.h
//  MyStore
//
//  Created by Hancle on 16/7/6.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKCarouseView;

@protocol HKCarouseViewDelegate <NSObject>

- (void)selectedAdViewAtIndex:(NSInteger)index view:(HKCarouseView *)view;

@end

@interface HKCarouseView : UIView

@property (nonatomic, assign) id<HKCarouseViewDelegate> delegate;
+ (instancetype)carouseViewWith:(CGRect)frame images:(NSArray *)images;

@end
