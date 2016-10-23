//
//  ChangePswVC.m
//  MyStore
//
//  Created by Hancle on 16/8/13.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ChangePswVC.h"
#import "User.h"

@interface ChangePswVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldPswField;
@property (weak, nonatomic) IBOutlet UITextField *pswField1;
@property (weak, nonatomic) IBOutlet UITextField *pswField2;
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation ChangePswVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"修改登录密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.task cancel];
}

#pragma mark - request networking
- (void)requestForChangePswWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.task = [AFNetWorkingTool postJSONWithUrl:IPUpdatePsw parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2.0 completion:^{
            if (model.code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    } fail:nil];
}

#pragma mark - private
// 确认按钮
- (IBAction)confirmBtnClick:(id)sender {
    NSArray *arr = @[self.oldPswField, self.pswField1, self.pswField2];
    for (UITextField *field in arr) {
        if ([field.text isEqualToString:@""]) {
            [CommonFunction showHUDIn:self text:@"请输入完整"];
            return;
        }
    }
    if (![self.pswField1.text isEqualToString:self.pswField2.text]) {
        [CommonFunction showHUDIn:self text:@"两次密码输入不一致"];
        return;
    }
    User *user = [ArchiverHelper unarchiverModelWith:[User new] key:ARCH_USER];
    NSString *oldPsw = [CommonFunction md5HexDigest:self.oldPswField.text];
    NSString *newPsw = [CommonFunction md5HexDigest:self.pswField1.text];
    [self requestForChangePswWith:@{@"username": user.username, @"password_new":newPsw, @"password_old":oldPsw}];
}


@end
