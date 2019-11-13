//
//  AppDelegate.m
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "AppDelegate.h"
#import "ADLNavigationController.h"
#import "ADLWelcomeController.h"
#import "ADLTabBarController.h"
#import "ADLLoginController.h"

#import "WXApi.h"
#import <JMessage/JMessage.h>
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()<WXApiDelegate,QQApiInterfaceDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [self checkDeviceToken];
    
    ADLTabBarController *tabVC = [[ADLTabBarController alloc] init];
    window.rootViewController = tabVC;
    [window makeKeyAndVisible];
    self.window = window;
    
    //设置默认值
    [[UITextView appearance] setTintColor:APP_COLOR];
    [[UITextField appearance] setTintColor:APP_COLOR];
    [[UINavigationBar appearance] setTranslucent:NO];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    //3DTouch
    //    [self setup3DTouch:application];
    
    //微信QQ
    [WXApi registerApp:WEACHAT_APPID universalLink:@"https://testshop.adellock.com/lockboss/"];
    (void)[[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:nil];
    
    //高德地图
    [AMapServices sharedServices].apiKey = AMAP_KEY;
    [AMapServices sharedServices].enableHTTPS = YES;
    
    //极光IM
    [JMessage setupJMessage:launchOptions appKey:JG_KEY channel:nil apsForProduction:YES category:nil messageRoaming:YES];
    
    return YES;
}

#pragma mark ------ 应用回调 ------
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *urlStr = url.absoluteString;
    if ([urlStr containsString:@"tencent101550437://response"]) {
        return [QQApiInterface handleOpenURL:url delegate:self];//QQ分享
    } else if ([urlStr containsString:@"tencent101550437://qzapp"]) {
        return [TencentOAuth HandleOpenURL:url];//QQ登录
    } else if ([urlStr containsString:@"alipay2018052560266007"]) {
        return [self handleAlipayCallback:url];//支付宝支付
    } else {
        return YES;
    }
}

#pragma mark ------ 微信回调 ------
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if ([userActivity.webpageURL.absoluteString hasPrefix:@"https://testshop.adellock.com/lockboss/wx9533173c44a31420"]) {
        return [WXApi handleOpenUniversalLink:userActivity delegate:self];//微信登录、支付
    } else {
        return YES;
    }
}

#pragma mark ------ QQ分享，微信登录、支付、分享 代理 ------
- (void)onResp:(id)resp {
    if ([resp isKindOfClass:[PayResp class]]) {///微信支付
        NSString *messageStr = @"支付失败";
        PayResp *response = (PayResp *)resp;
        int errorCode = response.errCode;
        if (errorCode == 0) messageStr = @"支付成功";
        else if (errorCode == -2) messageStr = @"支付已取消";
        if (![messageStr isEqualToString:@"支付成功"]) {
            [ADLToast showMessage:messageStr];
        }
        //返回订单信息
      
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_STATUS object:messageStr userInfo:nil];
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {///微信登录
        SendAuthResp *wxLoginResp = (SendAuthResp *)resp;
        if (wxLoginResp.errCode == 0) {
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLogin" object:wxLoginResp.code userInfo:nil];
        } else {
            [ADLToast showMessage:@"登录失败"];
        }
        
    } else {
        NSString *messageStr = @"分享失败";
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {///微信分享
            SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
            int errorCode = sendResp.errCode;
            if (errorCode == 0) messageStr = @"分享完成";
        } else {///QQ分享
            SendMessageToQQResp *resultResp = (SendMessageToQQResp *)resp;
            int resultCode = [resultResp.result intValue];
            if (resultCode == 0) messageStr = @"分享成功";
        }
        [ADLToast showMessage:messageStr];
    }
}

#pragma mark ------ 支付宝支付回调 ------
- (BOOL)handleAlipayCallback:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
        NSString *messageStr = @"支付失败";
        if (resultCode == 9000) messageStr = @"支付成功";
        else if (resultCode == 5000) messageStr = @"重复请求";
        else if (resultCode == 6001) messageStr = @"支付已取消";
        else messageStr = @"订单处理中，请稍后查看订单状态";
        
        if (![messageStr isEqualToString:@"支付成功"]) {
            [ADLToast showMessage:messageStr];
        }
        //返回订单信息
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_ORDER object:resultDic userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_STATUS object:messageStr userInfo:nil];
    }];
    return YES;
}

#pragma mark ------ 检测是否已保存DeviceToken ------
- (void)checkDeviceToken {
    NSString *dt = [ADLUtils valueForKey:DEVICE_TOKEN];
    if (dt == nil) {
        NSString *timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
        NSString *randomStr = [NSString stringWithFormat:@"%d",arc4random_uniform(10000000)];
        NSString *md5Str1 = [ADLUtils md5Encrypt:timestamp lower:YES];
        NSString *md5Str2 = [ADLUtils md5Encrypt:randomStr lower:YES];
        dt = [NSString stringWithFormat:@"%@%@",md5Str1,md5Str2];
        [ADLUtils saveValue:dt forKey:DEVICE_TOKEN];
    }
}

#pragma mark ------ 3D Touch ------
- (void)setup3DTouch:(UIApplication *)application {
    UIApplicationShortcutIcon *lockIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_lock"];
    UIApplicationShortcutIcon *qrIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_qr"];
    UIApplicationShortcutItem *lockItem = [[UIApplicationShortcutItem alloc] initWithType:@"unlock" localizedTitle:ADLString(@"unlock_records") localizedSubtitle:nil icon:lockIcon userInfo:nil];
    UIApplicationShortcutItem *qrItem = [[UIApplicationShortcutItem alloc] initWithType:@"qr" localizedTitle:ADLString(@"my_qr_code") localizedSubtitle:nil icon:qrIcon userInfo:nil];
    application.shortcutItems= @[qrItem,lockItem];
}

#pragma mark ------ 3D Touch 进来 ------
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    ADLTabBarController *tabbarVC = (ADLTabBarController *)self.window.rootViewController;
    ADLNavigationController *navigationVC = tabbarVC.selectedViewController;
    //暂时不考虑引导页问题
    if ([ADLUserModel sharedModel].login) {
        if ([shortcutItem.type isEqualToString:@"unlock"]) {
            [ADLUtils getCurrentViewController];
        } else {
            
        }
    } else {
        [self pushLoginController:navigationVC];
    }
}

#pragma mark ------ 跳转登录控制器 ------
- (void)pushLoginController:(ADLNavigationController *)navigationVC {
    ADLLoginController *loginVC = [[ADLLoginController alloc] init];
    if (![navigationVC.visibleViewController isKindOfClass:[ADLLoginController class]]) {
        if (navigationVC.childViewControllers.count == 1) {
            loginVC.hidesBottomBarWhenPushed = YES;
        }
        [navigationVC pushViewController:loginVC animated:YES];
    }
}

@end
