//
//  OrdersVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrdersVC.h"
#import "ListView.h"
#import "OrdersCell.h"
#import "OrderListModel.h"
#import "OrderDetailVC.h"
#import "CommentVC.h"
#import "SelectPayTypeVC.h"

@interface OrdersVC ()
            <UITableViewDelegate,
            UITableViewDataSource,
            ListViewDelegate,
            OrderCellDelegate,
            OrderDetailVCDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ListView *listview;

@property (nonatomic, strong) NSURLSessionDataTask *listTask;
@property (nonatomic, strong) NSURLSessionDataTask *cancelTask;
@property (nonatomic, strong) NSURLSessionDataTask *receiveTask;
@property (nonatomic, assign) HKOrderStatus orderStatus;
@property (nonatomic, strong) OrderListModel *listModel;

@end

@implementation OrdersVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.orderStatus = self.index;
    
    [self .navigationItem setTitle:@"我的订单"];
    [self creatUI];
    
    __weak OrdersVC *weakSelf = self;
    self.tableview.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [weakSelf requestForOrderList];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.listTask) {
        [self.listTask cancel];
    }
    if (self.cancelTask) {
        [self.cancelTask cancel];
    }
}

// 返回按钮，重写
- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - request networking
- (void)requestForOrderList {
    // status（状态，0待付款，1待收货，2已收货，3已取消）
    NSString *status = [NSString stringWithFormat:@"%zd", self.orderStatus];
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

// 取消订单
- (void)requestForOrderCancelWith:(NSDictionary *)paraDic index:(NSIndexPath *)indexPath {
    [CommonFunction showHUDIn:self];
    self.cancelTask =  [AFNetWorkingTool postJSONWithUrl:IPOrderCancel parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        if (model.code == 0) {
            [CommonFunction hideAllHUDIn:self];
            if (indexPath.section < self.listModel.data.count) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.listModel.data];
                [arr removeObjectAtIndex:indexPath.section];
                self.listModel.data = arr;
                [self.tableview reloadData];
            }
            
        }else {
            [CommonFunction showHUDIn:self text:model.msg];
        }
        
    } fail:nil];
}

// 确认收货
- (void)requestForOrderReceiveWith:(NSDictionary *)paraDic {
    self.receiveTask = [AFNetWorkingTool postJSONWithUrl:IPReceiveOrder parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg];
        if (model.code == StatusRequestSuccess) {
            [self.tableview.mj_header beginRefreshing];
        }
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    CGFloat listViewH = 39.0;
    self.listview = [ListView listViewWithFrame:CGRectMake(0, 0, ScreenWidth, listViewH) items:@[@"待付款", @"待收货", @"已收货", @"已取消"]];
    self.listview.delegate = self;
    self.listview.selectedTextColor = MainRedColor;
    self.listview.textFont = 14.0;
    self.listview.textColor = RGBColor(128, 128, 128);
    self.listview.selectedIndex = (int)self.orderStatus;
    [self.view addSubview:self.listview];
    
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake( listViewH, 0, 0, 0));
    }];
}

- (void)updateUI {
    [self.tableview reloadData];
    if ([self.tableview.mj_header isRefreshing]) {
        [self.tableview.mj_header endRefreshing];
    }
}

#pragma mark - private
- (void)pushToOrderDetailVCWith:(NSInteger)index {
    if (index < self.listModel.data.count) {
        OrderList *order = self.listModel.data[index];
        OrderDetailVC *vc = [OrderDetailVC new];
        vc.order = order;
        vc.orderStatus = self.orderStatus;
        vc.delegate = self;
        [self pushViewController:vc];
    }
}

#pragma mark - ListViewDelegate
- (void)selectedListButtonAt:(NSInteger)index button:(ListButton *)button {
    NSLog(@"%zd",index);
    self.orderStatus = index;
    self.listModel = [OrderListModel new];
    [self updateUI];
    if ([self.tableview.mj_header isRefreshing]) {
        [self requestForOrderList];
        
    }else {
        [self.tableview.mj_header beginRefreshing];
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
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.listModel.data.count) {
        OrderList *order = self.listModel.data[indexPath.section];
        if (self.orderStatus == Cancel_order || self.orderStatus == Finish_order) {
            return 74 + order.goodsList.count * 100.0;
        }else {
            return 125 + order.goodsList.count * 100.0;
        }
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
    if (self.orderStatus == Cancel_order || self.orderStatus == Finish_order) {
        Cell.buttonBackView.hidden = YES;
    }else {
        Cell.buttonBackView.hidden = NO;
    }
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
- (void)leftBtnCLick:(OrdersCell *)cell model:(OrderList *)model {
    if ([cell.leftButton.titleLabel.text isEqualToString:@"取消订单"]) {
        CustomAlertView *alertview = [CustomAlertViewHelper show:@"您确定要取消订单吗？"];
        __block OrdersVC *weakSelf = self;
        alertview.buttonBlock = ^(BOOL isCancel) {
            if (!isCancel) {
                if (!StringNil(model.orderId)) {
                    NSIndexPath *indexpath = [weakSelf.tableview indexPathForCell:cell];
                    [weakSelf requestForOrderCancelWith:@{@"orderId": model.orderId} index:indexpath];
                }
            }
        };
    }
}

- (void)rightBtnCLick:(OrdersCell *)cell model:(OrderList *)model {
    if ([cell.rightButton.titleLabel.text isEqualToString:@"立即支付"]) {
        if (model) {
            SelectPayTypeVC *vc = [SelectPayTypeVC new];
            vc.order = model;
            [self pushViewController:vc];
        }
        
    }else if ([cell.rightButton.titleLabel.text isEqualToString:@"确认收货"]) {
        CustomAlertView *alertview = [CustomAlertViewHelper show:@"确定收货吗？"];
        __block OrdersVC *weakSelf = self;
        alertview.buttonBlock = ^(BOOL isCancel) {
            if (!isCancel) {
                if (!StringNil(model.orderId)) {
                    [weakSelf requestForOrderReceiveWith:@{@"orderId":model.orderId}];
                }
            }
        };
    }
}

- (void)commentBtnClick:(OrdersCell *)cell model:(SCGoodsList *)model orderId:(NSString *)orderId {
    NSLog(@"%@", model.goodsId);
    CommentVC *vc = [CommentVC new];
    vc.goodId = model.goodsId;
    vc.orderId = orderId;
    [self pushViewController:vc];
}

- (void)selectedCellWith:(OrdersCell *)cell index:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    [self pushToOrderDetailVCWith:indexPath.section];
}

#pragma mark - OrderDetailVCDelegate
- (void)cancelOrderSuccessWith:(OrderList *)order {
    [self.tableview.mj_header beginRefreshing];
}

@end
