//
//  ShipAddressVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShopAddressVC.h"
#import "ChangeAddresCell.h"
#import "ShipAddressCell.h"
#import "ChangeAddresVC.h"

@interface ShopAddressVC ()<UITableViewDelegate, UITableViewDataSource, ShipAddressCellDelegate, ChangeAddresVCDelegate>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ShopAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"收货地址"];
    
    [self creatUI];
    
    self.tableview.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [self requestForAddressList];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - request networking
- (void)requestForAddressList {
    [AFNetWorkingTool postJSONWithUrl:IPAddressList parameters:nil progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MeManager shareInstance].addressModel = [[AddressModel alloc] initWithJson:responseObject];
        if ([MeManager shareInstance].addressModel.code == 0) {
            [self.tableview reloadData];
            
        }else {
            [CommonFunction showHUDIn:self text:[MeManager shareInstance].addressModel.msg];
        }
        if ([self.tableview.mj_header isRefreshing]) {
            [self.tableview.mj_header endRefreshing];
        }
        
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
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 55, 0));
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:ImageNamed(@"login_btn_bg") forState:UIControlStateNormal];
    [addButton setTitle:@"新增地址" forState:UIControlStateNormal];
    addButton.titleLabel.textColor = WhiteColor;
    addButton.titleLabel.font = FontSize(16);
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-12);
        make.left.equalTo(self.view.mas_left).with.offset(29);
        make.right.equalTo(self.view.mas_right).with.offset(-29);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - private
// 点击新增地址按钮
- (void)addBtnClick:(UIButton *)sender {
    ChangeAddresVC *vc = [ChangeAddresVC new];
    [self pushViewController:vc];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MeManager shareInstance].addressModel.data.addressList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShipAddressCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"ShipAddressCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShipAddressCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Cell.delegate = self;
    if (indexPath.row < [MeManager shareInstance].addressModel.data.addressList.count) {
        id item = [MeManager shareInstance].addressModel.data.addressList[indexPath.row];
        if ([item isKindOfClass:[Address class]]) {
            Address *addr = item;
            Cell.userLabel.text = [NSString stringWithFormat:@"%@     %@",addr.contact, addr.phone];
            Cell.addressLabel.text = StringWithFomat2(addr.area, addr.address);
            BOOL isDefault = ([[MeManager shareInstance].addressModel.data.defaultAddressId isEqualToString:addr.addressId]) ? YES : NO;
            if (isDefault) {
                Cell.defaultLabel.hidden = NO;
                Cell.addrLeadingConstraint.constant = 50.0;
                
            }else {
                Cell.defaultLabel.hidden = YES;
                Cell.addrLeadingConstraint.constant = 8.0;
            }
        }
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectedAddressWith:)]) {
        if (indexPath.row < [MeManager shareInstance].addressModel.data.addressList.count) {
            id item = [MeManager shareInstance].addressModel.data.addressList[indexPath.row];
            if ([item isKindOfClass:[Address class]]) {
                Address *addr = item;
                [self.delegate selectedAddressWith:addr];
                [self popviewControllerWith:YES];
            }
        }
    }
}

#pragma mark - ChangeAddresVCDelegate
- (void)changeAddressSuccess {
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - ShipAddressCellDelegate
- (void)editBtnClick:(id)sender cell:(ShipAddressCell *)cell {
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    ChangeAddresVC *vc = [ChangeAddresVC new];
    vc.delegate = self;
    if (indexPath.row < [MeManager shareInstance].addressModel.data.addressList.count) {
        id item = [MeManager shareInstance].addressModel.data.addressList[indexPath.row];
        if ([item isKindOfClass:[Address class]]) {
            Address *addr = item;
            vc.addr = addr;
        }
    }
    [self pushViewController:vc];
}

@end
