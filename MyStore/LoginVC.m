//
//  LoginVC.m
//  MyStore
//
//  Created by Hancle on 16/7/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "UserModel.h"
#import "TabbarVC.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "QQApiManager.h"
#import <WeiboSDK.h>
#import <UMengSocialCOM/UMSocial.h>
#import <UMengSocialCOM/UMSocialSinaSSOHandler.h>

@interface LoginVC () <WXApiManagerDelegate, QQApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLoginOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLoginOffsetConstraint2;

@property (nonatomic, copy) NSString *WXState;
@property (nonatomic, strong) QQApiManager *QQApiMgr;
@property (nonatomic, copy) NSString *wxCode;

@end

@implementation LoginVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationItem setTitle:@"登录"];
    self.rightItemBtnTitle = @"注册";
    [self creatUI];
    
    self.WXState = [CommonFunction getRandomString];
    [WXApiManager sharedManager].delegate = self;
    self.QQApiMgr = [[QQApiManager alloc] init];
    self.QQApiMgr.delegate = self;
    
    
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"installed wechat app");
    }else {
        NSLog(@"not installed wechat app");

//        self.wechatLoginButton.hidden = YES;
//        self.qqWechatOffsetConstaint.constant = - 55;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request network
// 请求 登录接口
- (void)requestForLoginWith:(NSDictionary *)paraDic {
    
    [CommonFunction showHUDIn:self];
    [AFNetWorkingTool postJSONWithUrl:IPUserLogin parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        UserModel *registerModel = [[UserModel alloc] initWithJson:responseObject];
        if (registerModel.code == StatusRequestSuccess) {
            [self requestSuccessWith:registerModel];
        }else {
            [CommonFunction showHUDIn:self text:registerModel.msg hideTime:2 completion:nil];
        }
        
    } fail:nil];
}

- (void)requestForThirdLoginWith:(NSDictionary *)paraDic {
    [AFNetWorkingTool postJSONWithUrl:IPUserThirdLogin parameters:paraDic progress:nil success:^(id responseObject) {
        UserModel *registerModel = [[UserModel alloc] initWithJson:responseObject];
        if (registerModel.code == StatusRequestSuccess) {
            [self requestSuccessWith:registerModel];
        }else {
            [CommonFunction showHUDIn:self text:registerModel.msg hideTime:2 completion:nil];
        }
        
    } fail:nil];
    
}

#pragma mark - UI
- (void)creatUI {
    if (ScreenWidth < 375) {
        self.otherLoginOffsetConstraint.constant = 30.0;
        self.otherLoginOffsetConstraint2.constant = 15.0;
    }
}

#pragma mark - private
// 点击登录按钮
- (IBAction)loginBtnClick:(id)sender {
    NSString *name = self.nameField.text;
    NSString *psw = self.pswField.text;
    if (![name isEqualToString:@""] && ![psw isEqualToString:@""]) {
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        psw = [CommonFunction md5HexDigest:psw];
        [paraDic setObject:name forKey:@"username"];
        [paraDic setObject:psw forKey:@"password"];
        [self requestForLoginWith:paraDic];
        
    }else {
        [CommonFunction showHUDIn:self text:@"请填写完整" hideTime:2 completion:nil];
        NSLog(@"please enter name and psw");
    }
}

- (void)requestSuccessWith:(UserModel *)model {
    [CommonFunction hideAllHUDIn:self];
    // 缓存用户信息
    BOOL isArch = [ArchiverHelper archiverModelWith:model.data key:ARCH_USER];
    NSLog(@"缓存数据 －－ %d \n", isArch);
    [self loginSuccess];
}

// 登录成功后的处理
- (void)loginSuccess {
//    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            NSLog(@"%s",__func__);
//        }];
//        
//    }else {
        TabbarVC *rootNavVC = [[TabbarVC alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootNavVC;
//    }
}

// 点击忘记密码按钮
- (IBAction)forgotPswBtnClick:(id)sender {
    RegisterVC *vc = [RegisterVC new];
    vc.navTitle = @"重置密码";
    [self pushViewController:vc];
}

// 点击注册按钮
- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem {
    RegisterVC *vc = [RegisterVC new];
    vc.navTitle = @"注册";
    [self pushViewController:vc];
}

- (IBAction)weiboLoginBtnClick:(id)sender {
    NSLog(@"weibo");
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WBAppID
                                              secret:WBAppSecret
                                         RedirectURL:WBDirectURL];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            NSString *username = snsAccount.userName;
            NSString *icon = snsAccount.iconURL;
            NSString *uid = snsAccount.unionId;
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:@"4" forKey:@"type"]; //微信2， qq3，微博4
            if (!StringNil(username)) {
                [paraDic setObject:username forKey:@"nickname"];
            }
            if (!StringNil(icon)) {
                [paraDic setObject:icon forKey:@"avatar"];
            }
            if (!StringNil(uid)) {
                [paraDic setObject:icon forKey:@"uid"];
            }
            [self requestForThirdLoginWith:paraDic];
        }else {
            [CommonFunction showHUDIn:self text:@"登录失败"];
        }
    });
}

- (IBAction)qqLoginBtnClick:(id)sender {
    NSLog(@"qq");
    [self.QQApiMgr qqLogin];
}

- (IBAction)wechatLoginBtnClick:(id)sender {
    NSLog(@"wechat");
    if ([WXApi isWXAppInstalled]) {
        [[WXApiManager sharedManager] sendWechatAuthRequestWith:self.WXState];  // 调起微信客户端
    }else {
        [CommonFunction showHUDIn:self text:@"您未安装微信客户端"];
    }
}

#pragma mark - wechat
// 微信接收到返回结果
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSLog(@"%@ -- %@",response.code, response.state);
    [CommonFunction showHUDIn:self];
    if ([self.WXState isEqualToString:response.state]) {
        NSLog(@"get code success");
        self.wxCode = response.code;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:@"2" forKey:@"type"]; //微信2， qq3，微博4
        if (self.wxCode) [paraDic setObject:self.wxCode forKey:@"code"];
        [self requestForThirdLoginWith:paraDic];

    }else {
        [CommonFunction showHUDIn:self text:@"登录失败"];
    }
}

// 获取用户微信上的信息成功
- (void)managerDidRecvGetUserData:(NSDictionary *)datas {
    NSLog(@"%@",datas);
}

#pragma mark - QQ
// 获取QQ登录状态
- (void)managerDidLoginWith:(TencentOAuth *)tencentOAuth {
    if ([tencentOAuth getUserInfo]) {
        NSLog(@"openid--%@ === %@", tencentOAuth.openId, tencentOAuth.accessToken);
    }
    [CommonFunction showHUDIn:self];
}

// 获取用户QQ用户信息
- (void)managerDidGetQQUserData:(NSDictionary *)datas {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:datas];
    [paraDic setObject:@"3" forKey:@"type"];
    [self requestForThirdLoginWith:paraDic];
}

// 用户登录失败
- (void)managerDidFailLogin:(NSString *)title {
    [CommonFunction showHUDIn:self text:title];
}

@end
