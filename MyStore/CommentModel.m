//
//  CommentModel.m
//  MyStore
//
//  Created by Hancle on 16/10/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CommentModel.h"

@implementation Comment

- (CGFloat)cellHeight {
    CGSize size = [CommonFunction getSizeForText:self.content font:FontSize(14.0) withConstrainedSize:CGSizeMake(ScreenWidth - 54 - 16, MAXFLOAT)];
    return size.height + 60 + 12;
}

@end

@implementation CommentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [Comment class]};
}

- (CommentModel *)addObjWith:(CommentModel *)model {
    CommentModel *sModel = model;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.data];
    for (id item in sModel.data) {
        [dataArr addObject:item];
    }
    sModel.data = dataArr;
    return sModel;
}

@end
