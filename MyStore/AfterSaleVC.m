//
//  AfterSaleVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "AfterSaleVC.h"
#import "OrdersCell.h"

@interface AfterSaleVC ()
            <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView0;
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (nonatomic, strong) NSURLSessionDataTask  *task;

@end

@implementation AfterSaleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"售后订单"];
    self.titleTextField.userInteractionEnabled = NO;
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.task) {
        [self.task cancel];
    }
}

#pragma mark - request networking
- (void)requestForAfterSaleServiceWith:(NSDictionary *)paraDic {
    self.task = [AFNetWorkingTool postJSONWithUrl:IPAfterSaleService parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == StatusRequestSuccess) {
                [self popviewControllerWith:YES];
            }
        }];
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.backView0.layer.cornerRadius       = 5.0f;
    self.backView1.layer.cornerRadius       = 5.0f;
    self.confirmButton.layer.cornerRadius   = 5.0f;
    self.contentTextView.delegate = self;
}

#pragma mark - private
- (IBAction)confirmBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (StringNil(self.titleTextField.text) || StringNil(self.contentTextView.text)) {
        [CommonFunction showHUDIn:self text:@"请填写完整"];
        
    }else {
        if (!StringNil(self.orderId)) {
            NSString *title = self.titleTextField.text;
            NSString *content = self.contentTextView.text;
            [self requestForAfterSaleServiceWith:@{@"orderId":self.orderId , @"title":title, @"content":content}];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (StringNil(textView.text)) {
        self.tipLabel.hidden = NO;
        
    }else {
        self.tipLabel.hidden = YES;
    }
}

@end
