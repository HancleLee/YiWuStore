//
//  OrderDetailCell.m
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "OrderDetailCell.h"
#import "OrdersGoodCell.h"

@interface OrderDetailCell()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OrderList *orderlist;

@end

@implementation OrderDetailCell
#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.storeImgView.layer.cornerRadius =  23.0 / 2;
    self.storeImgView.clipsToBounds = YES;
    
    self.goodsBackView.delegate = self;
    self.goodsBackView.dataSource = self;
    
    self.goodsBackView.scrollsToTop = NO;
    self.goodsBackView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - private
- (void)configureCellWith:(OrderList *)model {
    self.orderlist = model;
    [self updateUI];
}

- (void)updateUI {
    NSLog(@"update ui");
    [self.goodsBackView reloadData];
    [CommonFunction hk_setImage:self.orderlist.shopLogoThumb imgview:self.storeImgView];

    self.storeTitleLabel.text = self.orderlist.shopName;
    self.orderCodeLabel.text = StringWithFomat2(@"订单编号 ", self.orderlist.orderId);
    NSArray *status = @[@"待付款", @"待收货", @"已收货", @"已取消"];
    NSInteger index = [self.orderlist.status integerValue];
    if (index < status.count) {
        self.orderStatusLabel.text = status[index];
        
    }else if (index == After_sale) {
        NSString *statusStr = self.orderlist.afterSaleService.status == After_sale_dealing ? @"处理中" : @"退款成功";
        self.orderStatusLabel.text = statusStr;
        
    }else {
        self.orderStatusLabel.text = @"";
    }
}

- (IBAction)contactBtnClick:(id)sender {
    NSLog(@"contact button click");
    [CommonFunction phoneCallWith:self.orderlist.contactPhone];
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
    }
    if (indexPath.row < self.orderlist.goodsList.count) {
        SCGoodsList *good = self.orderlist.goodsList[indexPath.row];
        [Cell configureCellWith:good showComment:NO];
    }
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd %zd", indexPath.section, indexPath.row);
}

@end
