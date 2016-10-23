//
//  GoodsDetailVC.m
//  MyStore
//
//  Created by Hancle on 16/8/17.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "GoodDetailHeaderView.h"
#import "GoodDetailFooterView.h"
#import "SelectGoodTypeView.h"
#import "ConfirmOrderVC.h"
#import "CustomShareView.h"
#import "GoodDetailCell.h"
#import "StoreVC.h"
#import "ShoppingCartVC.h"
#import "CollectEditModel.h"
#import "GDHeaderView.h"
#import "ListView.h"
#import "CommentModel.h"
#import "CommentCell.h"

typedef NS_ENUM(NSInteger, IsCollectedType) {
    Is_Collected,   // 已收藏
    Is_UnCollect    // 未收藏
};
typedef NS_ENUM(NSInteger, FooterViewType) {
    PicOrTextDetails,   // 图文详情
    UserComments        // 用户评价
};

@interface GoodsDetailVC () <UITableViewDelegate, UITableViewDataSource, SelectGoodTypeViewDelegate, GDHeaderViewDelegate, ListViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) GoodDetailHeaderView *headerview;
@property (nonatomic, strong) GoodDetailFooterView *footerview;
@property (nonatomic, strong) SelectGoodTypeView *buyView;
@property (nonatomic, assign) BOOL isShowedTypeview; // 是否已显示选择商品规格view

@property (weak, nonatomic) IBOutlet UIButton *shoppingcartButton;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;

@property (nonatomic, strong) NSDictionary *selectedTags;
@property (nonatomic, copy) NSString *selectedNum;
@property (nonatomic, strong)  UIBarButtonItem *rightItem;
@property (nonatomic, assign) NSInteger footerViewType;
@property (nonatomic, strong) CommentModel *commentModel;

@property (nonatomic, strong) NSURLSessionDataTask *addCartTask;
@property (nonatomic, strong) NSURLSessionDataTask *collectionTask;
@property (nonatomic, strong) NSURLSessionDataTask *commentListTask;

@end

@implementation GoodsDetailVC
#pragma mark - setter/getter
- (SelectGoodTypeView *)buyView {
    SelectGoodTypeView *view = [SelectGoodTypeView customviewWith:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 46)];
    [view configureWith:self.good];
    view.delegate = self;
    return view;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.goodsNumLabel.hidden = YES; // 购物车数量，第一版本暂不显示
    self.isShowedTypeview = NO;
    self.selectedNum = @"1";
    self.footerViewType = PicOrTextDetails;
    [self creatUI];
    
    if (self.good) {
        [self updateUI];
        [self requestForCommentListWith:@{@"goodsId":self.good.goodsId, @"size": REQUEST_DATA_COUNT, @"index": @"0"}];
    }
    for (NSString *item in self.good.tags.allKeys) {
        NSLog(@"%@", item);
    }
    self.tableview.mj_footer = [MJRefreshFooter mjRefreshFooterWith:^{
        NSString *index = [NSString stringWithFormat:@"%zd", self.commentModel.data.count];
        [self requestForCommentListWith:@{@"goodsId":self.good.goodsId, @"size": REQUEST_DATA_COUNT, @"index": index}];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar nav_setBackgroundColor:[UIColor colorWithRed:0.949 green:0.212 blue:0.298 alpha:0]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar nav_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.collectionTask) [self.collectionTask cancel];
    if (self.addCartTask) [self.addCartTask cancel];
    if (self.commentListTask) [self.commentListTask cancel];
}

#pragma mark - request networking
- (void)requestForAddCartWith:(NSDictionary *)paraDic {
    [CommonFunction showHUDIn:self];
    self.addCartTask = [AFNetWorkingTool postJSONWithUrl:IPCartAdd parameters:paraDic progress:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        SuperModel *model = [[SuperModel alloc] initWithJson:responseObject];
        [CommonFunction showHUDIn:self text:model.msg hideTime:HUDShowTime completion:^{
            if (model.code == StatusRequestSuccess) {
                [self addCartSuccess];
            }
        }];
        
    } fail:nil];
}

- (void)requestForCollection:(NSDictionary *)paraDic {
    if (self.collectionTask) [self.collectionTask cancel];
    [CommonFunction showHUDIn:self];
    self.collectionTask = [AFNetWorkingTool postJSONWithUrl:IPCollectEdit parameters:paraDic progress:nil success:^(id responseObject) {
        CollectEditModel *model = [[CollectEditModel alloc] initWithJson:responseObject];
        [self setupCollectionButton:(model.type == 0) ? NO : YES ];
        [CommonFunction showHUDIn:self text:model.msg];
        
    } fail:nil];
}

- (void)requestForCommentListWith:(NSDictionary *)paraDic {
    if (self.commentListTask) [self.commentListTask cancel];
    self.commentListTask = [AFNetWorkingTool getJSONWithUrl:IPCommentInfoList parameters:paraDic progress:nil success:^(id responseObject) {
        CommentModel *model = [[CommentModel alloc] initWithJson:responseObject];
        [self endRefreshingWith:(model.data.count == [REQUEST_DATA_COUNT integerValue]) ? NO : YES];
        if (self.commentModel.data.count == 0) {
            self.commentModel = model;
        }else {
            self.commentModel = [self.commentModel addObjWith:model];
        }
        [self updateUI];
        
    } fail:nil];
}

#pragma mark - UI
- (void)creatUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.rightItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"add_collection") style:UIBarButtonItemStylePlain target:self action:@selector(addCollectionBtnClick:)];
    self.rightItem.tag = Is_UnCollect;
    [self setupCollectionButton:(self.good.isCollect == 0) ? NO : YES];
    [self.navigationItem setRightBarButtonItem:self.rightItem];
    
    self.tableview = [UITableView new];
    self.tableview.backgroundColor = MainBackColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 46, 0));
    }];
    
    CGFloat height = (514.0 / 754.0) * ScreenWidth + 70.0;
    GDHeaderView *headerview = [[GDHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, height + 160)];
    [headerview configureViewWith:self.good];
    headerview.delegate = self;
    self.tableview.tableHeaderView = headerview;

    [self setupFooterView];
    
    self.goodsNumLabel.layer.cornerRadius = CGRectGetHeight(self.goodsNumLabel.frame) / 2;
    self.goodsNumLabel.clipsToBounds = YES;
    [self.view bringSubviewToFront:self.shoppingcartButton];
    [self.view bringSubviewToFront:self.goodsNumLabel];
}

- (void)setupFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 460.0)];
    self.footerview = [GoodDetailFooterView footerViewWith:CGRectMake(0, 0, ScreenWidth, 460)];
    [footerView addSubview:self.footerview];
    self.tableview.tableFooterView = footerView;
}

- (void)updateUI {
    [self.headerview configureViewWith:self.good];
    [self.footerview configureWith:self.good];
    [self.tableview reloadData];
}

- (void)endRefreshingWith:(BOOL)noMoreData {
    if (self.footerViewType == PicOrTextDetails) {
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
        
    }else {
        if(noMoreData)
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        else
            [self.tableview.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.footerViewType == PicOrTextDetails) {
        return 0;
    }
    return self.commentModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ListView *view = [ListView listViewWithFrame:CGRectMake( 0, 0, ScreenWidth, 40) items:@[@"图文详情", @"用户评价"]];
    view.backColor = MainBackColor;
    view.selectedTextColor = MainRedColor;
    view.textColor = MainBlackColor;
    view.selectedIndex = (int)self.footerViewType;
    view.delegate = self;

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.commentModel.data.count) {
        Comment *comment = self.commentModel.data[indexPath.row];
        CGFloat height = [comment cellHeight];
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     CommentCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!Cell) {
        Cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CommentCell class]) owner:nil options:nil].firstObject;
    }
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.commentModel.data.count) {
        Comment *comment = self.commentModel.data[indexPath.row];
        [Cell configureCellWith:comment];
    }
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - GDHeaderViewDelegate
- (void)headerViewDidSelectAt:(NSIndexPath *)indexPath good:(GoodsList *)good {
    if (indexPath.section == 0) {
        [self showSelectTypeView];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[StoreVC class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            StoreVC *vc = [StoreVC new];
            vc.shopId = self.good.shopId;
            [self pushViewController:vc];
        }
    }
}

#pragma mark - SelectGoodTypeViewDelegate
- (void)selectedGoodTypeWith:(SelectGoodTypeView *)view good:(GoodsList *)good tags:(NSDictionary *)tags num:(NSString *)num {
    NSLog(@"%@  %@", tags[tags.allKeys[0]], num);
    self.selectedTags = tags;
    self.selectedNum = num;
}

- (void)removeBtnClick:(SelectGoodTypeView *)view btn:(UIButton *)button {
    [self hideSelectTypeView];
}

#pragma mark - ListViewDelegate
- (void)selectedListButtonAt:(NSInteger)index button:(ListButton *)button {
    self.footerViewType = index;
    if (index == UserComments) {
        self.tableview.tableFooterView = [UIView new];
        [self endRefreshingWith:NO];
        
    }else {
        [self setupFooterView];
        [self endRefreshingWith:YES];
    }
    [self updateUI];
}

#pragma mark - private
// 加入收藏按钮
- (void)addCollectionBtnClick:(UIBarButtonItem *)item {
    if (self.good.goodsId) {
        [self requestForCollection:@{@"goodsId": self.good.goodsId}];
        
    }else {
        [CommonFunction showHUDIn:self text:@"加入收藏失败"];
    }
}

// 立即购买按钮
- (IBAction)buyBtnClick:(id)sender {
    NSLog(@"buy");
    if (self.isShowedTypeview == NO) {
        [self showSelectTypeView];
        
    }else {
        ConfirmOrderVC *vc = [ConfirmOrderVC new];
        vc.good = self.good;
        vc.selctedTags = self.selectedTags;
        vc.num = self.selectedNum;
        [self pushViewController:vc];
        [self hideSelectTypeView];
    }
}

// 加入购物车按钮
- (IBAction)addShoppingcartBtnClick:(id)sender {
    if (self.isShowedTypeview == NO) {
        [self showSelectTypeView];
        
    }else {
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        if (self.selectedTags.count > 0) {
            NSString *tags = [CommonFunction transferToJsonStringWith:self.selectedTags];
            [paraDic setObject:tags forKey:@"tags"];
        }
        [paraDic setObject:self.selectedNum forKey:@"amount"];
        [paraDic setObject:self.good.goodsId forKey:@"goodsId"];
        [self requestForAddCartWith:paraDic];
    }
}

// 购物车按钮
- (IBAction)shoppingcartBtnClick:(id)sender {
    ShoppingCartVC *vc = [ShoppingCartVC new];
    [self pushViewController:vc];
}

// 显示选择商品规格view
- (void)showSelectTypeView {
    if (self.isShowedTypeview == NO) {
        [self.view addSubview:self.buyView];
        [self.view bringSubviewToFront:self.shoppingcartButton];
        [self.view bringSubviewToFront:self.goodsNumLabel];
        
        self.selectedTags = self.buyView.selectedDic;
    }
    self.isShowedTypeview = YES;
}

// 隐藏选择商品规格view
- (void)hideSelectTypeView {
    for (id item in self.view.subviews) {
        if ([item isKindOfClass:[SelectGoodTypeView class]]) {
            [item removeFromSuperview];
        }
    }
    self.isShowedTypeview = NO;
}

// 添加购物车成功
- (void)addCartSuccess {
    [self hideSelectTypeView];
}

// 配置 是否收藏
- (void)setupCollectionButton:(BOOL)isCollected {
    if (isCollected) {
        self.rightItem.tag = Is_Collected;
        
    }else {
        self.rightItem.tag = Is_UnCollect;
    }
    self.good.isCollect = isCollected ? 1 : 0;
    NSString *imgname = isCollected ? @"my_collection" : @"add_collection";
    UIImage *img = ImageNamed(imgname);
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.rightItem setImage:img];
}

@end
