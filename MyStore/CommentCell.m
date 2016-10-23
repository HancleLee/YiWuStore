//
//  CommentCell.m
//  MyStore
//
//  Created by Hancle on 16/10/16.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(Comment *)model {
    self.contentLabel.text = model.content;
    self.creatTimeLabel.text = [CommonFunction transformTimeStamp:[model.createTime doubleValue] andForm:@"yyyy-MM-dd"];
    self.nicknameLabel.text = model.nickname;
    [CommonFunction hk_setImage:model.avatar imgview:self.avatarImgview];
    NSArray *arr = @[self.star0, self.star1, self.star2, self.star3, self.star4];
    NSInteger index = [model.star integerValue];
    for (NSInteger i = 0; i < arr.count; i ++) {
        id item = arr[i];
        if ([item isKindOfClass:[UIImageView class]]) {
            UIImageView *star = item;
            if (i < index) {
                [star setImage:ImageNamed(@"stared")];
            }else {
                [star setImage:ImageNamed(@"unstar")];
            }
        }
    }
}

@end
