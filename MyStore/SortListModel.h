//
//  SortListModel.h
//  MyStore
//
//  Created by Hancle on 16/9/18.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface SortList : SuperModel

@property (nonatomic, copy) NSString *myId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *logo;

@end

@interface SortListModel : SuperModel

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *sortId;

@end
