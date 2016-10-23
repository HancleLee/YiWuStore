//
//  SocialCell.h
//  MyStore
//
//  Created by Hancle on 16/8/6.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialListModel.h"

@protocol SocialCellDelegate <NSObject>

- (void)selectedAtIndex:(NSInteger)index pics:(NSArray *)pics;
- (void)shareWith:(SocialList *)model;

@end

@interface SocialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picsBackViewHeightConstaint;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgview;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *picsBackView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@property (nonatomic, assign) id<SocialCellDelegate> delegate;
- (void)configureWith:(SocialList *)model;

@end
