//
//  ChangeAddresVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "ChangeAddresVC.h"
#import "ChangeAddresCell.h"
#import "MeManager.h"
#import "CustomAlertViewHelper.h"

@interface ChangeAddresVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSURLSessionDataTask *addTask;

@end

@implementation ChangeAddresVC
#pragma mark - getter 
- (NSArray *)titles {
    return @[@"联系人", @"手机号", @"所在地区", @"详细地址", @"设为默认地址"];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.addr) {
        [self.navigationItem setTitle:@"修改地址"];
    }else {
        [self.navigationItem setTitle:@"新增地址"];
    }
    self.rightItemBtnTitle = @"保存";
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.addTask) {
        [self.addTask cancel];
    }
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - request networking
- (void)requestForAddAddressWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.addTask = [AFNetWorkingTool postJSONWithUrl:IPAddAddress parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == 0) {
                [self changedSuccess];
                [self popviewControllerWith:YES];
            }
        }];
        
    } fail:nil];
}

- (void)requestForDeleteAddressWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    [AFNetWorkingTool postJSONWithUrl:IPAddressDelete parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == 0) {
                [self changedSuccess];
                [self popviewControllerWith:YES];
            }
        }];
        
    } fail:nil];
}

- (void)requestForUpdateAddressWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    [AFNetWorkingTool postJSONWithUrl:IPAddressUpdate parameters:paraDic progress:nil success:^(id responseObject) {
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:2 completion:^{
            if (model.code == 0) {
                [self changedSuccess];
                [self popviewControllerWith:YES];
            }
        }];
        
    } fail:nil];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 32;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ChangeAddresCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeAddresCell"];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ChangeAddresCell class]) owner:nil options:nil].firstObject;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < self.titles.count) {
            Cell.titleLabel.text = self.titles[indexPath.row];
        }
        if (indexPath.row == 4) {
            Cell.detailField.hidden = YES;
            Cell.selectButton.hidden = NO;
        }
        NSString *defaultAddrId = [MeManager shareInstance].addressModel.data.defaultAddressId;
        BOOL isDefault = NO;
        if ([defaultAddrId isEqualToString:self.addr.addressId]) {
            isDefault = YES;
        }
        if (self.addr) {
            switch (indexPath.row) {
                case 0:
                    Cell.detailField.text = self.addr.contact;
                    break;
                    
                case 1:
                    Cell.detailField.text = self.addr.phone;
                    break;
                    
                case 2:
                    Cell.detailField.text = self.addr.area;
                    break;
                    
                case 3:
                    Cell.detailField.text = self.addr.address;
                    break;
                    
                case 4:
                    Cell.selectButton.selected = isDefault;
                    break;
                    
                default:
                    break;
            }
        }
        return Cell;
        
    }else {
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"deleCell"];
        if (!Cell) {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deleCell"];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *deleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Cell.contentView.frame.size.height)];
        if (self.addr) {
            deleLabel.text = @"删除当前地址";
        }else {
            deleLabel.text = @"保存地址";
        }
        deleLabel.textAlignment = NSTextAlignmentCenter;
        deleLabel.textColor = MainRedColor;
        deleLabel.font = FontSize(16);
        [Cell.contentView addSubview:deleLabel];
        return Cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) { // 删除地址
        if (self.addr.addressId) {
            CustomAlertView *alertview = [CustomAlertViewHelper show:@"删除地址后将不能恢复，您确定要删除地址吗？"];
            __block ChangeAddresVC *weakSelf = self;
            alertview.buttonBlock = ^(BOOL isCancel) {
                NSLog(@"%zd", isCancel);
                if (!isCancel) {
                    [weakSelf requestForDeleteAddressWith:@{@"addressId": self.addr.addressId}];
                }
            };

        }else { // 新增地址
            [self rightItemBtnClick:nil];
        }
    }
}

#pragma mark - private
- (void)rightItemBtnClick:(UIBarButtonItem *)rightItem {
    NSLog(@"right item click");
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *isDefault = @"true";
    NSString *phone = @"";
    for (NSInteger i = 0; i < 5; i ++) {
        ChangeAddresCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *str = cell.detailField.text;
        if (i < 4 && StringNil(str)) {
            [CommonFunction showHUDIn:self text:@"请填写完整"];
            return;
        }
        switch (i) {
            case 0:
                [paraDic setObject:str forKey:@"contact"];
                break;
            case 1:
                phone = str;
                [paraDic setObject:str forKey:@"phone"];
                break;
            case 2:
                [paraDic setObject:str forKey:@"area"];
                break;
            case 3:
                [paraDic setObject:str forKey:@"address"];
                break;
            case 4:
                isDefault = cell.selectButton.selected ? @"true" : @"false";
                [paraDic setObject:isDefault forKey:@"isDefault"];
                break;
                
            default:
                break;
        }
    }
    if (![CommonFunction isValidateMobile:phone]) {
        [CommonFunction showHUDIn:self text:@"请输入正确的手机号"];
        return;
    }

    if (self.addr) {
        [self updateAddrWith:paraDic];
        
    }else {
        [self addAddressWith:paraDic];
    }
}

- (void)updateAddrWith:(NSMutableDictionary *)paraDic {
    if (self.addr.addressId) {
        [paraDic setObject:self.addr.addressId forKey:@"addressId"];
    }
    [self requestForUpdateAddressWith:paraDic];
}

- (void)addAddressWith:(NSMutableDictionary *)paraDic {
    [self requestForAddAddressWith:paraDic];
}

- (void)changedSuccess {
    if ([self.delegate respondsToSelector:@selector(changeAddressSuccess)]) {
        [self.delegate changeAddressSuccess];
    }
}

@end
