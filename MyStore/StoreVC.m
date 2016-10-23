//
//  StoreVC.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "StoreVC.h"
#import "StoreHeaderView.h"
#import "HomeCollectionCell.h"
#import "GoodsDetailVC.h"
#import "StoreModel.h"
#import "GoodsListModel.h"

static NSString *cellIdentifier = @"StoreCell";
static NSString *headerIdentifier = @"StoreHeaderView";

@interface StoreVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) StoreHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *mainCollectioView;
@property (nonatomic, strong) NSURLSessionDataTask *shopTask;
@property (nonatomic, strong) NSURLSessionDataTask *goodTask;
@property (nonatomic, strong) GoodsListModel *goodModel;
@property (nonatomic, strong) StoreModel *shopModel;
@property (nonatomic, copy) NSString *index;

@end

@implementation StoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.index = @"0";
    [self creatUI];
    
    if (self.shop) self.shopId = self.shop.shopId;
    if (self.shopId) {
        [self requestForShopInfoWith:@{@"shopId": self.shopId}];
        
        self.mainCollectioView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
            [self.goodTask cancel];
            self.index = @"0";
            [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"shopId": self.shopId}];
        }];
        self.mainCollectioView.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
            [self.goodTask cancel];
            self.index = [NSString stringWithFormat:@"%zd", self.goodModel.data.count];
            [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"shopId": self.shopId}];
        }];
        [self.mainCollectioView.mj_header beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar nav_setBackgroundColor:RGBColor_a(1, 1, 1, 0)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar nav_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.shopTask) [self.shopTask cancel];
    if (self.goodTask) [self.goodTask cancel];
}

#pragma mark - request networking
- (void)requestForShopInfoWith:(NSDictionary *)paraDic {
    self.shopTask = [AFNetWorkingTool getJSONWithUrl:IPShopInfo parameters:paraDic progress:nil success:^(id responseObject) {
        self.shopModel = [[StoreModel alloc] initWithJson:responseObject];
        self.shop = self.shopModel.data;
        [self updateUI];
        
    } fail:nil];
}

- (void)requestForGoodsListWith:(NSDictionary *)paraDic {
    self.goodTask = [AFNetWorkingTool getJSONWithUrl:IPGoodsInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        GoodsListModel *goodModel = [[GoodsListModel alloc] initWithJson:responseObject];
        [self endrefreshingWith:(goodModel.data.count == REQUEST_DATA_COUNT.integerValue ? NO : YES)];
        if (self.index.integerValue > 0) {
            self.goodModel = [self.goodModel addObjWith:goodModel];
            
        }else {
            self.goodModel = goodModel;
        }
        [self.mainCollectioView reloadData];
        
    } fail:nil];
}

#pragma mark - UI
/**
 *  creat UI
 */
- (void)creatUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = MainBackColor;
    
    self.headerView = [[StoreHeaderView alloc] init];
    if(self.shop) [self.headerView configureWith:self.shop];
    [self.view addSubview:self.headerView];
    
    CGFloat height = (384 / 750.0) * ScreenWidth + 42.0;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.height.mas_equalTo(height);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollectioView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.mainCollectioView.backgroundColor = MainBackColor;
    [self.view addSubview:self.mainCollectioView];
    
    [self.mainCollectioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.headerView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self.mainCollectioView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
//    [self.mainCollectioView registerNib:[UINib nibWithNibName:NSStringFromClass([StoreHeaderView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    self.mainCollectioView.dataSource = self;
    self.mainCollectioView.delegate = self;
}

- (void)updateUI {
    [self.headerView configureWith:self.shop];
    [self.mainCollectioView reloadData];
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

#pragma mark - UICollectionViewDelegate/UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodModel.data.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    CGFloat height = (384 / 750.0) * ScreenWidth + 42.0;
//    return CGSizeMake(ScreenWidth, height);
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    StoreHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
//    [headerView configureWith:self.shop];
//    
//    return headerView;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell =
    (HomeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = GrayColor;
    if (indexPath.row < self.goodModel.data.count) {
        GoodsList *good = self.goodModel.data[indexPath.row];
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
    if (indexPath.row < self.goodModel.data.count) {
        vc.good = self.goodModel.data[indexPath.row];
    }
    [self pushViewControllerNoAnimation:vc];
}

@end
