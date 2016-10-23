//
//  PaySuccessVC.m
//  MyStore
//
//  Created by Hancle on 16/8/24.
//  Copyright © 2016年 Hancle. All rights reserved.
//

#import "PaySuccessVC.h"

@interface PaySuccessVC ()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

@implementation PaySuccessVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"支付成功"];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    NSString *paytype = (self.payType == WeixinPay) ? @"微信支付" : @"支付宝支付";
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@元", self.totalPrice];
    self.payTypeLabel.text = paytype;
    
    NSString *orderIdStr = @"";
    if ([self.orderIds isKindOfClass:[NSArray class]]) {
        NSArray *arr = self.orderIds;
        for (int i = 0; i < arr.count; i ++) {
            NSString *orderid = arr[i];
            orderIdStr = [orderIdStr stringByAppendingString:orderid];
            if (i != arr.count - 1) {
                orderIdStr = [orderIdStr stringByAppendingString:@",\n"];
            }
        }
        
    }else if ([self.orderIds isKindOfClass:[NSString class]]) {
        orderIdStr = [orderIdStr stringByAppendingString:self.orderIds];
    }
    self.orderIdLabel.text = orderIdStr;
}

- (IBAction)backToMainviewBtnClick:(id)sender {
    NSLog(@"back button click");
    if ([self.navigationController respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
