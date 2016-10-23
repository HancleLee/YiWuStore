//
//  OrdersGoodCell.m
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrdersGoodCell.h"

@interface OrdersGoodCell()

@property (nonatomic, assign) BOOL showCommentButton;
@property (nonatomic, strong) SCGoodsList *good;

@end

@implementation OrdersGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodImgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowCommentButton:(BOOL)showCommentButton {
    _showCommentButton = showCommentButton;
    if (showCommentButton) {
        self.commentButton.hidden = NO;
        self.goodDescTrailConstraint.constant = 50.0;
    }else {
        self.commentButton.hidden = YES;
        self.goodDescTrailConstraint.constant = 8.0;
    }
}

- (void)configureCellWith:(SCGoodsList *)good showComment:(BOOL)showCommentButton {
    self.good = good;
    self.showCommentButton = showCommentButton;
    [CommonFunction hk_setImage:good.goodsLogo imgview:self.goodImgView];

    self.goodNameLabel.text = good.goodsName;
    self.goodDescLabel.text = good.tagsStr;
    self.realPriceLabel.text = PRICE_TEXT(good.curPrice);
    self.originPriceLabel.text = PRICE_TEXT(good.prePrice);
    self.goodNumLabel.text = StringWithFomat2(@"X ", good.amount);
}

- (IBAction)commentBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commentBtnClick:good:)]) {
        [self.delegate commentBtnClick:self good:self.good];
    }
}

@end
