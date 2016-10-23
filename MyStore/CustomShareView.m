//
//  CustomShareView.m
//  QiCheng51
//
//  Created by Hancle on 16/6/4.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "CustomShareView.h"
#import "UMSocial.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

#define KHeight self.frame.size.height
#define kWidth self.frame.size.width
#define ShareViewHeight 261

@interface CustomShareView()

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic,copy) UIImage *image;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) UIViewController *controller;

@property (nonatomic,strong)UIView *buttomView;
@property (nonatomic,strong)UIView *contentView;

@end

@implementation CustomShareView

+ (instancetype)customShareViewWithPresentedViewController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(UIImage *)image urlResource:(NSString *)url {
    NSMutableArray *items = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [items addObject:UMShareToWechatSession];
        [items addObject:UMShareToWechatTimeline];
    }
    if ([TencentOAuth iphoneQQInstalled]) {
        [items addObject:UMShareToQzone];
    }
    [items addObject:UMShareToSina];
    if (items.count > 0) {
        return [self shareViewWithPresentedViewController:controller items:items title:title content:content image:image urlResource:url];
    }else {
        CustomShareView *view = [[CustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [view creatView];
        return view;
    }
}

+(instancetype)shareViewWithPresentedViewController:(UIViewController *)controller items:(NSArray *)items title:(NSString *)title content:(NSString *)content image:(UIImage *)image urlResource:(NSString *)url {
    CustomShareView *view = [[CustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    view.title = title;
    view.content = content;
    view.url = url;
    view.image = image;
    view.items = items;
    view.controller = controller;
    
    [view createShareView];
    
    return view;
}

- (void)creatView {
    /*------------------  添加蒙板  -------------------*/
    _buttomView = [[UIView alloc] initWithFrame:self.bounds];
    _buttomView.backgroundColor = [UIColor blackColor];
    _buttomView.alpha = 0.0;
    [_buttomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)]];
    [self addSubview:_buttomView];
    /*------------------------------------------------*/
    
    /*---------- 内容view，包括分享itemsView以及取消按钮 ----------*/
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, KHeight, kWidth, ShareViewHeight)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    //分享ItemsView
    UIScrollView *shareItemView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, kWidth-20, 100)];
    shareItemView.backgroundColor = [UIColor whiteColor];
    shareItemView.layer.cornerRadius = 10;
    shareItemView.layer.masksToBounds = YES;
    shareItemView.showsVerticalScrollIndicator = NO;
    shareItemView.showsHorizontalScrollIndicator = NO;
    [_contentView addSubview:shareItemView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth - 20, 100)];
    tipLabel.font = FontSize(18);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"暂无可用的分享途径";
    [_contentView addSubview:tipLabel];
    
    //取消按钮
    UIButton *cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(shareItemView.frame) + 10, ScreenWidth-20, 40)];
    cancelbtn.layer.cornerRadius = 10;
    cancelbtn.layer.masksToBounds = YES;
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelbtn.backgroundColor = [UIColor whiteColor];
    [cancelbtn addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_contentView addSubview:cancelbtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        _buttomView.alpha = 0.3;
        _contentView.frame = CGRectMake(0, ScreenHeight-ShareViewHeight, ScreenWidth, ShareViewHeight);
    }];
    
    /*----------------------------------------------------------*/
}

- (void)createShareView {
    /*------------------  添加蒙板  -------------------*/
    _buttomView = [[UIView alloc] initWithFrame:self.bounds];
    _buttomView.backgroundColor = [UIColor blackColor];
    _buttomView.alpha = 0.0;
    [_buttomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)]];
    [self addSubview:_buttomView];
    /*------------------------------------------------*/
    
    /*---------- 内容view，包括分享itemsView以及取消按钮 ----------*/
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, KHeight, kWidth, ShareViewHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:topview.bounds];
    titleLabel.text = @"分享到";
    titleLabel.font = FontSize(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topview addSubview:titleLabel];
    [_contentView addSubview:topview];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topview.frame.size.height, ScreenWidth, 1)];
    line.backgroundColor = RGBColor(237, 236, 237);
    [_contentView addSubview:line];
    
    //分享ItemsView
    UIScrollView *shareItemView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, line.frame.origin.y + line.frame.size.height + 25, kWidth-10, 100)];
    shareItemView.backgroundColor = [UIColor whiteColor];
    shareItemView.layer.cornerRadius = 10;
    shareItemView.layer.masksToBounds = YES;
    shareItemView.showsVerticalScrollIndicator = NO;
    shareItemView.showsHorizontalScrollIndicator = NO;
    [_contentView addSubview:shareItemView];
    
    if (_items.count) {
        CGFloat itemWidth  = 65;
        CGFloat itemHeight = 53;
        CGFloat pading = _items.count < 5 ? (shareItemView.width-itemWidth * _items.count)/(_items.count+1) : 30;
        for (int i=0; i<_items.count; i++) {
            UIButton * itemBtn = [[UIButton alloc] initWithFrame:CGRectMake((itemWidth+pading)*i+pading, 15, itemWidth, itemHeight)];
            itemBtn.tag = i;
            NSString *itemName =  [self getTitleAndImageWithItem:itemBtn];
            [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [shareItemView addSubview:itemBtn];
            
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemBtn.left, itemBtn.bottom + 7, itemWidth, 20)];
            itemLabel.text = itemName;
            itemLabel.font = [UIFont systemFontOfSize:12];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            [shareItemView addSubview:itemLabel];
        }
        shareItemView.contentSize = CGSizeMake((itemWidth+pading)*_items.count+pading, 0);
    }
    
    //取消按钮
    UIButton *cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(50, ShareViewHeight - 70, ScreenWidth-100, 40)];
    cancelbtn.layer.cornerRadius = CGRectGetHeight(cancelbtn.frame) / 2;
    cancelbtn.layer.masksToBounds = YES;
    cancelbtn.layer.borderColor = RGBColor(237, 236, 237).CGColor;
    cancelbtn.layer.borderWidth = 1.0f;
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelbtn.backgroundColor = [UIColor whiteColor];
    cancelbtn.titleLabel.font = FontSize(15);
    [cancelbtn setTitleColor:RGBColor(64, 64, 64) forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_contentView addSubview:cancelbtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        _buttomView.alpha = 0.3;
        _contentView.frame = CGRectMake(0, ScreenHeight-ShareViewHeight, ScreenWidth, ShareViewHeight);
    }];
    /*----------------------------------------------------------*/
}


#pragma mark - 设置item图片以及获取title
-(NSString *)getTitleAndImageWithItem:(UIButton *)itemBtn{
    NSString *itemTitle = @"";
    NSString *itemImage = @"";
    NSString *type = _items[itemBtn.tag];
    if ([type isEqualToString:UMShareToQzone]) {
        itemTitle = @"QQ空间";
        itemImage = @"qqzone";
    }
    else if([type isEqualToString:UMShareToQQ])
    {
        itemTitle = @"QQ";
        itemImage = @"qqzone";
    }
    else if([type isEqualToString:UMShareToWechatSession])
    {
        itemTitle = @"微信好友";
        itemImage = @"weixin_share";
    }
    else if([type isEqualToString:UMShareToWechatTimeline])
    {
        itemTitle = @"微信朋友圈";
        itemImage = @"weixin_discover";
    }
    else if([type isEqualToString:UMShareToWechatFavorite])
    {
        itemTitle = @"微信收藏";
        itemImage = @"";
    }
    else if([type isEqualToString:UMShareToSina])
    {
        itemTitle = @"微博";
        itemImage = @"weibo";
    }
    else{
        NSLog(@"其他设备自行添加");
    }
    
    [itemBtn setImage:[UIImage imageNamed:itemImage] forState:UIControlStateNormal];
    
    return itemTitle;
}

#pragma mark - 点击item进行分享操作
-(void)itemClick:(UIButton *)btn{
    NSInteger index = btn.tag;
    
//    //需要自定义面板样式的开发者需要自己绘制UI，在对应的分享按钮中调用此接口
//    [UMSocialData defaultData].extConfig.title = @"分享的title";
//    [UMSocialData defaultData].extConfig.qqData.url = self.url;
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                        @"http://www.baidu.com/img/bdlogo.gif"];
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[_items[index]] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:_controller completion:^(UMSocialResponseEntity *shareResponse){
//        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.title = self.title;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
    
    UMSocialUrlResource *urlresource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:self.url];
    NSString *content = [NSString stringWithFormat:@"%@ %@",_content,_url];
     NSString *type = _items[index];
    if ([type isEqualToString:@"sina"]) {
        content = [NSString stringWithFormat:@"%@ %@",_title,_url];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:content image:_image location:nil urlResource:urlresource  presentedController:_controller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [self dismissShareView];
}


#pragma mark - 点击 取消或者蒙板 消除分享View
-(void)dismissShareView{
    [UIView animateWithDuration:0.3 animations:^{
        _buttomView.alpha = 0.0;
        _contentView.frame = CGRectMake(0, KHeight, kWidth, ShareViewHeight);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}


@end
