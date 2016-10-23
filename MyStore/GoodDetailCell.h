//
//  GoodDetailCell.h
//  MyStore
//
//  Created by Hancle on 16/9/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;

- (void)configureCellWith:(id)img title:(NSString *)title;

@end
