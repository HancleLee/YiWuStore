//
//  SecureCodeButton.h
//  QiCheng51
//
//  Created by Hancle on 16/4/22.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDefine.h"
@class SecureCodeButton;

@protocol SecureCodeButtonDelegate <NSObject>

- (void)secureCodeBtnClick:(SecureCodeButton *)button;

@end

@interface SecureCodeButton : UIView

@property (nonatomic ,weak) id<SecureCodeButtonDelegate> delegate;

- (void)start;
- (void)reset;

@end
