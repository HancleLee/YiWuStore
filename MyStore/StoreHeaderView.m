//
//  StoreHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/8/23.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "StoreHeaderView.h"

@interface StoreHeaderView()

@property (nonatomic, copy) NSString *phone;

@end

@implementation StoreHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backImgview.clipsToBounds = YES;
    self.imgview.clipsToBounds = YES;
    self.imgview.layer.cornerRadius = CGRectGetHeight(self.imgview.frame) / 2;
    self.imgview.layer.borderWidth = 2.0;
    self.imgview.layer.borderColor = RGBColor(102, 102, 102).CGColor;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)serviceBtnClick:(id)sender {
    if (self.phone) {
        [CommonFunction phoneCallWith:self.phone];
        
    }else {
        [CommonFunction showHUDIn:[CommonFunction topViewController] text:@"获取电话失败，请刷新重试"];
    }
}

- (void)configureWith:(Store *)store {
    self.phone = store.contactPhone;
    
    [CommonFunction hk_setImage:store.image imgview:self.backImgview];
    [CommonFunction hk_setImage:store.logo imgview:self.imgview];

    self.nameLabel.text = store.name;
    self.detailLabel.text = store.details;
}

@end
