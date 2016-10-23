//
//  RegisterVC.m
//  MyStore
//
//  Created by Hancle on 16/7/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "RegisterVC.h"
#import "AFNetWorkingTool.h"
#import "UserModel.h"
#import "SecureCodeButton.h"

@interface RegisterVC () <SecureCodeButtonDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet UITextField *secureCodeField;
@property (weak, nonatomic) IBOutlet UITextField *psw2Field;
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UIView *codeBackView;
@property (nonatomic, strong) SecureCodeButton *codeButton;

@end

@implementation RegisterVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:self.navTitle];
    
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)creatUI {
    self.backView1.layer.cornerRadius = 5.0;
    self.backView1.layer.borderColor = RGBColor(235, 235, 235).CGColor;
    self.backView1.layer.borderWidth = 1.0;
    self.backView2.layer.cornerRadius = 5.0;
    self.backView2.layer.borderColor = RGBColor(235, 235, 235).CGColor;
    self.backView2.layer.borderWidth = 1.0;
    
    self.codeButton = [[SecureCodeButton alloc] initWithFrame:self.codeBackView.bounds];
    self.codeButton.delegate = self;
    [self.codeBackView addSubview:self.codeButton];
}

#pragma mark - request network 
// 请求 获取验证码
- (void)requestForGetPhoneCodeWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    [AFNetWorkingTool postJSONWithUrl:IPGetPhoneCode parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        if (model.code == 0) {
            [CommonFunction hideAllHUDIn:self];
            [self.codeButton start];
            
        }else {
            [CommonFunction showHUDIn:self text:model.msg];
            [self.codeButton reset];
        }
        
    } fail:^(NSError *error) {
        [CommonFunction showHUDIn:self text:RequestFailTipText];
        [self.codeButton reset];
    }];
}

// 请求 注册/找回密码
- (void)requestForRegisterWith:(NSDictionary *)paraDic ip:(NSString *)ip {
    [CommonFunction showHUDIn:self];
    [AFNetWorkingTool postJSONWithUrl:ip parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        UserModel *registerModel = [[UserModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:registerModel.msg hideTime:2 completion:^{
            if (registerModel.code == StatusRequestSuccess) {
                [self requestSuccessWith:registerModel];
            }
        }];
        
    } fail:nil];
}

#pragma mark - private
- (IBAction)registerBtnClick:(id)sender {
    if (![_pswField.text isEqualToString:_psw2Field.text]) {
        [CommonFunction showHUDIn:self text:@"密码填写不一致" hideTime:HUDShowTime completion:nil];
        return;
    }
    NSString *name = self.nameField.text;
    NSString *psw = self.pswField.text;
    psw = [CommonFunction md5HexDigest:psw];
    NSString *secureCode = self.secureCodeField.text;
    NSArray *arr = @[name,psw,secureCode];
    for (NSString *item in arr) {
        if ([item isEqualToString:@""]) {
            NSLog(@"field couldn't be empty");
            [CommonFunction showHUDIn:self text:@"请填写完整" hideTime:2 completion:nil];
            return;
        }
    }
    NSDictionary *paraDic = @{@"username":name, @"password":psw, @"phoneCode": secureCode};
    if ([self.navTitle isEqualToString:@"注册"]) { // 注册
        [self requestForRegisterWith:paraDic ip:IPUserRegister];
        
    }else {   // 忘记密码
        [self requestForRegisterWith:paraDic ip:IPFindPassword];
    }
}

- (void)requestSuccessWith:(UserModel *)model {
    // 缓存用户信息
    BOOL isArch = [ArchiverHelper archiverModelWith:model.data key:ARCH_USER];
    NSLog(@"缓存数据 －－ %d \n", isArch);
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            NSLog(@"%s",__func__);
        }];
    }
}

#pragma mark - SecureCodeButtonDelegate
- (void)secureCodeBtnClick:(SecureCodeButton *)button {
    if (![CommonFunction isValidateMobile:self.nameField.text]) {
        [CommonFunction showHUDIn:self text:@"请正确输入手机号" hideTime:2 completion:nil];
    }else {
        [self requestForGetPhoneCodeWith:@{@"phone": self.nameField.text}];
    }
}

#pragma mark--把字典和数组转换成json字符串
- (NSString *)stringTOjson:(id)temps   //把字典和数组转换成json字符串
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}

@end
