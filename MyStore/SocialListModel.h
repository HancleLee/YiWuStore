//
//  SocialList.h
//  MyStore
//
//  Created by Hancle on 16/8/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"

@interface SocialList : SuperModel

@property (nonatomic, copy) NSString * communityId;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSArray * imageList;
@property (nonatomic, copy) NSArray * thumbList;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * thumbAvatar;

@property (nonatomic, copy) NSString *timeStr;
+ (CGFloat)collectionViewHeightWith:(SocialList *)model;
+ (CGFloat)contentHeightWith:(SocialList *)model;
+ (CGFloat)cellHeightWith:(SocialList *)model;
+ (CGFloat)collectionCellWH;

@end

@interface SocialListModel : SuperModel

@property (nonatomic, strong) NSArray *data;

- (SocialListModel *)addObjWith:(SocialListModel *)model;

@end
