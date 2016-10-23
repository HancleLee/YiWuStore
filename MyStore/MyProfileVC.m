//
//  MyProfileVC.m
//  MyStore
//
//  Created by Hancle on 16/8/13.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "MyProfileVC.h"
#import "MyAvatarCell.h"
#import "MyProfileCell.h"
#import "MyContactCell.h"
#import "ChangeNicknameVC.h"
#import "ChangePswVC.h"
#import "ShopAddressVC.h"
#import "User.h"
#import "ZLPhoto.h"
#import "UserModel.h"
#import "LoginHelper.h"

@interface MyProfileVC () <UITableViewDelegate, UITableViewDataSource,ZLPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSURLSessionDataTask *logoutTask;

@end

@implementation MyProfileVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"个人资料"];
    
    [self creatUI];
    [self updateUI];
    
    // notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:NOTI_UPDATE_USER_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_UPDATE_USER_SUCCESS object:nil];
}

// 返回按钮，重写
- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [[UITableView alloc] init];
    self.tableview.scrollEnabled = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = MainBackColor;
    [self.view addSubview:self.tableview];
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *logouButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logouButton.frame = CGRectMake(36, self.view.frame.size.height - 125, ScreenWidth - 72, 39);
    [logouButton setImage:ImageNamed(@"logout") forState:UIControlStateNormal];
    [logouButton addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logouButton];
}

- (void)updateUI {
    self.user = [ArchiverHelper unarchiverModelWith:[User new] key:ARCH_USER];
    [self.tableview reloadData];
}

#pragma mark - request networking
// 请求 修改头像
- (void)requestForChangeAvatarWith:(NSDictionary *)paraDic avatar:(UIImage *)avatar {
    [CommonFunction showHUDIn:self];
    self.task = [AFNetWorkingTool postFileWithUrl:IPUpdateInfo parameters:paraDic files:@{@"avatar" : avatar} progress:nil success:^(id responseObject) {
        UserModel *model = [[UserModel alloc] initWithJson:responseObject];
        [self requestSuccessWith:model];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:nil];

    } fail:^(NSError *error) {
        [CommonFunction showHUDIn:self text:RequestFailTipText];
    }];
}

// 请求 登出
- (void)requestForLogoutWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.logoutTask = [AFNetWorkingTool postJSONWithUrl:IPUserLogout parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:HUDShowTime completion:^{
            if (model.code == 0) {
                [LoginHelper gotoLogin];
            }
        }];

    } fail:nil];
}

#pragma mark - private
- (void)requestSuccessWith:(UserModel *)model {
    [ArchiverHelper archiverModelWith:model.data key:ARCH_USER];
}

/**
 *  从相册选择图片
 */
- (void)takePictures {
    // 创建图片多选控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusPhotoStream;
    pickerVc.maxCount = 1;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
    if (self.assets.count > 0) {
        pickerVc.selectPickers = self.assets;
    }
}

// ZLPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    if (assets.count > 0) {
        id item = assets[0];
        if ([item isKindOfClass:[ZLPhotoAssets class]]) {
            ZLPhotoAssets *asset = item;
            [self requestForChangeAvatarWith:@{@"token":TOKEN} avatar:asset.originImage];
        }
    }
}

// 登出按钮
- (void)logoutBtnClick:(UIButton *)sender {
    [self requestForLogoutWith:@{@"token": TOKEN}];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 71;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = MainBackColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *identifier = @"MyAvatarCell";
        MyAvatarCell *Cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyAvatarCell class]) owner:nil options:nil].firstObject;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [CommonFunction hk_setImage:self.user.avatar imgview:Cell.avatarImgView];

        return Cell;
        
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        static NSString *identifier = @"MyContactCell";
        MyContactCell *Cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyContactCell class]) owner:nil options:nil].firstObject;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Cell.phoneLabel.text = self.user.phone;
        
        return Cell;
        
    }else {
        static NSString *identifier = @"MyProfileCell";
        MyProfileCell *Cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyProfileCell class]) owner:nil options:nil].firstObject;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 1) {
            Cell.nameLabel.text = @"修改登录密码";
            
        }else if (indexPath.section == 0 && indexPath.row == 3) {
            Cell.nameLabel.text = @"收货地址";
        }
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            Cell.detailLabel.text = self.user.nickname;
            
        }else if (indexPath.section == 0 && indexPath.row == 3) {
            if ([MeManager shareInstance].addressModel.data.addressList.count > 0) {
                Address *address = [MeManager shareInstance].addressModel.data.addressList[0];
                Cell.detailLabel.text = StringWithFomat2(address.area, address.address);
            }
        }
        
        return Cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section - %zd row - %zd", indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 修改头像
            [self takePictures];
            
        }else if (indexPath.row == 1) { // 修改姓名
            ChangeNicknameVC *vc = [ChangeNicknameVC new];
            vc.nickname = self.user.nickname;
            [self pushViewController:vc];
            
        }else if (indexPath.row == 3) { // 收货地址
            ShopAddressVC *vc = [ShopAddressVC new];
            [self pushViewController:vc];
        }

    }else { // 重置密码
        ChangePswVC *vc = [ChangePswVC new];
        [self pushViewController:vc];
    }
}

@end
