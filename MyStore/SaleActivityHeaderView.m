//
//  SaleActivityHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/8/27.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SaleActivityHeaderView.h"
#import "ListView.h"
#import "SortListModel.h"

@interface SaleActivityHeaderView() <ListViewDelegate>

@property (nonatomic, strong) NSArray *items;

@end

@implementation SaleActivityHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    return self;
}

- (void)configureHeaderviewWith:(NSArray *)items {
    self.items = items;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (id item in items) {
        if ([item isKindOfClass:[SortList class]]) {
            SortList *sort = item;
            [arr addObject:sort.name];
        }
    }
    NSInteger itemnum = 5;
    ListView *listview = [ListView listViewWithFrame:self.bounds items:arr itemNum:itemnum];
    listview.selectedTextColor = MainRedColor;
    listview.textColor = MainBlackColor;
    listview.delegate = self;
    [self addSubview:listview];
}

#pragma mark - ListViewDelegate
- (void)selectedListButtonAt:(NSInteger)index button:(ListButton *)button {
    if (index < self.items.count) {
        id item = self.items[index];
        if ([item isKindOfClass:[SortList class]]) {
            SortList *sort = item;
            if ([self.delegate respondsToSelector:@selector(selectedAt:title:)]) {
                [self.delegate selectedAt:sort.myId title:sort.name];
            }
        }
        
    }else {
        NSLog(@"error: %s",__func__);
    }
}

@end
