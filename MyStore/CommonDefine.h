//
//  CommonDefine.h
//
//
//  Created by hubin on 15/1/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#import "AFNetWorkingTool.h"
#import "CommonFunction.h"
#import "ClassCategory.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "RequestHelper.h"
//#import "UserdefaultHelper.h"
#import "MJRefresh.h"
//#import "MeManager.h"
#import <YYModel.h>
#import "MBprogressHUD.h"
#import "UIImageView+WebCache.h"
#import "ArchiverHelper.h"
#import "CustomAlertViewHelper.h"

/// 请求接口 状态码,提示语
#define StatusRequestSuccess  0         // 请求成功
#define StatusNotLogin        - 10      // 用户未登录
#define StatusRequestFail     - 1       // 请求失败
#define RequestFailTipText  @"请求失败" // 请求失败的提示语
#define RequestSuccessTip @"请求成功"   // 请求成功的提示语

/// 系统版本信息
#define iOSVersion [[UIDevice currentDevice] systemVersion]
#define iOS6       ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
#define iOS7       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)


#define ScreenWidth     [UIScreen mainScreen].bounds.size.width   // 当前屏幕宽
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height  // 当前屏幕高 e.480 568
#define IS480          ([UIScreen mainScreen].bounds.size.height == 480)
#define IS568          ([UIScreen mainScreen].bounds.size.height == 568)
#define IS667          ([UIScreen mainScreen].bounds.size.height == 667)
#define IS736          ([UIScreen mainScreen].bounds.size.height == 736)

/// 常用宏定义
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kApplication        [UIApplication sharedApplication]
#define kAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kFileManager        [NSFileManager defaultManager]
#define kBundle             [NSBundle mainBundle]
#define kDevice             [UIDevice currentDevice]
#define kWindow             [[UIApplication sharedApplication] keyWindow]
#define kInfoDictionary     [[NSBundle mainBundle] infoDictionary]
#define kBundleVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kDocumentPath       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define BundleLoadNibName(name) [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject]

/// 颜色
#define BlackColor     [UIColor blackColor]      // 0.0 white
#define DarkGrayColor  [UIColor darkGrayColor]   // 0.333 white
#define LightGrayColor [UIColor lightGrayColor]  // 0.667 white
#define WhiteColor     [UIColor whiteColor]      // 1.0 white
#define GrayColor      [UIColor grayColor]       // 0.5 white
#define RedColor       [UIColor redColor]        // 1.0, 0.0, 0.0 RGB
#define GreenColor     [UIColor greenColor]      // 0.0, 1.0, 0.0 RGB
#define BlueColor      [UIColor blueColor]       // 0.0, 0.0, 1.0 RGB
#define CyanColor      [UIColor cyanColor]       // 0.0, 1.0, 1.0 RGB
#define YellowColor    [UIColor yellowColor]     // 1.0, 1.0, 0.0 RGB
#define MagentaColor   [UIColor magentaColor]    // 1.0, 0.0, 1.0 RGB
#define OrangeColor    [UIColor orangeColor]     // 1.0, 0.5, 0.0 RGB
#define PurpleColor    [UIColor purpleColor]     // 0.5, 0.0, 0.5 RGB
#define BrownColor     [UIColor brownColor]      // 0.6, 0.4, 0.2 RGB
#define ClearColor     [UIColor clearColor]      // 0.0 white, 0.0 alpha
#define MainRedColor   [UIColor colorWithRed:0.949 green:0.212 blue:0.298 alpha:1.00]   // 主红色
#define MainBackColor  [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00]   // 主背景色
#define SectionTitleColor [UIColor colorWithRed:0.400 green:0.400 blue:0.400 alpha:1.00]
#define MainBlackColor  [UIColor colorWithRed:0.216 green:0.216 blue:0.216 alpha:1.00]
#define MainGrayColor   [UIColor colorWithRed:0.451 green:0.451 blue:0.451 alpha:1.00]    // 主灰色


#define RGBColor(_r, _g, _b)        [UIColor colorWithRed:(_r)/255.0 green:(_g)/255.0 blue:(_b)/255.0 alpha:1.0f]
#define RGBColor_a(_r, _g, _b, _a)  [UIColor colorWithRed:(_r)/255.0 green:(_g)/255.0 blue:(_b)/255.0 alpha:_a]
#define RGBColor_f(_f)              [UIColor colorWithRed:((float)((_f & 0xFF0000) >> 16))/255.0 green:((float)((_f & 0xFF00)>> 8))/255.0 blue:((float) (_f & 0xFF))/255.0 alpha:1.0f]

/// 常用方法宏定义
#define ImageNamed(_name)   [UIImage imageNamed:_name]
#define URLWithString(str)  [NSURL URLWithString:str]
#define FontSize(_size)     [UIFont systemFontOfSize:_size]
#define HeiTiFont(_size)    [UIFont fontWithName:@"HelveticaNeue" size:_size]
#define StringNil(str)      ([str isEqualToString:@""] || str == nil)

/// 快速拼接字符串
#define StringWithFomat2(str1, str2) [NSString stringWithFormat:@"%@%@", str1, str2]
#define StringWithFomat3(str1, str2, str3) [NSString stringWithFormat:@"%@%@%@", str1, str2, str3]
#define StringWithFomat4(str1, str2, str3, str4) [NSString stringWithFormat:@"%@%@%@%@", str1, str2, str3, str4]

/// 通知
#define NOTI_UPDATE_USER_SUCCESS    @"noti_update_user_success"
#define NOTI_GET_STOKEN_SUCCESS     @"noti_get_stoken_success"

// 请求ip地址
#define IP_ADDRESS          @"http://120.24.69.203:8080" // ip 地址
#define IPGetPhoneCode      @"/common/sendPhoneCode" //获取验证码
#define IPUserLogin         @"/user/login"    // 登录
#define IPUserThirdLogin    @"/user/thirdLogin"   // 第三方登录
#define IPUserLogout        @"/user/logout" // 退出登录
#define IPUserRegister      @"/user/register"    // 注册
#define IPFindPassword      @"/user/findPassword"    // 找回密码
#define IPUpdatePsw         @"/user/updatePassword" // 修改密码
#define IPUpdateInfo        @"/user/updateInfo" // 更新个人信息
#define IPUploadImage       @"/service/upload/image" // 上传图片
#define IPComInfo           @"/community/info"
#define IPComPublish        @"/community/publish" // 社区 分享
#define IPComInfoList       @"/community/infoList" // 社区 列表
#define IPShopInfo          @"/shop/info"   // 商店信息
#define IPShopInfoList      @"/shop/infoList"    // 商店列表
#define IPGoodsInfoList     @"/goods/infoList" // 商品列表
#define IPCartAdd           @"/cart/add"    // 添加购物车
#define IPCartInfoList      @"/cart/infoList"  // 购物车列表
#define IPFeedBackAdd       @"/feedback/add"    // 意见反馈
#define IPAddAddress        @"/user/address/add"   // 添加地址
#define IPAddressDelete     @"/user/address/delete" // 删除地址
#define IPAddressUpdate     @"/user/address/update" // 修改地址
#define IPAddressList       @"/user/address/infoList" // 收货地址列表
#define IPOrderCreat        @"/order/create"   // 创建订单
#define IPOrderCancel       @"/order/cancel"  // 取消订单
#define IPOrderInfoList     @"/order/infoList" // 获取订单列表
#define IPHomePage          @"/page/home"  // 首页
#define IPSortList          @"/sort/infoList"   // 商品分类列表
#define IPCollectEdit       @"/collect/edit"  // 收藏／取消收藏
#define IPCollectionList    @"/collect/infoList" // 收藏列表
#define IPPayWXAppOrder     @"/pay/wx/appOrder"     // 微信预支付接口
#define IPPayAliPayOrder    @"/pay/alipay/signatures"   // 支付宝
#define IPCommentPublish    @"/comment/publish" // 发布评论
#define IPCommentDelete     @"/comment/delete"  // 删除评论
#define IPCommentInfoList   @"/comment/infoList"    // 评论列表
#define IPReceiveOrder      @"/order/receive"   // 确认收货
#define IPAfterSaleService  @"/order/applyAfterSaleService"//申请售后
#define IPMessageInfoList  @"/message/infoList"   //我的消息列表

/// 归档key
#define ARCH_USER       @"arch_user"
#define ARCH_SORT_LIST  @"arch_sort_list"

/// 平台信息
#define WXAppID         @"wxd842e65051017e61"   // 微信appID
#define WXAppSecret     @"83528040201236a6b4369717461c0f59" // 微信appSecret
#define QQAppID         @"1105639243"   // QQ AppID
#define QQAppKey        @"Taq0TUycAx0LFeTT" // QQ AppKey
#define WBAppID         @"1513426131"       // 微博appid
#define WBAppSecret     @"c224add7720bc125b6d74663056c9b75" // 微博app secrect
#define WBDirectURL     @"http://sns.whalecloud.com/sina2/callback"
#define UMAppKey        @"57f0895167e58e02cc004405" // 友盟appkey
#define ShareUrl        @"http://www.foshanyiwu.com"    // 分享默认地址

/// 其它信息
#define HUDShowTime         2
#define TOKEN               [CommonFunction getUserToken]
#define DEFAULT_PIC         [UIImage imageNamed:@"defaultImg"]
#define DEFAULT_AVATAR      nil
#define REQUEST_DATA_COUNT  @"2"
#define URL_PIC(url)        [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP_ADDRESS,url]]

#define Pic_Sd_Set(imgview)with(url)    [imgview sd_setImageWithURL:URL_PIC(url) placeholderImage:DEFAULT_PIC];
#define Is_Url(url) [url containsString:@"http:"] || [url containsString:@"https:"]



#define PRICE_TEXT(pri) [NSString stringWithFormat:@"¥%.2f",[pri floatValue]]

/// 仅调试环境打印，生产环境不会打印
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

typedef NS_ENUM(NSInteger, HKOrderStatus) {
    Wait_pay_order = 0,     // 待付款
    Wait_receive_order = 1, // 已付款/待收货
    Finish_order = 2,       // 已收货
    Cancel_order = 3,       // 已取消
    After_sale = 4          // 售后订单
};

typedef NS_ENUM(NSInteger, HKAfterSaleType) {
    After_sale_dealing,     // 处理中
    After_sale_done         // 退款成功
};

typedef NS_ENUM(NSInteger, HKPayType) { // 付款方式
    AliPay,         // 支付宝支付
    WeixinPay       // 微信支付
};

#endif
