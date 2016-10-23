//
//  HomeCollectionCell.h
//  MyStore
//
//  Created by Hancle on 16/7/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

@interface HomeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

- (void)configureCellWith:(GoodsList *)good;

@end
