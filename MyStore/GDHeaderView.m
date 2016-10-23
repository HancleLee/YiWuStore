//
//  GDHeaderView.m
//  MyStore
//
//  Created by Hancle on 16/10/15.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GDHeaderView.h"
#import "GoodDetailCell.h"
#import "GoodDetailHeaderView.h"

@interface GDHeaderView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) GoodDetailHeaderView *headerview;
@property (nonatomic, strong) GoodsList *good;

@end

@implementation GDHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];

    }
    return self;
}

#pragma mark - UI
- (void)creatUI {
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CGFloat height = (514.0 / 754.0) * ScreenWidth + 70.0;
    self.headerview = [GoodDetailHeaderView headerViewWith:CGRectMake(0, 0, ScreenWidth, height)];
    self.headerview.imgview.clipsToBounds = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    view.backgroundColor = MainBackColor;
    [view addSubview:self.headerview];
    self.tableview.tableHeaderView = view;
}

- (void)configureViewWith:(GoodsList *)good {
    self.good = good;
    [self.tableview reloadData];
    [self.headerview configureViewWith:good];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 10;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell0"];
        if (!Cell) {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GoodsDetailCell0"];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        Cell.textLabel.text = @"选择规格";
        Cell.textLabel.font = FontSize(16);
        Cell.textLabel.textColor = MainBlackColor;
        return Cell;
        
    }else {
        GoodDetailCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell"];
        if (!Cell) {
            Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GoodDetailCell class]) owner:nil options:nil].firstObject;
        }
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [Cell configureCellWith:self.good.shopLogo title:self.good.shopName];
            
        }else {
            [Cell configureCellWith:ImageNamed(@"tel") title:self.good.contactPhone];
        }
        if (indexPath.row == 1) {
            Cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return Cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(headerViewDidSelectAt:good:)]) {
        [self.delegate headerViewDidSelectAt:indexPath good:self.good];
    }
}

@end
