//
//  selectGoodTypeView.m
//  MyStore
//
//  Created by Hancle on 16/8/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SelectGoodTypeView.h"
#import "SelectGoodTypeCell.h"
#import "SelectGoodTypeHeaderView.h"

#define kCellReuseId @"SelectGoodTypeCellId"
#define kReuseViewId  @"SelectGoodTypeHeaderViewId"

@interface SelectGoodTypeView() <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic) CGRect tframe;
@property (nonatomic, strong) GoodsList *good;
@property (nonatomic, strong) NSArray *goodTagNameArr;

@end

@implementation SelectGoodTypeView

+ (SelectGoodTypeView *)customviewWith:(CGRect)frame {
    SelectGoodTypeView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    view.frame = frame;
    view.selectedDic = [NSMutableDictionary dictionary];
    [view creatUI];
    return view;
}

- (void)creatUI {
    self.backView.backgroundColor = MainBackColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //2.初始化collectionView
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tagsBackView.frame.size.height) collectionViewLayout:layout];
    self.mainCollectionView.allowsMultipleSelection = YES;
    self.mainCollectionView.backgroundColor = WhiteColor;
    [self.tagsBackView addSubview:self.mainCollectionView];
    
    //3.注册collectionViewCell
    [self.mainCollectionView registerClass:[SelectGoodTypeCell class] forCellWithReuseIdentifier:kCellReuseId];
    
    [self.mainCollectionView registerClass:[SelectGoodTypeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewId];
    
    //4.设置代理
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
}

- (void)configureWith:(GoodsList *)good {
    self.good = good;
    self.goodTagNameArr = good.tags.allKeys;
    
    for (id item in self.goodTagNameArr) {
        if ([item isKindOfClass:[NSString class]]) {
            id it = self.good.tags[item];
            if ([it isKindOfClass:[NSArray class]]) {
                NSArray *arr = it;
                if (arr.count > 0) {
                    NSString *str = arr[0];
                    [self.selectedDic setObject:str forKey:item];
                }
            }
        }
    }
    
    [CommonFunction hk_setImage:good.logoThumb imgview:self.imgview];

    self.nameLabel.text = good.name;
    self.priceLabel.text = PRICE_TEXT(good.curPrice);
    self.originPriceLabel.text = PRICE_TEXT(good.prePrice);
    [self.mainCollectionView reloadData];
}

- (IBAction)addBtnClick:(id)sender {
    NSInteger num = [self.numLabel.text integerValue];
    num ++;
    self.numLabel.text = [NSString stringWithFormat:@"%zd", num];
    
    [self dealDelegate];
}

- (IBAction)reduceBtnClick:(id)sender {
    
    NSInteger num = [self.numLabel.text integerValue];
    if (num == 1) {
        [CommonFunction showHUDIn:[CommonFunction topViewController] text:@"宝贝不能再少了哦～"];
        return;
    }
    if (num > 0)  num --;
    self.numLabel.text = [NSString stringWithFormat:@"%zd", num];
    
    [self dealDelegate];
}

- (IBAction)removeBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(removeBtnClick:btn:)]) {
        [self.delegate removeBtnClick:self btn:sender];
    }
}

- (void)dealDelegate {
    if ([self.delegate respondsToSelector:@selector(selectedGoodTypeWith:good:tags:num:)]) {
        [self.delegate selectedGoodTypeWith:self good:self.good tags:self.selectedDic num:self.numLabel.text];
    }
}

#pragma mark - collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.goodTagNameArr.count;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < self.goodTagNameArr.count) {
        id item = self.goodTagNameArr[section];
        if ([item isKindOfClass:[NSString class]]) {
            id it = self.good.tags[item];
            if ([it isKindOfClass:[NSArray class]]) {
                NSArray *arr = it;
                return arr.count;
            }
        }
    }
    return 0;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( 100, 30);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(18, 20, 18, 20);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 46);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SelectGoodTypeHeaderView *headerView = (SelectGoodTypeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewId forIndexPath:indexPath];
    if (indexPath.section < self.goodTagNameArr.count) {
        id item = self.goodTagNameArr[indexPath.section];
        if ([item isKindOfClass:[NSString class]]) {
            [headerView configureHeagerViewWith:item];
        }
    }
    
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectGoodTypeCell *cell = (SelectGoodTypeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId forIndexPath:indexPath];
    if (indexPath.section < self.goodTagNameArr.count) {
        id item = self.goodTagNameArr[indexPath.section];
        if ([item isKindOfClass:[NSString class]]) {
            id it = self.good.tags[item];
            if ([it isKindOfClass:[NSArray class]]) {
                NSArray *arr = it;
                if (indexPath.row < arr.count) {
                    NSString *str = arr[indexPath.row];
                    cell.titleLabel.text = str;
                    
                    NSString *selectedTag = self.selectedDic[item];
                    if ([selectedTag isEqualToString:str]) {
                        cell.titleLabel.textColor = WhiteColor;
                        cell.contentView.backgroundColor = MainRedColor;
                    }else {
                        cell.titleLabel.textColor = MainBlackColor;
                        cell.contentView.backgroundColor = WhiteColor;
                    }
                }
            }
        }
    }
    
    return cell;
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.goodTagNameArr.count) {
        id item = self.goodTagNameArr[indexPath.section];
        if ([item isKindOfClass:[NSString class]]) {
            id it = self.good.tags[item];
            if ([it isKindOfClass:[NSArray class]]) {
                NSArray *arr = it;
                if (indexPath.row < arr.count) {
                    NSString *str = arr[indexPath.row];
                    [self.selectedDic setObject:str forKey:item];
                    [self.mainCollectionView reloadData];
                }
            }
        }
    }
    [self dealDelegate];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
