//
//  HomeHeaderViewCell.h
//  MyStore
//
//  Created by Hancle on 16/7/20.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (void)configureWithSize:(CGSize)size icon:(id)icon title:(NSString *)title fontSize:(CGFloat)fontSize;

@end
