//
//  GoodsCategoryVC.m
//  MyStore
//
//  Created by Hancle on 16/8/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodsCategoryVC.h"
#import "CategoryCell.h"
#import "CategoryTableViewCell.h"
#import "GoodListVC.h"
#import "SortListModel.h"

static NSString *cellIdentifier = @"CategoryCell";
static NSString *sortlistArchKey = @"sortlistArchKey";

@interface GoodsCategoryVC ()
            <UITableViewDelegate,
            UITableViewDataSource,
            UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView           *tableview;
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, assign) NSInteger             selectedIndex;
@property (nonatomic, strong) SortListModel         *sortlist;
@property (nonatomic, strong) SortListModel         *typelist;
@property (nonatomic, copy)   NSString              *archKey;
@property (nonatomic, strong) NSString              *pid;
@property (nonatomic, strong) NSURLSessionDataTask  *task;

@end

@implementation GoodsCategoryVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"分类"];
    self.selectedIndex = 0;
    self.pid = @"0";
    
    [self creatUI];
    
    // load cache
    self.sortlist = [ArchiverHelper unarchiverModelWith:self.typelist key:sortlistArchKey];
    if (self.sortlist) {
        [self.tableview reloadData];
        if (self.sortlist.data.count > 0) {
            SortList *sortlist = self.sortlist.data[0];
            self.pid = sortlist.myId;
            
            NSString *archKey = StringWithFomat2(@"GoodsCategoryArchKey", self.pid);
            self.typelist = [ArchiverHelper unarchiverModelWith:self.typelist key:archKey];
            if (self.typelist) {
                [self.collectionView reloadData];
            }
        }
    }
    
    self.collectionView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [self requestForSortList];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = WhiteColor;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.width.mas_equalTo(@90);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.tableview.mas_right).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

#pragma mark - request networking
// 请求分类列表
- (void)requestForSortList {
    self.archKey = StringWithFomat2(@"GoodsCategoryArchKey", self.pid);
    
    if(self.task) [self.task cancel];
    if (!self.pid) {
        [CommonFunction showHUDIn:self text:@"参数错误"];
        return;
    }
    // type=1是商品分类，type=2是活动分类
    self.task = [AFNetWorkingTool getJSONWithUrl:IPSortList parameters:@{@"pid": self.pid, @"type": @"1"} progress:nil success:^(id responseObject) {
        if (self.pid.integerValue == 0) { // 一级分类
            self.sortlist = [[SortListModel alloc] initWithJson:responseObject];
            [self.tableview reloadData];
            [self getSortlistSuccess];
            [self saveDataWith:self.archKey];
            
        }else {
            self.typelist = [[SortListModel alloc] initWithJson:responseObject];
            [self updateUI];
            [self saveDataWith:sortlistArchKey];
        }
        
    } fail:nil];
}

- (void)getSortlistSuccess {
    if (self.sortlist.data.count > 0) {
        SortList *sortlist = self.sortlist.data[0];
        self.pid = sortlist.myId;
        [self requestForSortList];
    }else {
        [self updateUI];
    }
}

- (void)saveDataWith:(NSString *)key {
    BOOL isArch = [ArchiverHelper archiverModelWith:self.sortlist key:key];
    NSLog(@"isArch = %zd", isArch);
}

- (void)updateUI {
    [self.collectionView reloadData];
    if ([self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header endRefreshing];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.sortlist.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"SearchBarCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CategoryTableViewCell class]) owner:nil options:nil].firstObject;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.textLabel.font = FontSize(13);
        Cell.textLabel.textColor = RGBColor(128, 128, 128);
    }

    if (indexPath.row < self.sortlist.data.count) {
        SortList *sortlist = self.sortlist.data[indexPath.row];
        BOOL isSelected = NO;
        if (indexPath.row == self.selectedIndex) isSelected = YES;
        [Cell configigureCellWith:sortlist.name isSelected:isSelected];
    }

    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.tableview reloadData];
    
    if (indexPath.row < self.sortlist.data.count) {
        SortList *sortlist = self.sortlist.data[indexPath.row];
        self.pid = sortlist.myId;
        [self requestForSortList];
        
        [self.collectionView.mj_header beginRefreshing];
    }
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typelist.data.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell =
    (CategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.typelist.data.count) {
        SortList *sortlist = self.typelist.data[indexPath.row];
        cell.titleLabel.text = sortlist.name;
        [CommonFunction hk_setImage:sortlist.logo imgview:cell.imgview];
    }
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (ScreenWidth - 100) / 2;
    return CGSizeMake(width, 130);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.row);
    GoodListVC *vc = [GoodListVC new];
    if (indexPath.row < self.typelist.data.count) {
        SortList *sortlist = self.typelist.data[indexPath.row];
        vc.sortId = sortlist.myId;
        vc.navTitle = sortlist.name;
    }
    vc.type = @"1";
    [self pushViewController:vc];
}

@end
