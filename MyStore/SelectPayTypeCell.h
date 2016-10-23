//
//  SelectPayTypeCell.h
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectPayTypeBlock)(NSInteger buttonTag);

@interface SelectPayTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, copy) SelectPayTypeBlock selectPayBlock;

@end
