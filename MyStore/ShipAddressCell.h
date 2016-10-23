//
//  ShipAddressCell.h
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShipAddressCell;

@protocol ShipAddressCellDelegate <NSObject>

- (void)editBtnClick:(id)sender cell:(ShipAddressCell *)cell;

@end

@interface ShipAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addrLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, assign) id<ShipAddressCellDelegate> delegate;

@end
