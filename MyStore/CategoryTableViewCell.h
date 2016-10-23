//
//  CategoryTableViewCell.h
//  MyStore
//
//  Created by Hancle on 16/8/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (void)configigureCellWith:(NSString *)type isSelected:(BOOL)isSelected;

@end
