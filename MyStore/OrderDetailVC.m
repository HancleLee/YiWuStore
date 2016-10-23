//
//  OrderDetailVC.m
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrdersGoodCell.h"
#import "OrderDetailCell.h"
#import "OrderAddressCell.h"
#import "AfterSaleVC.h"
#import "SelectPayTypeVC.h"
#import "OrderDetailFooterView.h"

#define kOrderCancel     @"取消订单"
#define kOrderPay        @"立即支付"
#define kOrderComment    @"评论"
#define kOrderAfterSale  @"申请售后"
#define kOrderConfirm    @"确认收货"


@interface OrderDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *priceBackView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSURLSessionDataTask *cancelTask;

@end

@implementation OrderDetailVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"订单详情"];
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request networking
- (void)requestForOrderCancelWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.cancelTask =  [AFNetWorkingTool postJSONWithUrl:IPOrderCancel parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == 0) {
                [CommonFunction hideAllHUDIn:self];
                [self cancelOrderSuccess];
            }
        }];
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [UITableView new];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = ClearColor;
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 46.0, 0));
//        make.top.equalTo(self.view.mas_top).with.offset(0);
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(46);
    }];
    
    OrderDetailFooterView *footerview = [[OrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120.0)];
    [footerview configureViewWith:self.order status:self.orderStatus];
    self.priceLabel.text = @"";
    self.priceBackView.hidden = NO;
    switch (self.orderStatus) {
        case Wait_pay_order:
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            [self.leftButton setTitle:kOrderCancel forState:UIControlStateNormal];
            [self.rightButton setTitle:kOrderPay forState:UIControlStateNormal];
            self.priceLabel.text = StringWithFomat2(@"需付：", @"") ;
            self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
            break;
            
        case Wait_receive_order:
            self.leftButton.hidden = YES;
            self.rightButton.hidden = NO;
            [self.rightButton setTitle:kOrderConfirm forState:UIControlStateNormal];
            self.tableview.tableFooterView = footerview;
            break;
            
        case Finish_order:
            self.leftButton.hidden = YES;
            self.rightButton.hidden = NO;
            [self.rightButton setTitle:kOrderAfterSale forState:UIControlStateNormal];
            self.tableview.tableFooterView = footerview;
            break;
            
        case After_sale:
            self.priceBackView.hidden = YES;
            [self updateConstraint];
            self.tableview.tableFooterView = footerview;
            break;
            
        default: // Cancel_order
            self.priceBackView.hidden = YES;
            [self updateConstraint];
            self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
            break;
    }
}

- (void)updateConstraint {
    [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderStatus == Wait_pay_order || self.orderStatus == Cancel_order) {
        return 3;
    }else {
       return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70.0;
        
    }else if(indexPath.section == 1) {
        if (indexPath.row < self.order.goodsList.count) {
            return 125 + self.order.goodsList.count * 100.0;
        }
        return 0;
        
    }else {
        return 36.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OrderAddressCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell"];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderAddressCell class]) owner:nil options:nil].firstObject;
            Cell.accessoryType = UITableViewCellAccessoryNone;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section < self.order.goodsList.count) {
            [Cell configureWith:self.order.address];
        }
        return Cell;
        
    }else if(indexPath.section == 1) {
        OrderDetailCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailCell class]) owner:nil options:nil].firstObject;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Cell.backgroundColor = MainBackColor;
        }
        if (indexPath.row < self.order.goodsList.count) {
            [Cell configureCellWith:self.order];
        }
        return Cell;
        
    }else {
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailDefaultCell"];
        if (!Cell) {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OrderDetailDefaultCell"];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Cell.textLabel.font = FontSize(12);
            Cell.textLabel.textColor = RGBColor(64, 64, 64);
            Cell.detailTextLabel.font = FontSize(12);
            Cell.detailTextLabel.textColor = RGBColor(64, 64, 64);
        }
        Cell.textLabel.text = @"创建时间";
        Cell.detailTextLabel.text = [CommonFunction transformTimeStamp:(double)self.order.createTime andForm:@"yyyy-MM-dd HH:mm"];
        return Cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd %zd", indexPath.section, indexPath.row);
}

#pragma mark - private
- (IBAction)leftBtnClick:(id)sender {
    if ([self.leftButton.titleLabel.text isEqualToString:kOrderCancel]) {
        CustomAlertView *alertview = [CustomAlertViewHelper show:@"您确定要取消该订单吗？"];
        __block OrderDetailVC *weakSelf = self;
        alertview.buttonBlock = ^(BOOL isCancel) {
            NSLog(@"%zd", isCancel);
            if (!isCancel) {
                if (!StringNil(weakSelf.order.orderId)) {
                    [weakSelf requestForOrderCancelWith:@{@"orderId": weakSelf.order.orderId}];
                }
            }
        };
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if ([self.rightButton.titleLabel.text isEqualToString:kOrderAfterSale]) {
        AfterSaleVC *vc = [AfterSaleVC new];
        vc.orderId = self.order.orderId;
        [self pushViewController:vc];
        
    }else if ([self.rightButton.titleLabel.text isEqualToString:kOrderPay]) {
        SelectPayTypeVC *vc = [SelectPayTypeVC new];
        [self pushViewController:vc];
    }
}

// 取消订单成功后的处理
- (void)cancelOrderSuccess {
    if ([self.delegate respondsToSelector:@selector(cancelOrderSuccessWith:)]) {
        [self.delegate cancelOrderSuccessWith:self.order];
    }
    [self popviewControllerWith:YES];
}

@end
