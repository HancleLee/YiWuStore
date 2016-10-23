//
//  MessageListModel.h
//  MyStore
//
//  Created by Hancle on 16/10/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface MessageList : SuperModel

@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;

- (CGFloat)cellHeight;

@end

@interface MessageListModel : SuperModel

@property (nonatomic, copy) NSArray *data;
- (MessageListModel *)addObjWith:(MessageListModel *)model;

@end
