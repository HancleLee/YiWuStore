//
//  PhotoBroswerHelper.m
//  QiCheng51
//
//  Created by Hancle on 16/8/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "PhotoBroswerHelper.h"

@interface PhotoBroswerHelper() <MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *photos;

@end

@implementation PhotoBroswerHelper

+ (PhotoBroswerHelper *)pushphotoBroswerInVC:(UIViewController *)vc photos:(NSArray *)photos currentIndex:(NSUInteger)index {
    PhotoBroswerHelper *broswerHelper = [[PhotoBroswerHelper alloc] init];
    if (broswerHelper) {
        NSMutableArray *photosArr = [NSMutableArray array];
        for (int i = 0; i < photos.count; i ++) {
            id item = photos[i];
            MWPhoto *photo = [MWPhoto new];
            if ([item isKindOfClass:[UIImage class]]) {
                UIImage *img = item;
                photo = [MWPhoto photoWithImage:img];
            }else if ([item isKindOfClass:[NSString class]]) {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:item]];
            }
            [photosArr addObject:photo];
        }
        broswerHelper.photos = photosArr;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photosArr];
        browser.delegate = broswerHelper;
        browser.displayNavArrows = YES;
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        browser.displayActionButton = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = YES;
        browser.enableGrid = NO;
        browser.enableSwipeToDismiss = YES;
        browser.autoPlayOnAppear = YES;

        //设置当前要显示的图片
        [browser setCurrentPhotoIndex:index];
        if ([vc.navigationController respondsToSelector:@selector(pushViewController:animated:)]) {
            [vc.navigationController pushViewController:browser animated:YES];
        }
    }
    return broswerHelper;
}

//返回图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}

//返回图片模型
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    //创建图片模型
    id item = self.photos[index];
    if ([item isKindOfClass:[MWPhoto class]]) {
        MWPhoto *photo = item;
        return photo;
    }else {
        return [[MWPhoto alloc] init];;
    }
}

@end
