//
//  selectGoodTypeView.h
//  MyStore
//
//  Created by Hancle on 16/8/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"
@class SelectGoodTypeView;

@protocol SelectGoodTypeViewDelegate <NSObject>

- (void)selectedGoodTypeWith:(SelectGoodTypeView *)view good:(GoodsList *)good tags:(NSDictionary *)tags num:(NSString *)num;
- (void)removeBtnClick:(SelectGoodTypeView *)view btn:(UIButton *)button;

@end

@interface SelectGoodTypeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIView *tagsBackView;
@property (weak, nonatomic) IBOutlet UIView *backView;

// 选中的标签字典
@property (nonatomic, strong) NSMutableDictionary *selectedDic;

@property (nonatomic, weak) id<SelectGoodTypeViewDelegate> delegate;

+ (SelectGoodTypeView *)customviewWith:(CGRect)frame;

- (void)configureWith:(GoodsList *)good;

@end
