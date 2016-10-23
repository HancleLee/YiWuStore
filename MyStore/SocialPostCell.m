//
//  SocialPostCell.m
//  MyStore
//
//  Created by Hancle on 16/8/7.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SocialPostCell.h"

@implementation SocialPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    }
    return self;
}

@end
