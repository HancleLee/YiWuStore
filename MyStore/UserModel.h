//
//  UserModel.h
//  MyStore
//
//  Created by Hancle on 16/8/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"
#import "User.h"

@interface UserModel : SuperModel

@property (nonatomic, strong) User *data;

@end
