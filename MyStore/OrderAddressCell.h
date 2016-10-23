//
//  OrderAddressCell.h
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeManager.h"

@interface OrderAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)configureWith:(Address *)address;

@end
