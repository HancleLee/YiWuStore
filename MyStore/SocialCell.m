//
//  SocialCell.m
//  MyStore
//
//  Created by Hancle on 16/8/6.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SocialCell.h"

static NSString *cellIdentifier = @"cellidentifier";

@interface SocialCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SocialList *model;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat imgviewWH;

@end

@implementation SocialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImgview.layer.cornerRadius = CGRectGetHeight(self.avatarImgview.frame) / 2;
    self.avatarImgview.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWith:(SocialList *)model {
    self.model = model;
    [CommonFunction hk_setImage:model.avatar imgview:self.avatarImgview];

    self.nicknameLabel.text = model.nickname;
    self.contentLabel.text = model.details;
    self.timeLabel.text = model.timeStr;

    [self updateUI];
}

- (void)updateUI {
    self.contentHeightConstraint.constant = [SocialList contentHeightWith:self.model];
    
    NSLog(@"== %.f = %.f", [SocialList contentHeightWith:self.model], ScreenWidth - self.contentLabel.frame.size.width);
    
    CGFloat viewHeight = [SocialList collectionViewHeightWith:self.model];
    self.picsBackViewHeightConstaint.constant = viewHeight;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = WhiteColor;
    [self.picsBackView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDatasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.thumbList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = GrayColor;
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    if (indexPath.row < self.model.thumbList.count) {
        NSString *img = self.model.thumbList[indexPath.row];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        [CommonFunction hk_setImage:img imgview:imgview];

        [cell.contentView addSubview:imgview];
    }
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat imgviewWH = [SocialList collectionCellWH];
    return CGSizeMake(imgviewWH, imgviewWH);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 12, 5, 12);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectedAtIndex:pics:)]) {
        [self.delegate selectedAtIndex:indexPath.row pics:self.model.imageList];
    }
}

#pragma mark - share button click
- (IBAction)shareBtnClick:(id)sender {
    NSLog(@"share buttn click");
    if ([self.delegate respondsToSelector:@selector(shareWith:)]) {
        [self.delegate shareWith:self.model];
    }
}

@end
