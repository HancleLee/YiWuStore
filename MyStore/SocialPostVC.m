//
//  SocialPostVC.m
//  MyStore
//
//  Created by Hancle on 16/8/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SocialPostVC.h"
#import "SocialPostCell.h"
#import "SocialPostHeaderView.h"
#import "ZLPhoto.h"
#import "SocialPostModel.h"

static NSString *kCellId = @"SocialPostCellId";
static NSString *kHeaderViewId = @"SocialPostHeaderViewId";
static NSString *kFooterViewId = @"SocialPostFooterViewId";

@interface SocialPostVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZLPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) SocialPostHeaderView *headerView;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, assign) BOOL isUploading;

@end

@implementation SocialPostVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"分享"];
    self.isUploading = NO;
    
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.task cancel];
}

#pragma mark - UI
- (void)creatUI {
    self.rightItemBtnTitle = @"提交";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.mainCollectionView.backgroundColor = WhiteColor;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.scrollEnabled = NO;
    [self.view addSubview:self.mainCollectionView];
    
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.mainCollectionView registerClass:[SocialPostCell class] forCellWithReuseIdentifier:kCellId];
    [self.mainCollectionView registerClass:[SocialPostHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewId];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewId];
}

#pragma mark - request network
- (void)requestForPublishWith:(NSDictionary *)paraDic {
    self.isUploading = YES;
    [CommonFunction showHUDIn:self];
    NSMutableArray *pics = [NSMutableArray array];
    for (id item in self.assets) {
        if ([item isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *asset = item;
            [pics addObject:asset.originImage];
        }
    }
    self.task = [AFNetWorkingTool postFileWithUrl:IPComPublish parameters:paraDic files:pics progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SocialPostModel *model = [[SocialPostModel alloc] initWithJson:responseObject];
        if (model.code == 0) {
            [CommonFunction showSuccessHUDIn:self];
        }else {
            [CommonFunction showHUDIn:self text:model.msg];
        }
        self.isUploading = NO;
        
    } fail:^(NSError *error) {
        self.isUploading = NO;
        [CommonFunction showHUDIn:self text:RequestFailTipText];
    }];
}

#pragma mark - private

- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem {
    NSLog(@"right item button click!!");
    [self.view endEditing:YES];
    if (!self.isUploading) {
        NSString *content = self.headerView.textView.text;
        if ([content isEqualToString:@""]) {
            [CommonFunction showHUDIn:self text:@"内容不能为空" hideTime:2 completion:nil];
            return;
        }
        NSString *token = TOKEN;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:content forKey:@"details"];
        if (token != nil) {
            [paraDic setObject:token forKey:@"token"];
        }
        [self requestForPublishWith:paraDic];
    }
}

/**
 *  从相册选择图片
 */
- (void)takePictures {
    // 创建图片多选控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusSavePhotos;
    pickerVc.maxCount = 9;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
    if (self.assets.count > 0) {
        pickerVc.selectPickers = self.assets;
    }
}

// ZLPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    self.assets = [NSMutableArray arrayWithArray:assets];
    [self.mainCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count + 1;
}

// 设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat rightOffset = 20.0;
    return UIEdgeInsetsMake(10, 20, 10, rightOffset);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 155);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, ScreenHeight - 240 - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWH = (ScreenWidth - 40) / 4 - 5;
    return CGSizeMake(itemWH, itemWH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        self.headerView = (SocialPostHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderViewId forIndexPath:indexPath];
        
        return self.headerView;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterViewId forIndexPath:indexPath];
        footerView.backgroundColor = MainBackColor;
        
        return footerView;
        
    }else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SocialPostCell *cell = (SocialPostCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    if (indexPath.row == self.assets.count) {
        [cell.imgView setImage:ImageNamed(@"postAdd")];
    }else if(indexPath.row < self.assets.count){
        id item = self.assets[indexPath.row];
        if ([item isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *asset = item;
            [cell.imgView setImage:asset.thumbImage];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.assets.count) {
        [self takePictures];
    }
}

@end
