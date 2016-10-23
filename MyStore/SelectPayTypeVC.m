//
//  SelectPayTypeVC.m
//  MyStore
//
//  Created by Hancle on 16/10/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SelectPayTypeVC.h"
#import "SelectPayTypeCell.h"
#import "WXOrderModel.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PaySuccessVC.h"

@interface SelectPayTypeVC ()
            <UITableViewDelegate,
            UITableViewDataSource,
            UIAlertViewDelegate>

@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, assign) NSInteger     selectedPayType; // 付款方式

@property (nonatomic, strong) NSURLSessionDataTask *wxOrderTask;

@end

@implementation SelectPayTypeVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"支付"];
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.wxOrderTask) {
        [self.wxOrderTask cancel];
    }
}

#pragma mark - request networking
// 请求微信支付订单
- (void)requestForWXOrderWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.wxOrderTask = [AFNetWorkingTool postJSONWithUrl:IPPayWXAppOrder parameters:paraDic progress:nil success:^(id responseObject) {
        WXOrderModel *model = [[WXOrderModel alloc] initWithJson:responseObject];
        [self wechatPayWith:model.data];
        [CommonFunction hideAllHUDIn:self];
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableview];
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(25, 15, ScreenWidth - 50, 43);
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    payButton.backgroundColor = MainRedColor;
    [payButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    payButton.layer.cornerRadius = 5.0f;
    [footerView addSubview:payButton];
    self.tableview.tableFooterView = footerView;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view.backgroundColor = ClearColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, view.bounds.size.height)];
    label.text = @"选择支付方式";
    label.font = FontSize(15.0);
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectPayTypeCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"SelectPayTypeCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectPayTypeCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Cell.selectButton.tag = indexPath.row;
    
    NSArray *imgnames   = @[@"alipay", @"wechat"];
    NSArray *titles     = @[@"支付宝", @"微信支付"];
    [Cell.imgview setImage:ImageNamed(imgnames[indexPath.row])];
    Cell.titleLabel.text = titles[indexPath.row];
    if (self.selectedPayType == indexPath.row) {
        [Cell.selectButton setImage:ImageNamed(@"sc_select") forState:UIControlStateNormal];
    }else {
        [Cell.selectButton setImage:ImageNamed(@"sc_unselect") forState:UIControlStateNormal];
    }
    __weak SelectPayTypeVC *weakSelf = self;
    Cell.selectPayBlock = ^(NSInteger buttonTag) {
        weakSelf.selectedPayType = buttonTag;
        [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return Cell;
}

#pragma mark - private
- (void)payBtnClick:(UIButton *)button {
    NSArray *orders = @[self.order.orderId];
    NSString *orderIds = [CommonFunction transferToJsonStringWith:orders];
    if (self.selectedPayType == WeixinPay) {
        if (!StringNil(orderIds))
            [self requestForWXOrderWith:@{@"orderIds": orderIds}];
        
    }else if (self.selectedPayType == AliPay) {
        
    }
}

#pragma mark - weixin pay
// 调起 微信支付
- (void)wechatPayWith:(WXOrder *)order {
    if (order) {
        PayReq* req     =   [[PayReq alloc] init];
        req.partnerId   =   order.partnerid;
        req.prepayId    =   order.prepayid;
        req.nonceStr    =   order.noncestr;
        req.timeStamp   =   order.timestamp;
        req.package     =   order.package;
        req.sign        =   order.sign;
        [WXApi sendReq:req];
    }
}

// WXApiManagerDelegate, 支付成功后的处理
- (void)managerDidPaySuccess:(PayReq *)payReq {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        PaySuccessVC *vc = [[PaySuccessVC alloc] init];
        vc.payType = self.selectedPayType;
#warning here should be changed
//        vc.totalPrice = self.orderModel.data.totalPrice;
        vc.orderIds = self.order.orderId;
        [self pushViewController:vc];
    }
}

@end
