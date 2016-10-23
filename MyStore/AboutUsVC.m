//
//  AboutUsVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImgview;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@end

@implementation AboutUsVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"关于我们"];
    
    [self creatUI];
#warning here should be changed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回按钮，重写
- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UI
- (void)creatUI {
    self.view.backgroundColor = WhiteColor;
    self.logoImgview.layer.cornerRadius = CGRectGetHeight(self.logoImgview.frame) / 2;
    self.logoImgview.clipsToBounds = YES;
    self.contentField.userInteractionEnabled = NO;
}

@end
