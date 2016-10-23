//
//  GoodDetailFooterView.h
//  MyStore
//
//  Created by Hancle on 16/8/18.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

@interface GoodDetailFooterView : UIView

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgview1;
@property (weak, nonatomic) IBOutlet UIImageView *imgview2;
@property (weak, nonatomic) IBOutlet UIImageView *imgview3;
@property (weak, nonatomic) IBOutlet UIImageView *imgview4;

+ (instancetype)footerViewWith:(CGRect)frame;
- (void)configureWith:(GoodsList *)good;

@end
