//
//  MeVC.m
//  MyStore
//
//  Created by Hancle on 16/7/9.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MeVC.h"
#import "MeHeaderView.h"
#import "MeCell.h"
#import "MyProfileVC.h"
#import "MyCollectionVC.h"
#import "AboutUsVC.h"
#import "SettingVC.h"
#import "OrdersVC.h"
#import "AfterSaleListVC.h"

typedef NS_ENUM(NSInteger, OrderStatus) {
    kAll_Order = 0,          //所有订单
    kWait_pay_order,         // 待付款
    kPay_success_order,      // 待收货
    kFinish_order,           // 已收货
    kCancel_order,           // 已取消
    kAfter_Sale              // 售后
};

typedef NS_ENUM(NSInteger, TableListType) {
    kMyCollection = 0,      // 我的收藏
    kContactService = 1,    // 联系客服
    kAboutUs = 2            // 关于我们
};

@interface MeVC () <UITableViewDelegate, UITableViewDataSource, MeHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) MeHeaderView *headerview;

@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MeVC
#pragma mark - setter/getter
- (NSArray *)icons {
    return @[@[@"my_collection", @"my_service", @"my_about"], @[@"my_set"]];
}

- (NSArray *)titles {
    return @[@[@"我的收藏", @"联系客服", @"关于我们"], @[@"设置"]];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"我的"];
    
    [self creatUI];
    [self configure];
    
    // notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configure) name:NOTI_UPDATE_USER_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_UPDATE_USER_SUCCESS object:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.headerview = [MeHeaderView initHeaderView];
    self.headerview.delegate = self;
    [self.view addSubview:self.headerview];
    
    [self.headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(@335);
    }];
    
    self.tableview = [[UITableView alloc] init];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.tableFooterView = [UIView new];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerview.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
}

- (void)configure {
    User *user = [ArchiverHelper unarchiverModelWith:[User new] key:ARCH_USER];
    [self.headerview configureViewWith:user];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = MainBackColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MeCell";
    MeCell *Cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MeCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.section < self.icons.count) {
        NSArray *iconArr = self.icons[indexPath.section];
        NSArray *titleArr = self.titles[indexPath.section];
        if (indexPath.row < iconArr.count) {
            NSString *icon = iconArr[indexPath.row];
            NSString *title = titleArr[indexPath.row];
            [Cell.imgview setImage:ImageNamed(icon)];
            Cell.titleLabel.text = title;
        }
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == kMyCollection) { // 我的收藏
            MyCollectionVC *vc = [MyCollectionVC new];
            [self pushViewController:vc];
            
        }else if (indexPath.row == kContactService) { //  联系客服
            User *user = [ArchiverHelper unarchiverModelWith:[User new] key:ARCH_USER];
#warning here should be changed
            [CommonFunction phoneCallWith:user.phone];
            
        }else if (indexPath.row) {  // 关于我们
            AboutUsVC *vc = [AboutUsVC new];
            [self pushViewController:vc];
        }
        
    }else { // 设置
        SettingVC *vc = [SettingVC new];
        [self pushViewController:vc];
    }
}

#pragma mark - MeHeaderViewDelegate
// 点击我的订单模块
- (void)myOrderButtonClickAt:(NSInteger)index {
    NSLog(@"--%zd", index);
    if (index == kAfter_Sale) { // 售后
        AfterSaleListVC *vc = [AfterSaleListVC new];
        [self pushViewController:vc];
        
    }else {
        OrdersVC *vc = [OrdersVC new];
        switch (index) {
            case kAll_Order: // 所有订单
                vc.index = 0;
                break;
                
            case kWait_pay_order: // 待付款
                vc.index = 0;
                break;
                
            case kPay_success_order: // 待收货
                vc.index = 1;
                break;
                
            case kFinish_order: // 已收货
                vc.index = 2;
                break;
                
            case kCancel_order: // 已取消
                vc.index = 3;
                break;
                
            default:
                break;
        }
        [self pushViewController:vc];
    }
}

/**
 *  点击我的头像按钮
 */
- (void)myAvatarBtnClick {
    NSLog(@"avatar button click!!");
    MyProfileVC *vc = [MyProfileVC new];
    [self pushViewController:vc];
}

@end
