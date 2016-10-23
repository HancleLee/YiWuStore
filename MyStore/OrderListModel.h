//
//  OrderListModel.h
//  MyStore
//
//  Created by Hancle on 16/10/1.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "SuperModel.h"
#import "AddressModel.h"
#import "ShopCartModel.h"
#import "CommentModel.h"

@interface AfterSaleService : SuperModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger status;

@end

@interface OrderList : SuperModel

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *payId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopLogo;
@property (nonatomic, copy) NSString *shopLogoThumb;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *payWay;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger payTime;
@property (nonatomic, assign) NSInteger deliverTime;
@property (nonatomic, assign) NSInteger receiveTime;
@property (nonatomic, strong) NSArray *goodsList;
@property (nonatomic, copy) NSArray *comment;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) AfterSaleService *afterSaleService;

@property (nonatomic, copy) NSString *createTimeStr;
@property (nonatomic, copy) NSString *payTimeStr;
@property (nonatomic, copy) NSString *deliverTimeStr;
@property (nonatomic, copy) NSString *receiveTimeStr;

- (void)details;

@end

@interface OrderListModel : SuperModel

@property (nonatomic, strong) NSArray *data;

@end
