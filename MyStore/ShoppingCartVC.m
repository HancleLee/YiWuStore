//
//  ShoppingCartVC.m
//  MyStore
//
//  Created by Hancle on 16/7/9.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "ShoppingCartCell.h"
#import "ShopCartFooterView.h"
#import "ShopCartModel.h"
#import "ShopCartManager.h"
#import "ConfirmOrderVC.h"

static NSString *kCellId    = @"ShoppingCartCellId";
static NSString *kEditing   = @"编辑";
static NSString *kDone      = @"完成";

@interface ShoppingCartVC ()
            <UITableViewDelegate,
            UITableViewDataSource,
            ShoppingCartCellDelegate,
            ShopCartFooterViewDelegate,
            ConfirmOrderVCDelegate>

@property (nonatomic, strong) UITableView           *mainTableView;
@property (nonatomic, strong) ShopCartFooterView    *footerView;
@property (nonatomic, strong) NSURLSessionDataTask  *listTask;
@property (nonatomic, strong) NSURLSessionDataTask  *deleteListTask;
@property (nonatomic, strong) NSURLSessionDataTask  *deleteAllTask;
@property (nonatomic, strong) ShopCartModel         *cartModel;

@end

@implementation ShoppingCartVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"购物车"];
    [self creatUI];
    
    self.mainTableView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [self requestForCartList];
    }];
    
    self.mainTableView.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
        [self.mainTableView.mj_footer  endRefreshingWithNoMoreData];
    }];
    [self.mainTableView.mj_header beginRefreshing];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.listTask) [self.listTask cancel];
    if (self.deleteListTask) [self.deleteListTask cancel];
    if (self.deleteAllTask) [self.deleteAllTask cancel];
}

#pragma mark - request networking
// 请求 购物车列表
- (void)requestForCartList {
    self.listTask = [AFNetWorkingTool getJSONWithUrl:IPCartInfoList parameters:nil progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.cartModel = [[ShopCartModel alloc] initWithJson:responseObject];

        if (self.cartModel.code != 0) {
            [CommonFunction showHUDIn:self text:self.cartModel.msg];
        }
        [self updateUI];
        
    } fail:nil];
}

// 请求 批量删除购物车
- (void)requestForDeleteListWith:(NSDictionary *)paraDic {
    self.deleteListTask = [AFNetWorkingTool postJSONWithUrl:@"/cart/deleteList" parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        NSLog(@"code == %zd",model.code);
        if (model.code == 0) {
            [self deleteGoodListSuccess];
        }
        [CommonFunction showHUDIn:self text:model.msg];
        
    } fail:nil];
}

// 请求删除购物车所有商品
- (void)requestForDeleteAllGoodsWith:(NSDictionary *)paraDic {
    self.deleteAllTask = [AFNetWorkingTool postJSONWithUrl:@"/cart/deleteAll" parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        if (model.code == 0) {
            [self deleteGoodListSuccess];
        }
        [CommonFunction showHUDIn:self text:model.msg];
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - UI
- (void)creatUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = MainBackColor;
    self.rightItemBtnTitle = kEditing;
    
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
    
    self.footerView = [ShopCartFooterView shopcartFooterView];
    self.footerView.delegate = self;
    [self.view addSubview:self.footerView];
    
    CGFloat footerViewH = 43.0;
    
    CGFloat bottomOffset = - 49;
    if (self.navigationController.tabBarController.tabBar.hidden == YES)    bottomOffset = 0;
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(bottomOffset);
        make.height.mas_equalTo(footerViewH);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.footerView.mas_top).with.offset(0);
    }];
}

// update UI
- (void)updateUI {
    if ([self.mainTableView.mj_header isRefreshing]) {
        [self.mainTableView.mj_header endRefreshing];
    }
    [self.mainTableView reloadData];
    [self.footerView configureWith:self.cartModel];
}

#pragma mark - private
- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem {
    NSLog(@"right item button click...");
    [self updateRightBtnStatus];
}

- (void)updateRightBtnStatus {
    if ([self.rightItemBtnTitle isEqualToString:kEditing]) {
        self.rightItemBtnTitle = kDone;
        [self.footerView.countButton setTitle:@"删除" forState:UIControlStateNormal];
        
    }else {
        self.rightItemBtnTitle = kEditing;
        [self.footerView.countButton setTitle:@"结算" forState:UIControlStateNormal];
    }
}

// 请求删除购物车成功
- (void)deleteGoodListSuccess {
    self.cartModel = [ShopCartManager deleteSelectedGoods:self.cartModel];
    [self updateUI];
    [self updateRightBtnStatus];
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"count = %zd", self.cartModel.data.count);
    return self.cartModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.cartModel.data.count) {
        ShopCart *shopcart = self.cartModel.data[section];
        return shopcart.goodsList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return 148 - 46;
    }
    return 148;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *Cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShoppingCartCell class]) owner:nil options:nil].lastObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.delegate = self;
    }
    if (indexPath.row != 0) {
        Cell.storeViewHeightConstraint.constant = 0;
        Cell.storeBackView.hidden = YES;
    }
    if (indexPath.section < self.cartModel.data.count) {
        ShopCart *shopcart = self.cartModel.data[indexPath.section];
        [Cell configureCellWith:shopcart index:indexPath.row];
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.section);
}

#pragma mark - ShoppingCartCellDelegate
- (void)shopSelectBtnClick:(UIButton *)button shopId:(NSString *)shopId isSelected:(BOOL)isSelected {
    self.cartModel = [ShopCartManager updateModelSelectStatusAtShop:shopId isSelected:isSelected model:self.cartModel];
    [self updateUI];
}

- (void)goodSelectBtnClick:(UIButton *)button good:(SCGoodsList *)good isSelected:(BOOL)isSelected {
    self.cartModel = [ShopCartManager updateModelSelectStatusAt:good isSelected:isSelected model:self.cartModel];
    [self updateUI];
}

- (void)changeGoodAmountWith:(SCGoodsList *)good amount:(NSString *)amount {
    self.cartModel = [ShopCartManager updateModelAmountAt:good amount:amount model:self.cartModel];
    [self updateUI];
}

#pragma mark - ShopCartFooterViewDelegate
- (void)selectAllWith:(UIButton *)button isSelected:(BOOL)isSelected {
    self.cartModel = [ShopCartManager updateModelAllSelectStatusWith:isSelected model:self.cartModel];
    [self updateUI];
}

- (void)countOrDeleteBtnClick:(UIButton *)button {
    NSLog(@"%@",button.titleLabel.text);
    if ([button.titleLabel.text isEqualToString:@"删除"]) {
        if (self.cartModel.isSelected) { // 删除所有
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:TOKEN forKey:@"token"];
            [self requestForDeleteAllGoodsWith:paraDic];
            
        }else { // 删除部分
            NSArray *selectedArr = [ShopCartManager selectedGoods:self.cartModel];
            NSMutableArray *arr = [NSMutableArray array];
            for (id item in selectedArr) {
                if ([item isKindOfClass:[SCGoodsList class]]) {
                    SCGoodsList *good = item;
                    NSString *jsonString = [CommonFunction transferToJsonStringWith:good.tags];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:good.goodsId forKey:@"goodsId"];
                    [dic setObject:jsonString forKey:@"tags"];
                    [arr addObject:dic];
                }
            }
            NSLog(@"arr-- %@",arr);
            if (arr.count > 0) {
                NSString *goodlist = [CommonFunction transferToJsonStringWith:arr];
                
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                [paraDic setObject:TOKEN forKey:@"token"];
                [paraDic setObject:goodlist forKey:@"goodsList"];
                
                [self requestForDeleteListWith:paraDic];
            }
        }
        
    }else { // 结算
        if (self.cartModel.data.count > 0) {
            ShopCartModel *ml = [self.cartModel mutableCopy];
            if ([ShopCartManager isSelectedGoodsIn:ml]) {
                ConfirmOrderVC *vc = [ConfirmOrderVC new];
                vc.cartModel = [ShopCartManager selectedCartModel:ml];
                vc.delegate = self;
                [self pushViewController:vc];
            }
        }
    }
}

#pragma mark - ConfirmOrderVCDelegate
- (void)creatOrderSuccessWith:(ShopCartModel *)cartmodel {
    [self.mainTableView.mj_header beginRefreshing];
}

@end
