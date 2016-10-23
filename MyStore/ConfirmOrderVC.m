//
//  ConfirmOrderVC.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "OrderAddressCell.h"
#import "GoodInfoCell.h"
#import "GoodDetailCell.h"
#import "SelectPayTypeCell.h"
#import "ShopAddressVC.h"
#import "PaySuccessVC.h"
#import "OrderModel.h"
#import "NSObject+HKModel.h"
#import "WXOrderModel.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayModel.h"

@interface ConfirmOrderVC ()
            <UITableViewDelegate,
            UITableViewDataSource,
            ShopAddressVCDelegate,
            WXApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, assign) HKPayType     selectedPayType; // 付款方式
@property (nonatomic, strong) Address       *selectedAddress; // 收获地址
@property (nonatomic, strong) OrderModel    *orderModel;

@property (nonatomic, strong) NSURLSessionDataTask *orderTask;
@property (nonatomic, strong) NSURLSessionDataTask *wxOrderTask;

@end

@implementation ConfirmOrderVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"确认订单"];

    self.selectedPayType = AliPay;
    if (!self.selectedAddress  && [MeManager shareInstance].addressModel.data.addressList.count > 0) {
        self.selectedAddress = [MeManager shareInstance].addressModel.data.addressList[0];
    }
    
    [self creatUI];
    
    if (self.good) {
        CGFloat totalPrice = [self.good.curPrice floatValue] * [self.num floatValue];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"合计： ¥%.2f", totalPrice];
        
    }else if(self.cartModel) {
        NSString *price = PRICE_TEXT([ShopCartManager selectedGoodsPrice:self.cartModel]);
        self.totalPriceLabel.text = [NSString stringWithFormat:@"合计： %@", price];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.orderTask) {
        [self.orderTask cancel];
    }
    if (self.wxOrderTask) {
        [self.wxOrderTask cancel];
    }
}

#pragma mark - request networking
// 请求 创建订单
- (void)requestForCreatOrderWith:(id)paraDic {
    if (self.orderTask) [self.orderTask cancel];
    [CommonFunction showHUDIn:self];
    self.orderTask = [AFNetWorkingTool postJSONWithUrl:IPOrderCreat parameters:paraDic progress:nil success:^(id responseObject) {
        self.orderModel = [[OrderModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:self.orderModel.msg hideTime:1 completion:^{
            if (self.orderModel.code == 0) {
                [self creatOrderSuccessWith:self.orderModel];
            }
        }];

    } fail:nil];
}

// 请求微信支付订单
- (void)requestForWXOrderWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.wxOrderTask = [AFNetWorkingTool postJSONWithUrl:IPPayWXAppOrder parameters:paraDic progress:nil success:^(id responseObject) {
        WXOrderModel *model = [[WXOrderModel alloc] initWithJson:responseObject];
        [self wechatPayWith:model.data];
        [CommonFunction hideAllHUDIn:self];
        
    } fail:nil];
}

- (void)requestForAliPayOrderWith:(NSDictionary *)paraDic {
    [AFNetWorkingTool postJSONWithUrl:IPPayAliPayOrder parameters:paraDic progress:nil success:^(id responseObject) {
        AliPayModel *model = [[AliPayModel alloc] initWithJson:responseObject];
        [self alipayWith:model.data];
        
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
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 46, 0));
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.good) {
        return 3;
        
    }else {
        return 2 + self.cartModel.data.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
        
    }else {
        if ((self.good && section == 1) || (!self.good && section < self.cartModel.data.count + 1)) {
            if (self.good ) {
                return 2;
                
            }else {
                NSInteger index = section - 1;
                if (index < self.cartModel.data.count) {
                    ShopCart *cart = self.cartModel.data[index];
                    return cart.goodsList.count + 1;
                    
                }else {
                    return 1;
                }
            }
            
        }else {
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;

    }else {
        if ((self.good && indexPath.section == 1) || (!self.good && indexPath.section < self.cartModel.data.count + 1)) {
            if (indexPath.row == 0) {
                return 36;
            }else {
                return 100;
            }
        }else {
            return 50;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OrderAddressCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell"];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderAddressCell class]) owner:nil options:nil].firstObject;
            Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [Cell configureWith:self.selectedAddress];
        return Cell;
        
    }else {
        if ((self.good && indexPath.section == 1) || (!self.good && indexPath.section < self.cartModel.data.count + 1)) {
            if (indexPath.row == 0) {
                GoodDetailCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
                if (!Cell) {
                    Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GoodDetailCell class]) owner:nil options:nil].firstObject;
                    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                Cell.titleLabel.textColor = MainGrayColor;
                if (self.good) {
                    [Cell configureCellWith:self.good.shopLogo title:self.good.shopName];
                }else {
                    NSInteger index = indexPath.section - 1;
                    if (index < self.cartModel.data.count) {
                        ShopCart *cart = self.cartModel.data[index];
                        [Cell configureCellWith:cart.shopImage title:cart.shopName];
                    }
                }
                return Cell;
                
            }else {
                GoodInfoCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"GoodInfoCell"];
                if (!Cell) {
                    Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GoodInfoCell class]) owner:nil options:nil].firstObject;
                    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSString *tags = @"";
                for (NSString *key in self.selctedTags.allKeys) {
                    id item = self.selctedTags[key];
                    tags = [tags stringByAppendingString:key];
                    tags = [tags stringByAppendingString:@":"];
                    if ([item isKindOfClass:[NSString class]]) {
                        NSString *val = item;
                        tags = [tags stringByAppendingString:val];
                        tags = [tags stringByAppendingString:@" "];
                    }
                }
                if (self.good) {
                    [Cell configureWith:self.good tags:tags num:self.num];
                }else {
                    NSInteger index = indexPath.section - 1;
                    if (index < self.cartModel.data.count) {
                        ShopCart *cart = self.cartModel.data[index];
                        if (indexPath.row - 1 < cart.goodsList.count) {
                            SCGoodsList * goodlist = cart.goodsList[indexPath.row - 1];
                            [Cell configureWith:goodlist tags:goodlist.tagsStr num:goodlist.amount];
                        }
                    }
                }
                return Cell;
            }
            
        }else {
            SelectPayTypeCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"SelectPayTypeCell"];
            if (!Cell) {
                Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectPayTypeCell class]) owner:nil options:nil].firstObject;
                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            Cell.selectButton.tag = indexPath.row;
            
            NSArray *imgnames = @[@"alipay", @"wechat"];
            NSArray *titles = @[@"支付宝", @"微信支付"];
            [Cell.imgview setImage:ImageNamed(imgnames[indexPath.row])];
            Cell.titleLabel.text = titles[indexPath.row];
            if (self.selectedPayType == indexPath.row) {
                [Cell.selectButton setImage:ImageNamed(@"sc_select") forState:UIControlStateNormal];
            }else {
                [Cell.selectButton setImage:ImageNamed(@"sc_unselect") forState:UIControlStateNormal];
            }
            __weak ConfirmOrderVC *weakSelf = self;
            Cell.selectPayBlock = ^(NSInteger buttonTag) {
                weakSelf.selectedPayType = buttonTag;
                [weakSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return Cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShopAddressVC *vc = [ShopAddressVC new];
        vc.delegate = self;
        [self pushViewController:vc];
    }
}

#pragma mark - ShopAddressVCDelegate
- (void)selectedAddressWith:(Address *)address {
    NSLog(@"%@",address.address);
    self.selectedAddress = address;
    [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - private
// 创建订单成功
- (void)creatOrderSuccessWith:(OrderModel *)model {
    if (self.selectedPayType == WeixinPay) {
        NSString *orderIds = [CommonFunction transferToJsonStringWith:model.data.orderIds];
        if (!StringNil(orderIds))
            [self requestForWXOrderWith:@{@"orderIds": orderIds}];
        
    }else {
        [self requestForAliPayOrderWith:nil];
    }
    
    // 创建订单成功后，通知购物车刷新数据
    if ([self.delegate respondsToSelector:@selector(creatOrderSuccessWith:)]) {
        [self.delegate creatOrderSuccessWith:self.cartModel];
    }
}

// 确认订单按钮
- (IBAction)confimOrderBtnClick:(id)sender {
    NSLog(@"confirm button click");
    if (self.selectedAddress == nil) {
        [CommonFunction showHUDIn:self text:@"请选择收获地址"];
        
    }else {
        if (self.cartModel) {
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            NSMutableArray *shopArr = [NSMutableArray array];
            for (ShopCart *cart in self.cartModel.data) {
                NSMutableDictionary *cartDic = [NSMutableDictionary dictionary];
                [cartDic setObject:cart.shopId forKey:@"shopId"];
                [cartDic setObject:self.selectedAddress.addressId forKey:@"addressId"];
                [cartDic setObject:cart.shopId forKey:@"shopId"];
                NSMutableArray *goodArr = [NSMutableArray array];
                for (SCGoodsList *goodlist in cart.goodsList) {
                    NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
                    [goodDic setObject:goodlist.goodsId forKey:@"goodsId"];
                    [goodDic setObject:goodlist.amount forKey:@"amount"];
                    [goodDic setObject:[CommonFunction transferToJsonStringWith:goodlist.tags] forKey:@"tags"];
                    [goodArr addObject:goodDic];
                }
                [cartDic setObject:goodArr forKey:@"goodsList"];
                [shopArr addObject:cartDic];
            }
            [paraDic setObject:[CommonFunction transferToJsonStringWith:shopArr] forKey:@"shopList"];
            [paraDic setObject:@"true" forKey:@"isFromCart"];
            
            [self requestForCreatOrderWith:paraDic];
            
        }else if (self.good) {
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            NSMutableArray *shopArr = [NSMutableArray array];
            
            NSMutableDictionary *cartDic = [NSMutableDictionary dictionary];
            [cartDic setObject:self.good.shopId forKey:@"shopId"];
            [cartDic setObject:self.selectedAddress.addressId forKey:@"addressId"];
            NSMutableArray *goodArr = [NSMutableArray array];
            NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
            [goodDic setObject:self.good.goodsId forKey:@"goodsId"];
            [goodDic setObject:self.num forKey:@"amount"];
            [goodDic setObject:[CommonFunction transferToJsonStringWith:self.selctedTags] forKey:@"tags"];
            [goodArr addObject:goodDic];
            
            [cartDic setObject:goodArr forKey:@"goodsList"];
            [shopArr addObject:cartDic];
            
            [paraDic setObject:[CommonFunction transferToJsonStringWith:shopArr] forKey:@"shopList"];
            
            [self requestForCreatOrderWith:paraDic];
        }
    }
}

#pragma mark - weixin pay
// 调起 微信支付
- (void)wechatPayWith:(WXOrder *)order {
    [WXApiManager sharedManager].delegate = self;
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

// WXApiManagerDelegate
// 支付成功后的处理
- (void)managerDidPaySuccess:(PayReq *)payReq {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark - alipay
- (void)alipayWith:(NSString *)payInfo {
    if (payInfo == nil) {
        return;
    }
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"yiwustore";
    [[AlipaySDK defaultService] payOrder:payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //【callback处理支付结果】
        NSLog(@"reslut = %@",resultDic);
        NSLog(@"result = %@ -- %@",resultDic[@"memo"], resultDic[@"result"]);
        if ([resultDic[@"resultStatus"] intValue] == 9000) { // 订单支付成功
//            [self queryForOrderInformation];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:resultDic[@"memo"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        PaySuccessVC *vc = [[PaySuccessVC alloc] init];
        vc.payType = self.selectedPayType;
        vc.totalPrice = self.orderModel.data.totalPrice;
        vc.orderIds = self.orderModel.data.orderIds;
        [self pushViewController:vc];
    }
}

@end
