//
//  MeHeaderView.h
//  MyStore
//
//  Created by Hancle on 16/8/8.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"
#import "User.h"

@protocol MeHeaderViewDelegate <NSObject>

- (void)myOrderButtonClickAt:(NSInteger)index;
- (void)myAvatarBtnClick;

@end

@interface MeHeaderView : SuperView

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

+ (MeHeaderView *)initHeaderView;

@property (nonatomic, assign) id<MeHeaderViewDelegate> delegate;
- (void)configureViewWith:(User *)user;

@end
