//
//  MyCollectionVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MyCollectionVC.h"
#import "MyCollectionCell.h"
#import "CustomAlertViewHelper.h"
#import "CollectionModel.h"
#import "GoodsDetailVC.h"
#import "CollectEditModel.h"

@interface MyCollectionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, strong) CollectionModel *model;

@property (nonatomic, strong) NSURLSessionDataTask *listTask;
@property (nonatomic, strong) NSURLSessionDataTask *collectionTask;

@end

@implementation MyCollectionVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.index = @"0";
    [self.navigationItem setTitle:@"我的收藏"];
    [self creatUI];
    
    self.tableview.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        self.index = @"0";
        [self requestForGoodsCollectionWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT}];
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
    if (self.collectionTask) {
        [self.collectionTask cancel];
    }
}

// 返回按钮，重写
- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - request networking
- (void)requestForGoodsCollectionWith:(NSDictionary *)paraDic {
    self.listTask = [AFNetWorkingTool getJSONWithUrl:IPCollectionList parameters:paraDic progress:nil success:^(id responseObject) {
        CollectionModel *model = [[CollectionModel alloc] initWithJson:responseObject];
        [self endrefreshingWith:(model.data.count == REQUEST_DATA_COUNT.integerValue ? NO : YES)];
        if ([self.index integerValue] == 0) {
            self.model = model;
        }else {
            self.model = [self.model addObjWith:model];
        }
        [self updateUI];
        
    } fail:nil];
}

- (void)requestForCollectionWith:(GoodsList *)good {
    if (self.collectionTask) [self.collectionTask cancel];
    if (!good.goodsId) {
        return;
    }
    [CommonFunction showHUDIn:self];
    NSDictionary *paraDic = @{@"goodsId": good.goodsId};
    self.collectionTask = [AFNetWorkingTool postJSONWithUrl:IPCollectEdit parameters:paraDic progress:nil success:^(id responseObject) {
        CollectEditModel *model = [[CollectEditModel alloc] initWithJson:responseObject];
        if (model.type == 0) {
            NSMutableArray *datas = [NSMutableArray arrayWithArray:self.model.data];
            if ([datas containsObject:good]) {
                [datas removeObject:good];
                self.model.data = datas;
                [self.tableview reloadData];
            }
        }
        [CommonFunction showHUDIn:self text:model.msg];
        
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
    if ([self.index integerValue] == 0 || !self.tableview.mj_footer) {
        self.tableview.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
            self.index = [NSString stringWithFormat:@"%zd", self.model.data.count];
            [self requestForGoodsCollectionWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT}];
        }];
    }
}

/**
 *  停止刷新tableview
 *
 *  @param isNoMoreData 是否加载完全
 */
- (void)endrefreshingWith:(BOOL)isNoMoreData {
    if (isNoMoreData) {
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableview.mj_footer endRefreshing];
    }
    [self.tableview.mj_header endRefreshing];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectionCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyCollectionCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.model.data.count) {
        GoodsList *good = self.model.data[indexPath.row];
        [Cell configureCellWith:good];
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.model.data.count) {
        GoodsList *good = self.model.data[indexPath.row];
        GoodsDetailVC *vc = [GoodsDetailVC new];
        vc.good = good;
        [self pushViewController:vc];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomAlertView *alertview = [CustomAlertViewHelper show:@"删除商品后将不能恢复，您确定要删除商品吗？"];
    __block MyCollectionVC *weakSelf = self;
    alertview.buttonBlock = ^(BOOL isCancel) {
        NSLog(@"%zd", isCancel);
        if (!isCancel) {
            if (indexPath.row < weakSelf.model.data.count) {
                GoodsList *good = weakSelf.model.data[indexPath.row];
                [weakSelf requestForCollectionWith:good];
            }
        }
    };
}

@end
