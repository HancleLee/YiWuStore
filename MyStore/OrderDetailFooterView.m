//
//  OrderDetailFooterView.m
//  MyStore
//
//  Created by Hancle on 16/10/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderDetailFooterView.h"
#import "OrderDetailFooterCell.h"
#import <objc/runtime.h>

@interface OrderDetailFooterView ()
            <UITableViewDelegate,
            UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *details;

@end

@implementation OrderDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.tableview = [[UITableView alloc] init];
//                      WithFrame:self.bounds];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.scrollEnabled = NO;
    [self addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(8.0, 0, 0, 0));
    }];
}

- (void)configureViewWith:(OrderList *)orderlist status:(HKOrderStatus)status {
    
    
    
    if (status == Finish_order || status == After_sale) {
        self.titles = @[@"创建时间", @"支付时间", @"支付方式", @"发货时间", @"收货时间"];
        NSString *payType = @"ss";
        NSLog(@"%@", orderlist.createTimeStr);
        self.details = @[orderlist.createTimeStr, orderlist.payTimeStr, payType, orderlist.deliverTimeStr, orderlist.receiveTimeStr];
        
    }else if (status == Wait_receive_order) {
        self.titles = @[@"创建时间", @"支付时间", @"支付方式", @"发货时间"];
        NSString *payType = @"ss";
        NSLog(@"%@", orderlist.createTimeStr);
        self.details = @[orderlist.createTimeStr, orderlist.payTimeStr, payType, orderlist.deliverTimeStr];
    }
    [self.tableview reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailFooterCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailFooterCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailFooterCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor = WhiteColor;
    }
    if (indexPath.row < self.titles.count) {
        NSString *title = self.titles[indexPath.row];
        NSString *detail = self.details[indexPath.row];
        [Cell configureCellWith:title detail:detail];
    }
    
    return Cell;
}

@end
