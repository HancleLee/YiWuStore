//
//  User.h
//  MyStore
//
//  Created by Hancle on 16/7/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface User : SuperModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, copy) NSString *loginTime;

@end