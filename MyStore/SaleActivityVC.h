//
//  SaleActivityVC.h
//  MyStore
//
//  Created by Hancle on 16/8/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//
/**
 *  促销活动页
 */

#import "SuperVC.h"
#import "SortListModel.h"

@interface SaleActivityVC : SuperVC

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, strong) SortListModel *sortlist;

@end
