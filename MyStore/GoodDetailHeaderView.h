//
//  GoodDetailHeaderView.h
//  MyStore
//
//  Created by Hancle on 16/8/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

@interface GoodDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

+ (GoodDetailHeaderView *)headerViewWith:(CGRect)frame;
- (void)configureViewWith:(GoodsList *)good;

@end
