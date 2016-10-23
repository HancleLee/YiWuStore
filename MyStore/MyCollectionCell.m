//
//  MyCollectionCell.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MyCollectionCell.h"

@interface MyCollectionCell()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) BOOL hiddenMaskView;

@end

@implementation MyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = WhiteColor;
    
    self.imgview.clipsToBounds = YES;
    
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(190);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.mas_equalTo(@200);
    }];
    self.maskView.hidden = YES;
    self.hiddenMaskView = YES;
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = FontSize(16);
    [self.deleteButton setBackgroundColor:MainRedColor];
    self.deleteButton.layer.cornerRadius = 5.0f;
    [self.deleteButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.deleteButton];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskView.mas_left).with.offset(10);
        make.bottom.equalTo(self.maskView.mas_bottom).with.offset(- 50);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@32);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    NSLog(@"state = %zd showingDeleteConfirmation = %zd", state, self.showingDeleteConfirmation);
    if (!self.maskView) {
        self.maskView = [[UIView alloc] init];
        self.maskView.backgroundColor = GreenColor;
    }
    
    if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
//        NSLog(@"UITableViewCellStateShowingDeleteConfirmationMask");
        self.maskView.hidden = NO;
        self.hiddenMaskView = NO;
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    NSLog(@"didTransitionToState state = %zd showingDeleteConfirmation = %zd", state, self.showingDeleteConfirmation);

    if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        self.maskView.hidden = NO;
        self.hiddenMaskView = NO;
    }
    if (state == UITableViewCellStateDefaultMask) {
        if (self.hiddenMaskView == NO) {
            self.hiddenMaskView = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.maskView.hidden = YES;
                });
            });
        }
    }
}

- (void)configureCellWith:(GoodsList *)good {
    [CommonFunction hk_setImage:good.logo imgview:self.imgview];

    self.titleLabel.text = good.name;
    self.priceLabel.text = PRICE_TEXT(good.curPrice);
    self.originPriceLabel.text = PRICE_TEXT(good.prePrice);
    self.descLabel.text = good.title;
}

- (void)deleteBtnClick:(UIButton *)button {
    NSLog(@"delete");
}

@end
