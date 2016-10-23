//
//  ChangeAddresVC.h
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperVC.h"
#import "AddressModel.h"

@protocol ChangeAddresVCDelegate <NSObject>

- (void)changeAddressSuccess;

@end

@interface ChangeAddresVC : SuperVC

@property (nonatomic, strong) Address *addr;
@property (nonatomic, assign) id<ChangeAddresVCDelegate> delegate;

@end
