//
//  SocialPostModel.h
//  MyStore
//
//  Created by Hancle on 16/8/27.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"
#import "SocialListModel.h"

@interface SocialPostModel : SuperModel

@property (nonatomic, strong) SocialList *data;

@end
