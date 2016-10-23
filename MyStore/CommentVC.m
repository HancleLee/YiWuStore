//
//  CommentVC.m
//  MyStore
//
//  Created by Hancle on 16/10/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CommentVC.h"
#import "SuperModel.h"

@interface CommentVC ()

@property (weak, nonatomic) IBOutlet UIButton *starButton0;
@property (weak, nonatomic) IBOutlet UIButton *starButton1;
@property (weak, nonatomic) IBOutlet UIButton *starButton2;
@property (weak, nonatomic) IBOutlet UIButton *starButton3;
@property (weak, nonatomic) IBOutlet UIButton *starButton4;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic, copy) NSString *starNum;
@property (nonatomic, strong) NSURLSessionDataTask *publishComTask;

@end

@implementation CommentVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.confirmButton.layer.cornerRadius = 5.0f;
    self.starNum = @"5";
    [self.navigationItem setTitle:@"评论"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.publishComTask) {
        [self.publishComTask cancel];
    }
}

#pragma mark - request networking
- (void)requestForCommentWith:(NSDictionary *)paraDic {
    if (self.publishComTask) {
        [self.publishComTask cancel];
    }
    [CommonFunction showHUDIn:self];
    self.publishComTask = [AFNetWorkingTool postJSONWithUrl:IPCommentPublish parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == StatusRequestSuccess) {
                [self popviewControllerWith:YES];
            }
        }];
        
    } fail:nil];
}

#pragma mark - private
- (IBAction)starBtnClick:(UIButton *)sender {
    NSArray *arr = @[self.starButton0, self.starButton1, self.starButton2, self.starButton3, self.starButton4];
    NSInteger index = sender.tag - 100;
    for (int i = 0; i < arr.count; i ++) {
        id item = arr[i];
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton *button = item;
            if (i < index) {
                [button setImage:ImageNamed(@"stared") forState:UIControlStateNormal];
                
            }else {
                [button setImage:ImageNamed(@"unstar") forState:UIControlStateNormal];
            }
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd分", index];
    self.starNum = [NSString stringWithFormat:@"%zd", index];
}

- (IBAction)confirmBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (self.goodId && self.orderId && !StringNil(self.contentTextView.text) && !StringNil(self.starNum)) {
        [self requestForCommentWith:@{@"goodsId": self.goodId, @"orderId": self.orderId, @"content": self.contentTextView.text, @"star": self.starNum}];
    }
}

@end
