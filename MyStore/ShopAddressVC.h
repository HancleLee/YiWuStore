//
//  ShipAddressVC.h
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperVC.h"
#import "MeManager.h"

@protocol ShopAddressVCDelegate <NSObject>

- (void)selectedAddressWith:(Address *)address;

@end

@interface ShopAddressVC : SuperVC

@property (nonatomic, assign) id<ShopAddressVCDelegate> delegate;

@end
