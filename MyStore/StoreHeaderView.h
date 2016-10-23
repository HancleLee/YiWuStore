//
//  StoreHeaderView.h
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"

@interface StoreHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *backImgview;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)configureWith:(Store *)store;

@end
