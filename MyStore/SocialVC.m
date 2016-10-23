//
//  SocialVC.m
//  MyStore
//
//  Created by Hancle on 16/7/9.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SocialVC.h"
#import "SocialCell.h"
#import "SocialPostVC.h"
#import "SocialListModel.h"
#import "PhotoBroswerHelper.h"
#import "CustomShareView.h"

static NSString *kTableViewId = @"SocailTableViewId";
static NSString *archKey = @"SocialVCArchKey";

@interface SocialVC () <UITableViewDelegate, UITableViewDataSource, SocialCellDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, strong) SocialListModel *model;
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation SocialVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"社区"];
    
    self.index = @"0";
    
    [self creatUI];
    
    self.mainTableView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [self.task cancel];
        self.index = @"0";
        [self requestForCommListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT}];
    }];
    [self.mainTableView.mj_header beginRefreshing];
    
    self.mainTableView.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
        [self.task cancel];
        self.index = [NSString stringWithFormat:@"%zd", self.model.data.count];
        [self requestForCommListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT}];
    }];
    
    self.model = [ArchiverHelper unarchiverModelWith:self.model key:archKey];
    if (self.model) {
        [self updateUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
// creat UI
- (void)creatUI {
    self.view.backgroundColor = MainBackColor;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"socialAdd") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemBtnClick:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.mainTableView = [[UITableView alloc] init];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [UIView new];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

// update UI
- (void)updateUI {
    [self.mainTableView reloadData];
}

#pragma mark - request network
- (void)requestForCommListWith:(NSDictionary *)paraDic {
    if (self.task) [self.task cancel];
    
    self.task = [AFNetWorkingTool getJSONWithUrl:IPComInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        SocialListModel *model = [[SocialListModel alloc] initWithJson:responseObject];
        [self endrefreshingWith:(model.data.count == REQUEST_DATA_COUNT.integerValue ? NO : YES)];
        if (self.index.integerValue > 0) {
            self.model = [self.model addObjWith:model];
        }else {
            self.model = model;
        }
        [self updateUI];
        [self cacheData];
        
    } fail:^(NSError *error) {
        [self endrefreshingWith:NO];
        [CommonFunction showHUDIn:[CommonFunction topViewController] text:RequestFailTipText hideTime:2 completion:nil];
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.model.data.count) {
        SocialList *model = self.model.data[indexPath.row];
        return [SocialList cellHeightWith:model];
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocialCell *Cell = [tableView dequeueReusableCellWithIdentifier:kTableViewId];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SocialCell class]) owner:nil options:nil].lastObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.delegate = self;
    }
    if (indexPath.row < self.model.data.count) {
        SocialList *cellmodel = self.model.data[indexPath.row];
        [Cell configureWith:cellmodel];
    }
    return Cell;
}

#pragma mark - SocailCellDelegate
- (void)selectedAtIndex:(NSInteger)index pics:(NSArray *)pics {
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *pic in pics) {
        [photos addObject:[NSString stringWithFormat:@"%@%@",IP_ADDRESS, pic]];
    }
    [PhotoBroswerHelper pushphotoBroswerInVC:self photos:photos currentIndex:index];
}

- (void)shareWith:(SocialList *)model {
    CustomShareView *shareview = [CustomShareView customShareViewWithPresentedViewController:self title:@"share title" content:@"share content" image:ImageNamed(@"img1") urlResource:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:shareview];
}

#pragma mark - private
/**
 *  发帖
 *
 *  @param item 发帖按钮
 */
- (void)rightItemBtnClick:(UIBarButtonItem *)item {
    NSLog(@"right item button click!!!");
    SocialPostVC *vc = [SocialPostVC new];
    [self pushViewController:vc];
}

/**
 *  停止刷新tableview
 *
 *  @param isNoMoreData 是否加载完全
 */
- (void)endrefreshingWith:(BOOL)isNoMoreData {
    if (isNoMoreData) {
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        
    }else {
        [self.mainTableView.mj_footer endRefreshing];
    }
    [self.mainTableView.mj_header endRefreshing];
}

- (void)cacheData {
    if (self.model) {
        [ArchiverHelper archiverModelWith:self.model key:archKey];
    }
}

@end
