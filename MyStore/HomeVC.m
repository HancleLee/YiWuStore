//
//  HomeVC.m
//  MyStore
//
//  Created by Hancle on 16/7/9.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "HomeVC.h"
#import "HomeCollectionHeaderView.h"
#import "HomeCollectionCell.h"
#import "LoginHelper.h"
#import "HomeModel.h"
#import "SearchVC.h"
#import "GoodsCategoryVC.h"
#import "SaleActivityVC.h"
#import "StoreVC.h"
#import "GoodsDetailVC.h"
#import "GoodsListModel.h"
#import "GoodListVC.h"

static NSString *cellIdentifier             = @"HomeCollectionCell";
static NSString *headerViewIdentifier       = @"HomeCollectionHeaderView";
static NSString *sectionHeaderIdentifier    = @"HomeCollectionSectionHeaderView";
static NSString *archKey                    = @"HomeVCArchKey";

@interface HomeVC ()
            <UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout,
            HomeCollectionHeaderViewDelegate>

@property (nonatomic, strong)   UICollectionView        *mainCollectioView;
@property (nonatomic, copy)     NSString                *token;
@property (nonatomic, strong)   HomeModel               *model;
@property (nonatomic, strong)   NSURLSessionDataTask    *task;

@end

@implementation HomeVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationItem setTitle:@"义乌商城"];
    [self creatUI];
    
    self.mainCollectioView.mj_header = [MJRefreshHeader mjRefreshHeaderWith:^{
        [self requestForHomePage];
    }];
    [self.mainCollectioView.mj_header beginRefreshing];
    
    // load cache
    self.model = [ArchiverHelper unarchiverModelWith:self.model key:archKey];
    if (self.model) {
        [self updateUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request networking
- (void)requestForHomePage {
    if (self.task) [self.task cancel];
    
    self.task = [AFNetWorkingTool getJSONWithUrl:IPHomePage parameters:nil  progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.model = [[HomeModel alloc] initWithJson:responseObject];
        if (self.model.code == 0) {
            [self updateUI];
            [self cacheData];
            [self.mainCollectioView.mj_header endRefreshing];
            
        }else {
            [CommonFunction showHUDIn:self text:self.model.msg];
        }
        
    } fail:nil];
}

#pragma mark - UI
/**
 *  creat UI
 */
- (void)creatUI {
    self.view.backgroundColor = MainBackColor;

    // left item
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"leftItem") style:UIBarButtonItemStylePlain target:self action:@selector(leftItemBtnClick:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"search") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemBtnClick:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollectioView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.mainCollectioView.backgroundColor = WhiteColor;
    [self.view addSubview:self.mainCollectioView];
    
    [self.mainCollectioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self.mainCollectioView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    [self.mainCollectioView registerClass:[HomeCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [self.mainCollectioView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier];
    
    self.mainCollectioView.dataSource = self;
    self.mainCollectioView.delegate = self;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
        
    }else {
        return self.model.data.promotion.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 400);
    }else {
        return CGSizeMake(ScreenWidth, 40);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        headerView.delegate = self;
        [headerView configureWith:self.model];
        
        return headerView;
        
    }else {
        UICollectionReusableView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier forIndexPath:indexPath];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
        lineView.backgroundColor = RGBColor(243, 243, 243);
        [sectionView addSubview:lineView];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.frame.size.height, ScreenWidth, 40 - lineView.frame.size.height)];
        titleView.backgroundColor = WhiteColor;
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, titleView.frame.size.height)];
        titleLable.font = FontSize(15);
        titleLable.text = @"精选促销";
        titleLable.textColor = SectionTitleColor;
        [titleView addSubview:titleLable];
        [sectionView addSubview:titleView];
        return sectionView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell =
    (HomeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = GrayColor;
    if (indexPath.row < self.model.data.promotion.count) {
        id item = self.model.data.promotion[indexPath.row];
        if ([item isKindOfClass:[GoodsList class]]) {
            [cell configureCellWith:item];
        }
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
    if (section == 0) {
        return UIEdgeInsetsZero;
    }else {
        return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
    }
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//每个item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 100;
//}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailVC *vc = [GoodsDetailVC new];
    if (indexPath.row < self.model.data.promotion.count) {
        id item = self.model.data.promotion[indexPath.row];
        if ([item isKindOfClass:[GoodsList class]]) {
            vc.good = item;
        }
    }
    [self pushViewControllerNoAnimation:vc];
}

#pragma mark - HomeCollectionHeaderViewDelegate
- (void)headerView:(HomeCollectionHeaderView *)headerView selectedAtSection:(NSInteger)section row:(NSInteger)row shop:(Store *)shop {
    NSLog(@"section - %zd row--%zd",section, row);
    if (section == 0) { // 促销活动部分
        NSArray *titles = @[@"大聚惠", @"海外购", @"超市百货", @"厂家直销", @"美食娱乐"];
        SaleActivityVC *vc = [SaleActivityVC new];
        vc.navTitle = titles[row];
        if (row < self.model.data.tags.count) {
            SortListModel *tag = self.model.data.tags[row];
            vc.sortlist = tag;
        }
        [self pushViewController:vc];
        
    }else { // 商户部分
        StoreVC *vc =[StoreVC new];
        vc.shop = shop;
        [self pushViewControllerNoAnimation:vc];
    }
}

- (void)carouseViewAt:(NSInteger)index banner:(Banner *)banner {
    GoodListVC *vc = [GoodListVC new];
    vc.sortId = banner.sortId;
    vc.navTitle = banner.title;
    vc.type = @"2";
    [self pushViewController:vc];
}

#pragma mark - private
- (void)leftItemBtnClick:(UIBarButtonItem *)item {
    NSLog(@"left item button click");
    GoodsCategoryVC *vc = [GoodsCategoryVC new];
    [self pushViewController:vc];
}

- (void)rightItemBtnClick:(UIBarButtonItem *)item {
    NSLog(@"right item button click");
    SearchVC *vc = [SearchVC new];
    [self pushViewController:vc];
}

// cache data
- (void)cacheData {
    if (self.model) [ArchiverHelper archiverModelWith:self.model key:archKey];
}

- (void)updateUI {
    [self.mainCollectioView reloadData];
}

@end
