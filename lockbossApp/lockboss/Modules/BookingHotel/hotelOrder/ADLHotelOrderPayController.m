//
//  ADLHotelOrderPayController.m
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderPayController.h"
#import "ADLHotelOrderPayCell.h"
#import "ADLBookingHotelModel.h"
#import "ADLHotelOrderListController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface ADLHotelOrderPayController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic,copy)NSString *result;
@property (nonatomic ,strong)NSString *orderId;//区块链订单ID

@end

@implementation ADLHotelOrderPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView:ADLString(@"选择支付方式")];
    //  self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
  
    //支付宝返回通知结果
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResultOrder:) name:PAY_RESULT_ORDER object:nil];
      //微信返回通知结果
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithPayResultOrderWX:) name:PAY_RESULT_STATUS object:nil];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ADLHotelOrderPayCell *cell = [ADLHotelOrderPayCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"icon_pay_weixin"];
        cell.name.text = ADLString(@"微信支付");
        cell.title.text = ADLString(@"推荐微信用户使用");
    }else  if(indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"icon_pay_zfb"];
         cell.name.text = ADLString(@"支付宝支付");
        cell.title.text = ADLString(@"推荐支付宝用户使用");
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    if (self.payType == 1) {
              //区块链
        [self userblockchainpay:indexPath.row+1];
    }else    if (self.payType == 2) {
        //酒店预订
      [self roomSellOrder:indexPath.row+1];
        
    }
}
#pragma mark  ------酒店预订支付购买
-(void)roomSellOrder:(NSInteger)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] = self.roomSellOrderId;//订单id
    params[@"type"] = @(type);//1 微信 2 淘宝 3 其它（网联）
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_roomSellOrder_pay parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        if ([responseDict[@"code"] integerValue] == 10000) {
          //  NSDictionary *dict = responseDict[@"data"];
       
            
            if (type == 1) {    //微信支付
                [ws wechatPayWithDict:responseDict[@"data"]];
            } else {
                   //淘宝
                [ws alipayWithString:responseDict[@"data"][@"bizContent"]];
            }
        }
     
    } failure:^(NSError *error) {
   
    }];
}
#pragma mark  ------区块链支付购买
-(void)userblockchainpay:(NSInteger)type{
    //dict[@"F0FE6BF23EBA"];
    if (type == 1) {
        type=1;;//1 微信 2 淘宝 3 其它（网联）
    }else {
        type =2;//1 微信 2 淘宝 3 其它（网联）
    }
    WS(ws);
  
    self.dict[@"payType"] =@(type);//1 微信 2 淘宝 3 其它（网联）
    self.dict[@"sign"] = [ADLUtils handleParamsSign:self.dict];
    //进行POST请求
    [ADLNetWorkManager postWithPath:ADEL_userblockchain_pay parameters:self.dict autoToast:YES success:^(NSDictionary *responseDict) {
        [ADLToast hide];
        // ADLLog(@"%@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
              ws.orderId = responseDict[@"data"][@"blockchainId"];
            if (type == 1) {    //微信支付
                [ws wechatPayWithDict:responseDict[@"data"]];
            } else {
                //淘宝
                [ws alipayWithString:responseDict[@"data"][@"bizContent"]];
            }
            
        }else {
            
            [ADLToast showMessage:responseDict[@"mag"]];
        }
    }  failure:^(NSError *error) {
        
        [ADLToast hide];
    }];
    
}

#pragma mark ------ 微信支付 ------
- (void)wechatPayWithDict:(NSDictionary *)dict {
    if ([WXApi isWXAppInstalled]) {
        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = dict[@"appId"];
        // 商家id，在注册的时候给的
        req.partnerId = dict[@"partnerId"];
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  =  dict[@"prepayId"];
        // 根据财付通文档填写的数据和签名
        req.package  = dict[@"wxPackage"];
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  =  dict[@"noncestr"];
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        NSString * stamp =  dict[@"timestamp"];
        req.timeStamp = stamp.intValue;
        // 这个签名也是后台做的
        req.sign =  dict[@"sign"];
        //发送请求到微信，等待微信返回onResp
      [WXApi sendReq:req completion:nil];
//        [WXApi sendReq:req completion:^(BOOL success) {
//            if (success == YES) {
//                //payType 1 区块链支付 2酒店预订支付
//                if (self.payType == 1 ) {
//                      [self payBlocktype:@"1" result:nil];
//                }else {
//                   [self paySuccesstype:@"1" result:nil];
//                }
//
//            }
//
//        }];
   

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
        self.result =resultDic[@"result"];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_ORDER object:resultDic userInfo:nil];
        });
    }];
}

#pragma mark ------ 支付宝处理支付结果 ------
- (void)dealwithPayResultOrder:(NSNotification *)notification {
    
    
    NSDictionary *dict = notification.object;
    
    if (self.payType == 1) {
        if ([dict[@"resultStatus"] isEqualToString:@"9000"]){
           
        [self payBlocktype:@"2" result:dict[@"result"]];
        }
       
    }else  if (self.payType == 2) {
        if ([dict[@"resultStatus"] isEqualToString:@"9000"]){
            [self paySuccesstype:@"2" result:dict[@"result"]];
        }
    }
   
}
#pragma mark ------ 微信处理支付结果 ------
-(void)dealwithPayResultOrderWX:(NSNotification *)notification {
    
    NSString *result = notification.object;
    if ([result containsString:@"成功"]) {
        if (self.payType == 1 ) {
            [self payBlocktype:@"1" result:nil];
        }else  if (self.payType == 2) {
            [self paySuccesstype:@"1" result:nil];
        }
    }
}

#pragma mark ------ 酒店预订支付结果 ------
-(void)paySuccesstype:(NSString *)type result:(NSString *)result{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"roomSellOrderId"] = self.roomSellOrderId;//订单id
    params[@"type"] = type;//1 微信 2 淘宝 3 其它（网联）
    if ([type isEqualToString:@"2"]) {
       params[@"result"] = result;//返回结果（支付宝）
    }

    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_hotel_roomSellOrder_payresult parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            //[ws.navigationController popViewControllerAnimated:YES];
              [ws.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }

    } failure:^(NSError *error) {
       
    }];
}

//区块链支付 用户付款成功 用户端使用
-(void)payBlocktype:(NSString *)type result:(NSString *)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"blockchainId"] = self.orderId; //区块链订单id
    params[@"type"] = type;//1 微信 2 淘宝 3 其它（网联
    if ([type isEqualToString:@"2"]) {
        params[@"result"] = result;//返回结果（支付宝）
    }
    params[@"sign"] = [ADLUtils handleParamsSign:params];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    WS(ws);
    [ADLNetWorkManager postWithPath:ADEL_blockchainpay_result parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        // ADLLog(@"%@",response);
        [ADLToast hide];
        [ADLToast showMessage:responseDict[@"msg"]];
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            //  [[NSNotificationCenter defaultCenter] postNotificationName:ADELreservationNotification object:nil userInfo:nil];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [ws.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [ADLToast hide];
    }];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVIGATION_H,SCREEN_WIDTH,SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // _tableView.bounces = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        // _tableView.alpha = 0.7;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}
@end
