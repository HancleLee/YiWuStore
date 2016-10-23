//
//  SettingVC.m
//  MyStore
//
//  Created by Hancle on 16/8/14.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SettingVC.h"
#import "MyMessageVC.h"
#import "SuggestionVC.h"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UISwitch *notiSwitch;

@end

@implementation SettingVC
#pragma mark - getter
- (NSArray *)titles {
    return @[@[@"我的消息"], @[@"版本更新", @"清除缓存", @"意见反馈", @"接收通知"]];
}

- (UISwitch *)notiSwitch {
    if (!_notiSwitch) {
        CGFloat width = 30;
        _notiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - width - 16 - 25, 13, width, 20)];
        _notiSwitch.thumbTintColor = MainRedColor;
        _notiSwitch.onTintColor = RGBColor(255, 202, 207);
    }
    return _notiSwitch;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"设置"];
    [self creatUI];
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

#pragma mark - UITableViewDelegate/UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (!Cell) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        Cell.textLabel.textColor = RGBColor(51, 51, 51);
        Cell.textLabel.font = FontSize(15);
        Cell.detailTextLabel.font = FontSize(14);
        Cell.detailTextLabel.textColor = RGBColor(178, 178, 178);
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            Cell.accessoryType = UITableViewCellAccessoryNone;
            [Cell.contentView addSubview:self.notiSwitch];
            
        }else if(indexPath.row == 0) {
            Cell.detailTextLabel.text = [CommonFunction getVersion];
            
        }else if (indexPath.row ==1) {
            NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
            CGFloat mb = (CGFloat)cacheSize / (1024.0 * 1024.0) ;
            Cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", mb];
        }
    }
    
    if (indexPath.section < self.titles.count) {
        NSArray *arr = self.titles[indexPath.section];
        if (indexPath.row < arr.count) {
            Cell.textLabel.text = arr[indexPath.row];
        }
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd %zd", indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        // 我的消息
        MyMessageVC *vc = [MyMessageVC new];
        [self pushViewController:vc];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        // 意见反馈
        SuggestionVC *vc = [SuggestionVC new];
        [self pushViewController:vc];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        // 版本更新
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"亲，这已经是最新版本了哦～" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        // 清除缓存
        [CommonFunction showHUDIn:self text:@"正在清理缓存" hideTime:100 completion:nil];
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self.tableview reloadData];
            [CommonFunction showHUDIn:self text:@"清理缓存完毕～"];
        }];
    }
}

@end
