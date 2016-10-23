//
//  OrdersCell.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrdersCell.h"
#import "OrdersGoodCell.h"

@interface OrdersCell() <UITableViewDelegate, UITableViewDataSource, OrdersGoodCellDelegate>

@property (nonatomic, strong) OrderList *orderlist;
@property (nonatomic, assign) HKOrderStatus orderStatus;

@end

@implementation OrdersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.storeImgView.layer.cornerRadius =  23.0 / 2;
    self.storeImgView.clipsToBounds = YES;
    
    self.goodsBackView.delegate = self;
    self.goodsBackView.dataSource = self;
    
    self.goodsBackView.scrollsToTop = NO;
    self.goodsBackView.scrollEnabled = NO;
    
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    
    self.orderStatus = Wait_pay_order;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(OrderList *)model {
    self.orderlist = model;
    self.orderStatus = [self.orderlist.status integerValue];
    [self updateUI];
}

- (void)updateUI {
    [self.goodsBackView reloadData];
    [CommonFunction hk_setImage:self.orderlist.shopLogoThumb imgview:self.storeImgView];

    self.storeTitleLabel.text = self.orderlist.shopName;
    self.orderCodeLabel.text = StringWithFomat2(@"订单编号 ", self.orderlist.orderId);
    NSArray *status = @[@"待付款", @"待收货", @"已收货", @"已取消"];
    NSInteger index = [self.orderlist.status integerValue];
    if (index < status.count) {
        self.orderStatusLabel.text = status[index];
        switch (index) {
            case Wait_pay_order:
                self.leftButton.hidden = NO;
                self.rightButton.hidden = NO;
                [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.rightButton setTitle:@"立即支付" forState:UIControlStateNormal];
                break;
                
            case Wait_receive_order:
                self.leftButton.hidden = YES;
                self.rightButton.hidden = NO;
                [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                break;
                
            case Finish_order:
                self.leftButton.hidden = YES;
                self.rightButton.hidden = NO;
                [self.rightButton setTitle:@"评论" forState:UIControlStateNormal];
                break;
                
            default:
                self.leftButton.hidden = YES;
                self.rightButton.hidden = YES;
                break;
        }
        
    }else if(index == After_sale) {
        NSString *statusStr = self.orderlist.afterSaleService.status == After_sale_dealing ? @"处理中" : @"退款成功";
        self.orderStatusLabel.text = statusStr;
        
    }else {
        self.orderStatusLabel.text = @"";
    }
}

- (IBAction)leftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftBtnCLick:model:)]) {
        [self.delegate leftBtnCLick:self model:self.orderlist];
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(rightBtnCLick:model:)]) {
        [self.delegate rightBtnCLick:self model:self.orderlist];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderlist.goodsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrdersGoodCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrdersGoodCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrdersGoodCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor = MainBackColor;
        Cell.delegate = self;
    }
    if (indexPath.row < self.orderlist.goodsList.count) {
        SCGoodsList *good = self.orderlist.goodsList[indexPath.row];
        [Cell configureCellWith:good showComment:(self.orderStatus == Finish_order) ? YES : NO];
    }
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectedCellWith:index:)]) {
        [self.delegate selectedCellWith:self index:indexPath.row];
    }
}

#pragma mark - OrdersGoodCellDelegate
- (void)commentBtnClick:(OrdersGoodCell *)cell good:(SCGoodsList *)good {
    if ([self.delegate respondsToSelector:@selector(commentBtnClick:model:orderId:)]) {
        [self.delegate commentBtnClick:self model:good orderId:self.orderlist.orderId];
    }
}

@end
