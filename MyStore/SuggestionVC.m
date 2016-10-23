//
//  SuggestionVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuggestionVC.h"
#import "SuperModel.h"

@interface SuggestionVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation SuggestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"意见反馈"];
    self.textview.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request networking
- (void)requestForFeedbackWith:(NSDictionary *)paraDic {
    self.task = [AFNetWorkingTool postJSONWithUrl:IPFeedBackAdd parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:HUDShowTime completion:^{
            if (model.code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    } fail:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.indicatorLabel.hidden = NO;
    }else {
        self.indicatorLabel.hidden = YES;
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    NSLog(@"confirm button click");
    if (![self.textview.text isEqualToString:@""]) {
        [self requestForFeedbackWith:@{@"token":TOKEN, @"info":self.textview.text}];
    }
}

@end
