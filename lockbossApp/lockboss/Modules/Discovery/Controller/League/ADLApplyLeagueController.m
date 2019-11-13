//
//  ADLApplyLeagueController.m
//  lockboss
//
//  Created by adel on 2019/6/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLApplyLeagueController.h"
#import "ADLLeagueDataView.h"
#import "ADLKeyboardMonitor.h"
#import "ADLMerchantPayView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface ADLApplyLeagueController ()<ADLLeagueDataViewDelegate,ADLMerchantPayViewDelegate>
@property (nonatomic, strong) ADLLeagueDataView *dataView;
@property (nonatomic, strong) ADLMerchantPayView *payView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) NSString *leagueId;
@property (nonatomic, assign) double securityMoney;
@property (nonatomic, assign) NSInteger period;
@end

@implementation ADLApplyLeagueController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.apply) {
        [self addNavigationView:@"我的申请"];
        [self getLeagueApplyData];
    } else {
        [self addNavigationView:@"申请备案人"];
        [self addHeadViewWithProgress:1 resubmit:NO];
        [self addDataViewWithEnable:YES resubmit:NO dict:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([ADLKeyboardMonitor monitor].enable) {
        [[ADLKeyboardMonitor monitor] setEnable:NO];
    }
}

#pragma mark ------ ADLLeagueDataViewDelegate ------
- (void)leagueInputViewDidBeginEditing:(UIView *)inputView {
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:inputView];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            if (weakSelf.dataView.updateOffset) {
                CGFloat maxOffset = weakSelf.scrollView.contentSize.height-weakSelf.scrollView.frame.size.height;
                if (offsetY > maxOffset && maxOffset > 0) {
                    [weakSelf.scrollView setContentOffset:CGPointMake(0, maxOffset) animated:YES];
                } else {
                    [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
                }
            }
        } else {
            if (bottomH < keyboardH) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetY+keyboardH-bottomH) animated:YES];
            }
        }
    };
}

- (void)updateScrollViewContentOffset {
    CGFloat MaxOffset = self.scrollView.contentSize.height-self.scrollView.frame.size.height;
    if (self.scrollView.contentOffset.y > MaxOffset) {
        [self.scrollView setContentOffset:CGPointMake(0, MaxOffset) animated:YES];
    }
}

#pragma mark ------ 提交备案 ------
- (void)didClickSubmitBtn:(NSMutableDictionary *)params {
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_record_add_person parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"申请成功"];
            if (self.applyAction) {
                self.applyAction();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ 我的备案人申请 ------
- (void)getLeagueApplyData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_record_my_apply parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (responseDict[@"data"]) {
                NSInteger status = [responseDict[@"data"][@"status"] integerValue];
                if (status == 0) {
                    [self addHeadViewWithProgress:4 resubmit:NO];
                    [self addLeagueStatusView:0];
                    
                } else if (status == 1) {
                    self.view.backgroundColor = [UIColor whiteColor];
                    [self addLeagueStatusView:1];
                    
                } else if (status == 2) {
                    [self addHeadViewWithProgress:2 resubmit:NO];
                    [self addDataViewWithEnable:NO resubmit:NO dict:responseDict[@"data"]];
                    
                } else if (status == 3) {
                    [self addHeadViewWithProgress:1 resubmit:YES];
                    [self addDataViewWithEnable:YES resubmit:YES dict:responseDict[@"data"]];
                    
                } else if (status == 4) {
                    self.leagueId = responseDict[@"data"][@"id"];
                    self.securityMoney = [responseDict[@"data"][@"waitPayMoney"] doubleValue];
                    [self addHeadViewWithProgress:3 resubmit:NO];
                    [self addPayView];
                } else {
                    
                }
            }
        }
    } failure:nil];
}

#pragma mark ------ 添加头部视图 ------
- (void)addHeadViewWithProgress:(NSInteger)progress resubmit:(BOOL)resubmit {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 75)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 20, SCREEN_WIDTH-24, 8)];
    bgView.backgroundColor = SEPARATOR_COLOR;
    bgView.layer.cornerRadius = 4;
    bgView.clipsToBounds = YES;
    [headView addSubview:bgView];
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ((SCREEN_WIDTH-24)/4)*progress, 8)];
    progressView.backgroundColor = APP_COLOR;
    [bgView addSubview:progressView];
    self.progressView = progressView;
    
    NSArray *titArr;
    if (resubmit) {
        titArr = @[@"重新提交",@"等待审核",@"支付保证金",@"申请完成"];
    } else {
        titArr = @[@"提交资料",@"等待审核",@"支付保证金",@"申请完成"];
    }
    for (int i = 0; i < 4; i++) {
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*i, 45, SCREEN_WIDTH/4, 18)];
        titLab.font = [UIFont systemFontOfSize:13];
        titLab.textColor = COLOR_333333;
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.text = titArr[i];
        [headView addSubview:titLab];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4)*i+SCREEN_WIDTH/8-8, 16, 16, 16)];
        if (i < progress) {
            imgView.image = [UIImage imageNamed:@"apply_round_selected"];
        } else {
            imgView.image = [UIImage imageNamed:@"apply_round_normal"];
        }
        [headView addSubview:imgView];
        [self.dataArr addObject:imgView];
    }
}

#pragma mark ------ 添加dataView ------
- (void)addDataViewWithEnable:(BOOL)enable resubmit:(BOOL)resubmit dict:(NSDictionary *)dict {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-83)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, 1172);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    ADLLeagueDataView *dataView = [[NSBundle mainBundle] loadNibNamed:@"ADLLeagueDataView" owner:nil options:nil].lastObject;
    dataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1172);
    dataView.delegate = self;
    [scrollView addSubview:dataView];
    self.dataView = dataView;
    
    if (resubmit) {
        [dataView.confirmBtn setTitle:@"重新提交" forState:UIControlStateNormal];
    }
    
    if (enable) {
        [[ADLKeyboardMonitor monitor] setEnable:YES];
    } else {
        [dataView setInputViewUneditable];
    }
    
    if (dict) {
        [dataView updateInputViewWithDictionary:dict];
    }
}

#pragma mark ------ 添加支付视图 ------
- (void)addPayView {
    self.period = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResult:) name:PAY_RESULT_STATUS object:nil];
    ADLMerchantPayView *payView = [[NSBundle mainBundle] loadNibNamed:@"ADLMerchantPayView" owner:nil options:nil].lastObject;
    payView.frame = CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-83);
    payView.dueTF.placeholder = @"请输入合约期限(单位:月)";
    payView.titleLab.text = @"支付明细";
    payView.dueLab.text = @"合约期限";
    payView.height.constant = 135;
    payView.delegate = self;
    [self.view addSubview:payView];
    self.payView = payView;
}

#pragma mark ------ 合约期限改变 ------
- (void)contractPeriodDidChanged:(NSInteger)period {
    self.period = period;
    self.payView.depositLab.text = [NSString stringWithFormat:@"%.2f 元",period*self.securityMoney];
    [self.payView.payBtn setTitle:[NSString stringWithFormat:@"确认支付 %.2f 元",period*self.securityMoney] forState:UIControlStateNormal];
}

#pragma mark ------ 确认支付 ------
- (void)didClickPayBtn:(UIButton *)sender {
    if (self.period == 0) {
        [ADLToast showMessage:@"请输入合约期限"];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.leagueId forKey:@"recordId"];
    [params setValue:@(self.period) forKey:@"month"];
    NSString *type = @"2";
    if (self.payView.alipayBtn.selected) {
        type = @"1";
    }
    [params setValue:type forKey:@"paymentId"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_recorder_pay parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (responseDict[@"data"][@"orderInfo"]) {
                if ([type isEqualToString:@"1"]) {
                    [self alipayWithString:responseDict[@"data"][@"orderInfo"]];
                } else {
                    NSString *orderStr = responseDict[@"data"][@"orderInfo"];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[orderStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    [self wechatPayWithDict:dict];
                }
            } else {
                [self addPaySuccessView];
            }
            [ADLToast hide];
        }
    } failure:nil];
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

#pragma mark ------ 处理支付结果 ------
- (void)dealwithPayResult:(NSNotification *)notification {
    NSString *result = notification.object;
    if ([result containsString:@"成功"]) {
        [self addPaySuccessView];
    }
}

#pragma mark ------ 添加备案成功、账号禁用视图 ------
- (void)addLeagueStatusView:(NSInteger)status {
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 90, 80, 80)];
    [successView addSubview:imageView];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 190, SCREEN_WIDTH-34, 30)];
    promptLab.font = [UIFont boldSystemFontOfSize:16];
    promptLab.textAlignment = NSTextAlignmentCenter;
    promptLab.textColor = COLOR_333333;
    [successView addSubview:promptLab];
    
    if (status == 0) {
        imageView.image = [UIImage imageNamed:@"review_success"];
        promptLab.text = @"申请成功";
    } else {
        successView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
        imageView.image = [UIImage imageNamed:@"review_fail"];
        promptLab.text = @"您申请的备案人已被禁用";
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(12, 260, SCREEN_WIDTH-24, 45);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:confirmBtn];
}

#pragma mark ------ 支付成功视图 ------
- (void)addPaySuccessView {
    self.progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH-24, 8);
    [self.dataArr enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = [UIImage imageNamed:@"apply_round_selected"];
    }];
    [self.payView removeFromSuperview];
    
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+83, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"您的商家后台信息稍后会发送到您\n绑定的手机号，注意查看~"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 7;
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeStr.length)];
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, SCREEN_WIDTH-60, 50)];
    promptLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    promptLab.textColor = COLOR_333333;
    promptLab.numberOfLines = 2;
    promptLab.attributedText = attributeStr;
    promptLab.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:promptLab];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(12, 220, SCREEN_WIDTH-24, 45);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:confirmBtn];
}

- (void)clickConfirmBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
