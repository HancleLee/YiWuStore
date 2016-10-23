//
//  CommentModel.h
//  MyStore
//
//  Created by Hancle on 16/10/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface Comment : SuperModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;

- (CGFloat)cellHeight;

@end

@interface CommentModel : SuperModel

@property (nonatomic, copy) NSArray *data;
- (CommentModel *)addObjWith:(CommentModel *)model;

@end
