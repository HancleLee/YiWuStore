//
//  GoodListVC.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodListVC.h"
#import "HomeCollectionCell.h"
#import "GoodsDetailVC.h"

static NSString *cellIdentifier = @"StoreCell";

@interface GoodListVC ()
            <UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectioView;
@property (nonatomic, strong) GoodsListModel *model;
@property (nonatomic, copy)   NSString *index;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation GoodListVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:self.navTitle];
    self.index = @"0";
    
    [self creatUI];
    
    self.mainCollectioView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        self.index = @"0";
        if (self.sortId) {
            [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"sortId":self.sortId, @"type":self.type}];
        }
    }];
    self.mainCollectioView.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
        self.index = [NSString stringWithFormat:@"%zd", self.model.data.count];
        if (self.sortId) {
            [self requestForGoodsListWith:@{@"index":self.index, @"size":REQUEST_DATA_COUNT, @"sortId":self.sortId, @"type":self.type}];
        }
    }];
    [self.mainCollectioView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.task) [self.task cancel];
}

#pragma mark - request networking
- (void)requestForGoodsListWith:(NSDictionary *)paraDic {
    if (self.task) [self.task cancel];

    self.task = [AFNetWorkingTool getJSONWithUrl:IPGoodsInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        GoodsListModel *model = [[GoodsListModel alloc] initWithJson:responseObject];
        [self endrefreshingWith:(model.data.count == REQUEST_DATA_COUNT.integerValue ? NO : YES)];
        if (self.index.integerValue > 0) {
            self.model = [self.model addObjWith:model];
        }else {
            self.model = model;
        }
        [self.mainCollectioView reloadData];
        
    } fail:nil];
}

#pragma mark - UI
/**
 *  creat UI
 */

- (void)creatUI {
    self.view.backgroundColor = MainBackColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollectioView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.mainCollectioView.backgroundColor = MainBackColor;
    [self.view addSubview:self.mainCollectioView];
    
    [self.mainCollectioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self.mainCollectioView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    
    self.mainCollectioView.dataSource = self;
    self.mainCollectioView.delegate = self;
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
        GoodsList *goodlist = self.model.data[indexPath.row];
        [cell configureCellWith:goodlist];
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
        GoodsList *goodlist = self.model.data[indexPath.row];
        vc.good = goodlist;
    }
    [self pushViewControllerNoAnimation:vc];
}

@end
