//
//  SaleActivityVC.m
//  MyStore
//
//  Created by Hancle on 16/8/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SaleActivityVC.h"
#import "HomeCollectionCell.h"
#import "SaleActivityHeaderView.h"
#import "GoodsDetailVC.h"
#import "GoodsListModel.h"

static NSString *cellIdentifier = @"SaleactivityCell";

@interface SaleActivityVC ()
            <UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout,
            SaleActivityHeaderViewDelegate>

@property (nonatomic, strong) UICollectionView          *mainCollectioView;
@property (nonatomic, strong) SaleActivityHeaderView    *headerview;
@property (nonatomic, copy)   NSString                  *index;
@property (nonatomic, strong) NSURLSessionTask          *task;
@property (nonatomic, strong) NSURLSessionTask          *typesTask;
@property (nonatomic, strong) GoodsListModel            *model;
@property (nonatomic, copy)   NSString                  *sortId;
@property (nonatomic, copy)   NSString                  *archKey;  // 数据缓存key

@end

@implementation SaleActivityVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:self.navTitle];
    
    self.index = @"0";
    
    [self creatUI];
    [self.headerview configureHeaderviewWith:self.sortlist.data];
    
    if (self.sortlist.data.count > 0) {
        SortList *sort = self.sortlist.data[0];
        self.sortId = sort.myId;
        
        [self reloadByLoadCache];

        self.mainCollectioView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
            self.index = @"0";
            [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"sortId": self.sortId, @"type": @"2"}];
        }];
        [self.mainCollectioView.mj_header beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request networking
- (void)requestForGoodsListWith:(NSDictionary *)paraDic {
    if (self.task) [self.task cancel];
    self.archKey = StringWithFomat2(@"SaleActivityArchKey", self.sortId); // 设置缓冲key
    
    self.task = [AFNetWorkingTool getJSONWithUrl:IPGoodsInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        GoodsListModel *model = [[GoodsListModel alloc] initWithJson:responseObject];
        [self endrefreshingWith:(model.data.count == REQUEST_DATA_COUNT.integerValue ? NO : YES)];
        if (self.index.integerValue > 0) {
            self.model = [self.model addObjWith:model];
        }else {
            self.model = model;
        }
        [self updateUI];
        [self saveDataWith:self.archKey];
        
    } fail:nil];
}

- (void)saveDataWith:(NSString *)key {
    BOOL isArch = [ArchiverHelper archiverModelWith:self.model key:self.archKey];
    NSLog(@"isArch = %zd", isArch);
}

#pragma mark - UI
/**
 *  creat UI
 */
- (void)creatUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = MainBackColor;
    
    self.headerview = [[SaleActivityHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.headerview.delegate = self;
    [self.view addSubview:self.headerview];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollectioView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.mainCollectioView.backgroundColor = MainBackColor;
    [self.view addSubview:self.mainCollectioView];
    
    [self.mainCollectioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.headerview.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self.mainCollectioView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    
    self.mainCollectioView.dataSource = self;
    self.mainCollectioView.delegate = self;
}

- (void)updateUI {
    [self.mainCollectioView reloadData];
    
    if (!self.mainCollectioView.mj_footer) {
        self.mainCollectioView.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
            self.index = [NSString stringWithFormat:@"%zd", self.model.data.count];
            [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"sortId": self.sortId}];
        }];
    }
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.data.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell =
    (HomeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = GrayColor;
    if (indexPath.row < self.model.data.count) {
        GoodsList *good = self.model.data[indexPath.row];
        [cell configureCellWith:good];
    }
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (ScreenWidth - 44) / 2;
    return CGSizeMake(width, width + 55);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailVC *vc = [GoodsDetailVC new];
    if (indexPath.row < self.model.data.count) {
        vc.good = self.model.data[indexPath.row];
    }
    [self pushViewControllerNoAnimation:vc];
}

#pragma mark - SaleActivityHeaderViewDelegate
- (void)selectedAt:(NSString *)pid title:(NSString *)title {
    self.sortId = pid;
    self.index = @"0";
    [self reloadByLoadCache];
    if ([self.mainCollectioView.mj_header isRefreshing]) {
        [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"sortId": self.sortId, @"type": @"2"}];
        
    }else {
        [self.mainCollectioView.mj_header beginRefreshing];
    }
}

#pragma mark - private
/**
 *  停止刷新tableview
 *
 *  @param isNoMoreData 是否加载完全
 */
- (void)endrefreshingWith:(BOOL)isNoMoreData {
    if (isNoMoreData) {
        [self.mainCollectioView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.mainCollectioView.mj_footer endRefreshing];
    }
    [self.mainCollectioView.mj_header endRefreshing];
}

- (void)reloadByLoadCache {
    self.archKey = StringWithFomat2(@"SaleActivityArchKey", self.sortId);
    self.model = [ArchiverHelper unarchiverModelWith:self.model key:self.archKey];
    if (self.model) {
        [self.mainCollectioView reloadData];
    }
}

@end
