//
//  CustomAlertView.h
//  MyStore
//
//  Created by Hancle on 16/9/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperView.h"

typedef void (^ButtonCallBackBlock)(BOOL isCancel);

@interface CustomAlertView : SuperView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) ButtonCallBackBlock buttonBlock;

+ (CustomAlertView *)customViewWith:(CGRect)frame title:(NSString *)title;

@end
