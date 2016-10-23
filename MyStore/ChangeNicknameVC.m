//
//  ChangeNicknameVC.m
//  MyStore
//
//  Created by Hancle on 16/8/13.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ChangeNicknameVC.h"
#import "UserModel.h"

@interface ChangeNicknameVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation ChangeNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"修改姓名"];
    self.rightItemBtnTitle = @"保存";
    self.nameField.text = self.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.task cancel];
}

#pragma mark - request networking 
- (void)requestForChangeNicknameWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.task = [AFNetWorkingTool postJSONWithUrl:IPUpdateInfo parameters:paraDic progress:nil success:^(id responseObject) {
        UserModel *model = [[UserModel alloc] initWithJson:responseObject];
        [self requestSuccessWith:model];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    } fail:nil];
}

- (void)requestSuccessWith:(UserModel *)model {
    [ArchiverHelper archiverModelWith:model.data key:ARCH_USER];
}

- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem {
    NSLog(@"right item click");
    if ([self.nameField.text isEqualToString:self.nickname] || [self.nameField.text isEqualToString:@""]) {
        return;
    }
    [self requestForChangeNicknameWith:@{@"token" : TOKEN, @"nickname" :self.nameField.text}];
}


- (IBAction)clearBtnClick:(id)sender {
    self.nameField.text = @"";
}

@end
