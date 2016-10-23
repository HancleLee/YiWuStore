//
//  SocialList.m
//  MyStore
//
//  Created by Hancle on 16/8/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SocialListModel.h"

@implementation SocialList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"thumbList" : [NSString class], @"imageList" : [NSString class]};
}

- (NSString *)timeStr {
    return [CommonFunction transformTimeStamp:[self.createTime doubleValue] andForm:@"MM-dd HH:mm"];
}

+ (CGFloat)collectionCellWH {
    return (ScreenWidth - 44.0) / 3;
}

+ (CGFloat)collectionViewHeightWith:(SocialList *)model {
    CGFloat imgviewWH = [self collectionCellWH];
    CGFloat offset = 12.0;
    CGFloat viewHeight = (imgviewWH + offset) * (((model.thumbList.count - 1) / 3) + 1);
    return viewHeight;
}

+ (CGFloat)contentHeightWith:(SocialList *)model {
    CGFloat off = 26.0;
    CGSize size = [CommonFunction getSizeForText:model.details font:FontSize(14.0) withConstrainedSize:CGSizeMake(ScreenWidth - off, MAXFLOAT)];
    return size.height + 5;
}

+ (CGFloat)cellHeightWith:(SocialList *)model {
    CGFloat others = 53.0 + 60.0;
    return others + [self contentHeightWith:model] + [self collectionViewHeightWith:model];
}

@end

@implementation SocialListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [SocialList class]};
}

- (SocialListModel *)addObjWith:(SocialListModel *)model {
    SocialListModel *sModel = model;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.data];
    for (id item in sModel.data) {
        [dataArr addObject:item];
    }
    sModel.data = dataArr;
    return sModel;
}

@end
