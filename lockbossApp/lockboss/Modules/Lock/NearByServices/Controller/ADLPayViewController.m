//
//  ADLPayViewController.m
//  lockboss
//
//  Created by bailun91 on 2019/9/6.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLPayViewController.h"
#import "ADLDidPaidViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface ADLPayViewController ()

@property (nonatomic, strong) UILabel *timeLbl; //计时label
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *wechatImg;
@property (nonatomic, strong) UIImageView *alipayimg;
@property (nonatomic, strong) UIImageView *daifuImg;
@property (nonatomic, assign) int         timeNumber;   //倒计时时间: 初始为600s
@property (nonatomic, assign) int         payType;      //支付方式: 1表示微信; 2表示支付宝; 3表示代付;
@property (nonatomic,   copy) NSString    *orderId;     //订单Id

@end

@implementation ADLPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationView];
    [self createContentViews];
    [self setupTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResult:) name:PAY_RESULT_STATUS object:nil];
    
    if (self.FromOrdersVCFlag) {
        [self getStoreInfo:@"1"];
    }
}

- (void)createNavigationView {
    NSLog(@"orderDict = %@", self.orderDict);
    
    //导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    backBtn.tag = 101;
    [backBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //标题
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, STATUS_HEIGHT, SCREEN_WIDTH/2, NAV_H)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:16];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = @"支付订单";
    [navView addSubview:titLab];
    
    
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT-125, SCREEN_WIDTH-50, 44)];
    payBtn.backgroundColor = COLOR_E0212A;
    payBtn.layer.cornerRadius = 5.0;
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [payBtn setTitle:[NSString stringWithFormat:@"确认支付￥%@", self.totalMoney] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = 102;
    [self.view addSubview:payBtn];
}
#pragma mark ------ 按钮点击事件 ------
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 102:
            [self submitOrderAndToPay];
            break;
            
        case 201:
        case 202:
//        case 203:
            if (self.payType != (int)sender.tag-200) {
                self.payType = (int)sender.tag-200;
                [self updateImageView];
            }
            break;
            
            
        default:
            break;
    }
}
- (void)updateImageView {
    if (self.payType == 1) {
        self.wechatImg.image = [UIImage imageNamed:@"icon_xuanzhong"];
        self.alipayimg.image = [UIImage imageNamed:@"icon_kong"];
        self.daifuImg.image = [UIImage imageNamed:@"icon_kong"];
    
    } else if (self.payType == 2) {
        self.wechatImg.image = [UIImage imageNamed:@"icon_kong"];
        self.alipayimg.image = [UIImage imageNamed:@"icon_xuanzhong"];
        self.daifuImg.image = [UIImage imageNamed:@"icon_kong"];
        
    } else {
        self.wechatImg.image = [UIImage imageNamed:@"icon_kong"];
        self.alipayimg.image = [UIImage imageNamed:@"icon_kong"];
        self.daifuImg.image = [UIImage imageNamed:@"icon_xuanzhong"];
    }
}

- (void)createContentViews {
    self.timeNumber = 600;
    
    UILabel *leadLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 30+NAVIGATION_H, SCREEN_WIDTH-40, 20)];
    leadLab.textAlignment = NSTextAlignmentCenter;
    leadLab.font = [UIFont systemFontOfSize:14];
    leadLab.textColor = [UIColor grayColor];
    leadLab.text = @"支付剩余时间: 10:00";
    [self.view addSubview:leadLab];
    self.timeLbl = leadLab;
    
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 50+NAVIGATION_H, SCREEN_WIDTH-40, 40)];
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.font = [UIFont systemFontOfSize:28];
    priceLab.textColor = [UIColor blackColor];
    priceLab.text = self.totalMoney;
    [self.view addSubview:priceLab];
    
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 90+NAVIGATION_H, SCREEN_WIDTH-40, 20)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.textColor = [UIColor grayColor];
    nameLab.text = self.shopName;
//    nameLab.text = @"东江水饺(西丽店)";
    [self.view addSubview:nameLab];
    
    
    self.payType = 1;
//    NSArray *txtArray = @[@"微信支付", @"支付宝支付", @"代付"];
    NSArray *txtArray = @[@"微信支付", @"支付宝支付"];
    for (int i = 0 ; i < txtArray.count; i++) {
        UIButton *labBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 130+NAVIGATION_H+50*i, SCREEN_WIDTH-40, 50)];
        [labBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        labBtn.tag = 201+i;
        [self.view addSubview:labBtn];
        
        
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 30, 24)];
        [labBtn addSubview:iconImg];
        
        
        UILabel *lead = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, SCREEN_WIDTH/2, 50)];
        lead.textAlignment = NSTextAlignmentLeft;
        lead.font = [UIFont systemFontOfSize:16];
        lead.textColor = [UIColor darkGrayColor];
        lead.text = txtArray[i];
        [labBtn addSubview:lead];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH-40, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [labBtn addSubview:line];
        
        
        UIImageView *selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 15, 20, 20)];
        selectImg.image = [UIImage imageNamed:@"icon_kong"];
        [labBtn addSubview:selectImg];
        
        
        if (i == 0) {
            iconImg.image = [UIImage imageNamed:@"icon_pay_weixin"];
            selectImg.image = [UIImage imageNamed:@"icon_xuanzhong"];
            self.wechatImg = selectImg;
            
        } else if ( i == 1) {
            iconImg.image = [UIImage imageNamed:@"icon_pay_zfb"];
            self.alipayimg = selectImg;
            
        } else if ( i == 2) {
            iconImg.image = [UIImage imageNamed:@"icon_pay_daifu"];
            line.hidden = YES;
            self.daifuImg = selectImg;
        }
    }
}

#pragma mark ------ 初始化Timer ------
- (void)setupTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    
    self.timeNumber = 600;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)timeCountDown {
    self.timeNumber -= 1;
    NSString *min = [NSString stringWithFormat:@"%d", self.timeNumber/60];
    if (min.intValue < 10) {
        min = [NSString stringWithFormat:@"0%@", min];
    }
    
    NSString *sec = [NSString stringWithFormat:@"%d", self.timeNumber%60];
    if (sec.intValue < 10) {
        sec = [NSString stringWithFormat:@"0%@", sec];
    }
    self.timeLbl.text = [NSString stringWithFormat:@"支付剩余时间: %@:%@", min, sec];
    
    if (self.timeNumber == 0) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        [ADLToast showMessage:@"支付超时 !!!" duration:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark ------ 下单并且支付 ------
- (void)submitOrderAndToPay {
    NSLog(@"下单!!!");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];//权限
    
    if (self.FromOrdersVCFlag) {
        [params setValue:self.orderDict[@"id"] forKey:@"id"];//订单Id
        [params setValue:[NSString stringWithFormat:@"%d", self.payType] forKey:@"payType"];//支付方式: 1微信 2支付宝 3其他
        
    } else {
        [params setValue:self.storeId forKey:@"storeId"];//商家Id
        [params setValue:[NSString stringWithFormat:@"%d", self.payType] forKey:@"payType"];//支付方式: 1微信 2支付宝 3其他
        [params setValue:self.orderDict[@"appointmentTime"] forKey:@"appointmentTime"];//预约送达的时间戳
        [params setValue:self.orderDict[@"id"] forKey:@"addrId"];//收货地址ID
        [params setValue:self.orderDict[@"companyId"] forKey:@"companyId"];//酒店ID
        [params setValue:self.orderDict[@"tablewareNum"] forKey:@"tablewareNum"];//餐具数量
        
        //备注信息
        if (self.orderDict[@"userMsg"]) {
            [params setValue:self.orderDict[@"userMsg"] forKey:@"userMsg"];
        }
    }
    
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/order/addAndPay.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"下单返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功

            self.orderId = responseDict[@"data"][@"orderId"];//订单Id
            if (self.payType == 1) {    //微信支付
                [self wechatPayWithDict:responseDict[@"data"]];
            } else {
                [self alipayWithString:responseDict[@"data"][@"bizContent"]];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
    }];
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
        request.prepayId  = [dict objectForKey:@"prepayid"];
        request.package   = [dict objectForKey:@"package"];
        request.nonceStr  = [dict objectForKey:@"noncestr"];
        request.timeStamp = [[dict objectForKey:@"timestamp"] unsignedIntValue];
        request.sign      = [dict objectForKey:@"sign"];
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
        //发通知(当从订单列表跳转过来并支付成功时)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DID_TO_PAY_SUCCESS_NOTICATION" object:nil];
        
        ADLDidPaidViewController *vc = [[ADLDidPaidViewController alloc] init];
        vc.stoImgUrl = self.stoImgUrl;
        vc.orderId  = self.orderId;
        vc.storeId  = self.storeId;
        vc.shopName = self.shopName;
        vc.sendBill = self.sendBill;
        vc.storeLocation = self.storeLocation;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ------ 获取商家信息 ------
//type: 1.基本信息 2.资质信息，3.法定代表人信息，4.合作信息
-(void)getStoreInfo:(NSString *)type {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.storeId forKey:@"id"];
    [params setValue:type         forKey:@"type"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    //请求数据
    [ADLNetWorkManager postWithPath:[ADLUtils splicingPath:@"hotel-around/store/queryStoreById.do"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"请求商家基本信息返回: %@", responseDict);
        
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            self.storeLocation = responseDict[@"data"][@"nowLocation"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
    }];
}

@end
