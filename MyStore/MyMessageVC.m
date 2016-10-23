//
//  MyMessageVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MyMessageVC.h"
#import "MyMessageCell.h"
#import "MessageListModel.h"

@interface MyMessageVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) MessageListModel *model;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MyMessageVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"我的消息"];
    [self creatUI];
    
    self.tableview.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        self.index = 0;
        [self requestForMessageListWith:@{@"size":REQUEST_DATA_COUNT, @"index":[NSString stringWithFormat:@"%zd", self.index]}];
    }];
    self.tableview.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
        self.index = self.model.data.count;
        [self requestForMessageListWith:@{@"size":REQUEST_DATA_COUNT, @"index":[NSString stringWithFormat:@"%zd", self.index]}];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.task) {
        [self.task cancel];
    }
}

#pragma mark - request networking
- (void)requestForMessageListWith:(NSDictionary *)paraDic {
    self.task = [AFNetWorkingTool getJSONWithUrl:IPMessageInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        MessageListModel *model = [[MessageListModel alloc] initWithJson:responseObject];
        [self endrefreshingWith:(model.data.count == REQUEST_DATA_COUNT.integerValue ? NO : YES)];
        if (self.index > 0) {
            self.model = [self.model addObjWith:model];
        }else {
            self.model = model;
        }
        [self updateUI];
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [UIView new];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)updateUI {
    [self.tableview reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.model.data.count) {
        MessageList *msg = self.model.data[indexPath.row];
        return [msg cellHeight];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyMessageCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"MyMessageCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyMessageCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor = MainBackColor;
    }
    if (indexPath.row < self.model.data.count) {
        MessageList *msg = self.model.data[indexPath.row];
        [Cell configureCellWith:msg];
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd %zd", indexPath.section, indexPath.row);
}

#pragma mark - private
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

@end
