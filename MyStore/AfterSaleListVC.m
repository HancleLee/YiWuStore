//
//  AfterSaleListVC.m
//  MyStore
//
//  Created by Hancle on 16/10/21.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "AfterSaleListVC.h"
#import "OrdersCell.h"
#import "OrderListModel.h"
#import "OrderDetailVC.h"

@interface AfterSaleListVC ()
            <UITableViewDelegate,
            UITableViewDataSource,
            OrderCellDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) OrderListModel *listModel;
@property (nonatomic, strong) NSURLSessionDataTask *listTask;

@end

@implementation AfterSaleListVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"售后订单"];
    [self creatUI];
    
    __weak AfterSaleListVC *weakSelf = self;
    self.tableview.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [weakSelf requestForOrderList];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回按钮，重写
- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - request networking
- (void)requestForOrderList {
    NSString *status = [NSString stringWithFormat:@"%zd", After_sale];
    [self requestForOrderListWith:@{@"status": status}];
}

// 订单列表
- (void)requestForOrderListWith:(id)paraDic {
    if (self.listTask) [self.listTask cancel];
    self.listTask = [AFNetWorkingTool getJSONWithUrl:IPOrderInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        OrderListModel *model = [[OrderListModel alloc] initWithJson:responseObject];
        self.listModel = model;
        [self updateUI];
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)updateUI {
    [self.tableview reloadData];
    if ([self.tableview.mj_header isRefreshing]) {
        [self.tableview.mj_header endRefreshing];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.listModel.data.count) {
        OrderList *order = self.listModel.data[indexPath.section];
        return 74.0 + order.goodsList.count * 100.0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrdersCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrdersCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrdersCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor = MainBackColor;
    }
    Cell.delegate = self;
    Cell.buttonBackView.hidden = YES;
    if (indexPath.section < self.listModel.data.count) {
        OrderList *order = self.listModel.data[indexPath.section];
        [Cell configureCellWith:order];
    }
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd %zd", indexPath.section, indexPath.row);
    [self pushToOrderDetailVCWith:indexPath.section];
}

#pragma mark - OrderCellDelegate
- (void)selectedCellWith:(OrdersCell *)cell index:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    [self pushToOrderDetailVCWith:indexPath.section];
}

#pragma mark - private
- (void)pushToOrderDetailVCWith:(NSInteger)index {
    if (index < self.listModel.data.count) {
        OrderList *order = self.listModel.data[index];
        OrderDetailVC *vc = [OrderDetailVC new];
        vc.order = order;
        vc.orderStatus = After_sale;
        [self pushViewController:vc];
    }
}

@end
