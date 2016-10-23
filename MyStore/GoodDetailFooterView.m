//
//  GoodDetailFooterView.m
//  MyStore
//
//  Created by Hancle on 16/8/18.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodDetailFooterView.h"

@interface GoodDetailFooterView()

@property (nonatomic, strong) GoodsList *good;
@property (nonatomic, assign) CGRect tframe;

@end

@implementation GoodDetailFooterView
#pragma mark - life cycle
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
//        self.frame = frame;
//        [self creatUI];
//    }
//    return self;
//}

+ (instancetype)footerViewWith:(CGRect)frame {
    GoodDetailFooterView *view =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    view.frame = frame;
    view.tframe = frame;
    [view creatUI];
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tframe = self.frame;
    tframe.size.height = self.tframe.size.height;
    self.frame = tframe;
}

#pragma mark - UI
- (void)creatUI {
    self.imgview1.clipsToBounds = YES;
    self.imgview2.clipsToBounds = YES;
    self.imgview3.clipsToBounds = YES;
    self.imgview4.clipsToBounds = YES;
}

#pragma mark - private
- (void)configureWith:(GoodsList *)good {
    self.good = good;
    
    self.titleLabel.text = good.title;
    self.detailLabel.text = good.details;
    if (good.imageList.count >= 4) {
        [CommonFunction hk_setImage:good.imageList[0] imgview:self.imgview1];
        [CommonFunction hk_setImage:good.imageList[1] imgview:self.imgview2];
        [CommonFunction hk_setImage:good.imageList[2] imgview:self.imgview3];
        [CommonFunction hk_setImage:good.imageList[3] imgview:self.imgview4];
    }
}

@end
