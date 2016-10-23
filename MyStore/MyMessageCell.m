//
//  MyMessageCell.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MyMessageCell.h"

@implementation MyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentBackView.layer.cornerRadius = 5.0;
    self.contentBackView.layer.borderColor = RGBColor(230, 230, 230).CGColor;
    self.contentBackView.layer.borderWidth = 1.0;
    self.timeLabel.layer.cornerRadius = 2.0;
    self.timeLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(MessageList *)msg {
    self.titleLabel.text = msg.title;
    self.contentLabel.text = msg.content;
    NSString *time = [CommonFunction transformTimeStamp:[msg.createTime doubleValue] andForm:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = [NSString stringWithFormat:@" %@ ", time];
}

@end
