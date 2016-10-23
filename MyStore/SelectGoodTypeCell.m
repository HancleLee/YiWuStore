//
//  SelectGoodTypeCell.m
//  MyStore
//
//  Created by Hancle on 16/9/11.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SelectGoodTypeCell.h"

@implementation SelectGoodTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
        
        self.layer.cornerRadius = 2;
        self.layer.borderColor = RGBColor(237, 237, 237).CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}

@end
