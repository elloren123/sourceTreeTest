//
//  ADLServicePayController.m
//  lockboss
//
//  Created by adel on 2019/6/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServicePayController.h"
#import "ADLPaySuccessController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface ADLServicePayController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation ADLServicePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"支付服务费用"];
    self.top.constant = NAVIGATION_H;
    self.bottom.constant = BOTTOM_H;
    self.aliPayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    self.wechatPayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    self.dateLab.text = [NSString stringWithFormat:@"预约时间：%@",self.dateStr];
    self.contactLab.text = [NSString stringWithFormat:@"联系人：%@",self.nameStr];
    self.phoneLab.text = [NSString stringWithFormat:@"联系人电话：%@",self.phoneStr];
    self.addressLab.text = self.addressStr;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应付金额：¥ %.2f",self.money]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(5, attributeStr.length-5)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(5, attributeStr.length-5)];
    self.payMoneyLab.attributedText = attributeStr;
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认支付 ¥ %.2f",self.money] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResult:) name:PAY_RESULT_STATUS object:nil];
}

#pragma mark ------ 支付宝支付 ------
- (IBAction)clickAlipayBtn:(UIButton *)sender {
    sender.selected = YES;
    self.wechatPayBtn.selected = NO;
    sender.userInteractionEnabled = NO;
    self.wechatPayBtn.userInteractionEnabled = YES;
}

#pragma mark ------ 微信支付 ------
- (IBAction)clickWechatPayBtn:(UIButton *)sender {
    sender.selected = YES;
    self.aliPayBtn.selected = NO;
    sender.userInteractionEnabled = NO;
    self.aliPayBtn.userInteractionEnabled = YES;
}

#pragma mark ------ 确认支付 ------
- (IBAction)clickConfirmBtn:(UIButton *)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.orderId forKey:@"orderId"];
    if (self.aliPayBtn.selected) {
        [params setValue:@"1" forKey:@"paymentId"];
    } else {
        [params setValue:@"2" forKey:@"paymentId"];
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_order_pay parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (responseDict[@"data"][@"orderInfo"]) {
                if (self.aliPayBtn.selected) {
                    [self alipayWithString:responseDict[@"data"][@"orderInfo"]];
                } else {
                    NSString *orderStr = responseDict[@"data"][@"orderInfo"];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[orderStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    [self wechatPayWithDict:dict];
                }
            } else {
                ADLPaySuccessController *successVC = [[ADLPaySuccessController alloc] init];
                successVC.serviceOrder = YES;
                [self.navigationController pushViewController:successVC animated:YES];
            }
            [ADLToast hide];
        }
    } failure:nil];
}

#pragma mark ------ 支付宝支付 ------
- (void)alipayWithString:(NSString *)orderStr {
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"alipay2018052560266007" callback:^(NSDictionary *resultDic) {
        //未安装支付宝网页支付完成回调此方法
        NSString *resultCodeStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        NSString *messageStr = @"支付失败";
        if ([resultCodeStr isEqualToString:@"9000"]) messageStr = @"支付成功";
        else if ([resultCodeStr isEqualToString:@"5000"]) messageStr = @"重复请求";
        else if ([resultCodeStr isEqualToString:@"6001"]) messageStr = @"支付已取消";
        else if ([resultCodeStr isEqualToString:@"8000"]) messageStr = @"订单处理中，请稍后查看订单状态";
        else if ([resultCodeStr isEqualToString:@"6002"]) messageStr = @"网络连接出错，请稍后查看订单状态";
        else if ([resultCodeStr isEqualToString:@"6004"]) messageStr = @"支付结果未知，请稍后查看订单状态";
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![messageStr isEqualToString:@"支付成功"]) {
                [ADLToast showMessage:messageStr];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_STATUS object:messageStr userInfo:nil];
        });
    }];
}

#pragma mark ------ 微信支付 ------
- (void)wechatPayWithDict:(NSDictionary *)dict {
    if ([WXApi isWXAppInstalled]) {
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [dict objectForKey:@"partnerid"];
        request.prepayId = [dict objectForKey:@"prepayid"];
        request.package = [dict objectForKey:@"package"];
        request.nonceStr = [dict objectForKey:@"noncestr"];
        request.timeStamp = [[dict objectForKey:@"timestamp"] unsignedIntValue];
        request.sign = [dict objectForKey:@"sign"];
        [WXApi sendReq:request completion:nil];
        
    } else {
        NSURL *wechatUrl = [NSURL URLWithString:k_wechat_download_string];
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"你还未安装微信客户端，是否前去下载？" confirmTitle:@"下载" confirmAction:^{
            [[UIApplication sharedApplication] openURL:wechatUrl];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 处理支付结果 ------
- (void)dealwithPayResult:(NSNotification *)notification {
    NSString *result = notification.object;
    if ([result containsString:@"成功"]) {
        ADLPaySuccessController *successVC = [[ADLPaySuccessController alloc] init];
        successVC.serviceOrder = YES;
        [self.navigationController pushViewController:successVC animated:YES];
    }
}

@end
