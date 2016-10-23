//
//  GoodDetailHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/8/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodDetailHeaderView.h"

@interface GoodDetailHeaderView()

@property (nonatomic) CGRect tframe;

@end


@implementation GoodDetailHeaderView

+ (GoodDetailHeaderView *)headerViewWith:(CGRect)frame {
    GoodDetailHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    view.tframe = frame;
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = self.tframe;
}

- (void)configureViewWith:(GoodsList *)good {
    if (good) {
        [CommonFunction hk_setImage:good.logo imgview:self.imgview];
        self.nameLabel.text = good.name;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", good.curPrice];
        self.originPriceLabel.text = [NSString stringWithFormat:@"¥%@", good.prePrice];
    }
}

@end
