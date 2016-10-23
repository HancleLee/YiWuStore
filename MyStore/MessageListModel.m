//
//  MessageListModel.m
//  MyStore
//
//  Created by Hancle on 16/10/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageList

- (CGFloat)cellHeight {
    if (self.content) {
        CGSize size = [CommonFunction getSizeForText:self.content font:FontSize(14.0) withConstrainedSize:CGSizeMake(ScreenWidth - 75, MAXFLOAT)];
        return size.height + 120.0;
    }
    return 0.0;
}

@end

@implementation MessageListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MessageList class]};
}

- (MessageListModel *)addObjWith:(MessageListModel *)model {
    MessageListModel *sModel = model;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:self.data];
    for (id item in sModel.data) {
        [dataArr addObject:item];
    }
    sModel.data = dataArr;
    return sModel;
}

@end
