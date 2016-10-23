//
//  HomeCollectionHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/8/3.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "HomeCollectionHeaderView.h"
#import "HKCarouseView.h"
#import "HomeHeaderViewCell.h"

static NSString *cellIdentifier = @"HomeCollectionHeaderViewCell";
static NSString *sectionFooterIdentifier = @"HomeCollectionFooterViewSectionView";

#define kSortCVTag 11   // 商品分类
#define kShopCVTag 12  // 商城商户

@interface HomeCollectionHeaderView() <HKCarouseViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bannerBackView;
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *shops;
@property (nonatomic, strong) NSArray *banners;

@end

@implementation HomeCollectionHeaderView
#pragma mark - getter
- (NSArray *)iconArr {
    return @[@"sort01", @"sort02", @"sort03", @"sort04", @"sort05"];
}

- (NSArray *)titleArr {
    return @[@"大聚惠", @"海外购", @"超市百货", @"厂家直销", @"美食娱乐"];
}

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

#pragma mark - configuration
- (void)configureWith:(HomeModel *)model {
    self.shops = model.data.shop;
    self.banners = model.data.banner;
    [self.shopCollectionView reloadData];
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (id item in model.data.banner) {
        if ([item isKindOfClass:[Banner class]]) {
            Banner *banner = item;
            if (Is_Url(banner.logo)) {
                [imgs addObject:banner.logo];
            }else {
                [imgs addObject:URL_PIC(banner.logo)];
            }
        }
    }
    HKCarouseView *carouseView = [HKCarouseView carouseViewWith:CGRectMake(0, 0, ScreenWidth, 160) images:imgs];
    carouseView.backgroundColor = MainBackColor;
    carouseView.delegate = self;
    [self.bannerBackView addSubview:carouseView];
}

#pragma mark - creat UI
- (void)creatUI {
    self.backgroundColor = WhiteColor;
    self.bannerBackView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    self.bannerBackView.backgroundColor = MainBackColor;
    [self addSubview:self.bannerBackView];
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    self.sortCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout1];
    self.sortCollectionView.backgroundColor = WhiteColor;
    self.sortCollectionView.tag = kSortCVTag;
    self.sortCollectionView.showsHorizontalScrollIndicator = NO;
    self.sortCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.sortCollectionView];
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.shopCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout2];
    self.shopCollectionView.backgroundColor = WhiteColor;
    self.shopCollectionView.tag = kShopCVTag;
    self.shopCollectionView.showsHorizontalScrollIndicator = NO;
    self.shopCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.shopCollectionView];
    
    [self.sortCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.bannerBackView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@136);
    }];
    [self.shopCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.sortCollectionView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self.sortCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeHeaderViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    [self.sortCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterIdentifier];

    [self.shopCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeHeaderViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    
    self.sortCollectionView.dataSource = self;
    self.sortCollectionView.delegate = self;
    
    self.shopCollectionView.dataSource = self;
    self.shopCollectionView.delegate = self;
}

#pragma mark - HKCarouseViewDelegate
- (void)selectedAdViewAtIndex:(NSInteger)index view:(HKCarouseView *)view {
    NSLog(@"%s  %zd",__func__,index);
    if (index < self.banners.count) {
        id item = self.banners[index];
        if ([item isKindOfClass:[Banner class]]) {
            Banner *banner = item;
            if ([self.delegate respondsToSelector:@selector(carouseViewAt:banner:)]) {
                [self.delegate carouseViewAt:index banner:banner];
            }
        }
    }
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == kSortCVTag) {
        return 5;
    }else {
        return self.shops.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (collectionView.tag == kShopCVTag) {
        return CGSizeZero;

    }else {
        return CGSizeMake(ScreenWidth, 40);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == kSortCVTag) {
        UICollectionReusableView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterIdentifier forIndexPath:indexPath];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
        lineView.backgroundColor = RGBColor(243, 243, 243);
        [sectionView addSubview:lineView];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.frame.size.height, ScreenWidth, 40 - lineView.frame.size.height)];
        titleView.backgroundColor = WhiteColor;
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, titleView.frame.size.height)];
        titleLable.font = FontSize(15);
        titleLable.text = @"商城商户";
        titleLable.textColor = SectionTitleColor;
        [titleView addSubview:titleLable];
        [sectionView addSubview:titleView];
        titleView.backgroundColor = WhiteColor;
        return sectionView;
    }else {
        return [UICollectionReusableView new];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeHeaderViewCell *cell =
    (HomeHeaderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (collectionView.tag == kSortCVTag) {
        if (indexPath.row < self.iconArr.count) {
            UIImage *icon = ImageNamed(self.iconArr[indexPath.row]);
            [cell configureWithSize:CGSizeMake(40, 40) icon:icon title:self.titleArr[indexPath.row] fontSize:12.0];
        }
        
    }else {
        if (indexPath.row < self.shops.count) {
            id item = self.shops[indexPath.row];
            if ([item isKindOfClass:[Store class]]) {
                Store *shop = item;
                if (Is_Url(shop.logo)) {
                    [cell configureWithSize:CGSizeMake(75, 75) icon:shop.logo title:shop.name fontSize:14.0];
                }else {
                    [cell configureWithSize:CGSizeMake(75, 75) icon:URL_PIC(shop.logo) title:shop.name fontSize:14.0];
                }
            }
        }
    }
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == kSortCVTag) {
        CGFloat width = 60;
        if (ScreenWidth < 375) {
            width = 50;
        }
        return CGSizeMake(width, 70);
        
    }else {
        return CGSizeMake(80, 105);
    }
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == kSortCVTag) {
        CGFloat offset = 15;
        if (ScreenWidth < 375) {
            offset = 10;
        }
        return UIEdgeInsetsMake(5, offset, offset, offset);
    }
    return UIEdgeInsetsMake(5, 15, 10, 15);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(headerView:selectedAtSection:row:shop:)]) {
        NSInteger section = 0;
        if (collectionView.tag == kShopCVTag) {
            section =1;
            if (indexPath.row < self.shops.count) {
                id item = self.shops[indexPath.row];
                if ([item isKindOfClass:[Store class]]) {
                    Store *shop = item;
                    [self.delegate headerView:self selectedAtSection:section row:indexPath.row shop:shop];
                }
            }

        }else {
            [self.delegate headerView:self selectedAtSection:section row:indexPath.row shop:nil];
        }
    }
}

@end
