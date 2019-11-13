//
//  ADLLoginController.m
//  lockboss
//
//  Created by adel on 2019/4/16.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLoginController.h"
#import "ADLRegisterController.h"
#import "ADLForgetPwdController.h"
#import "ADLBindHomeController.h"
#import "ADLRMQConnection.h"
#import "ADLLoginView.h"

#import "WXApi.h"
#import <JMessage/JMSGUser.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ADLLoginController ()<ADLLoginViewDelegate,TencentSessionDelegate>
@property (nonatomic, strong) ADLLoginView *loginView;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@end

@implementation ADLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADLLoginView *loginView = [ADLLoginView loginViewWithDelegate:self];
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    self.loginView = loginView;
    
    BOOL QQHide = NO;
    BOOL WechatHide = NO;
    if (![QQApiInterface isQQInstalled] && ![QQApiInterface isTIMInstalled]) {
        loginView.qqBtn.hidden = YES;
        QQHide = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        loginView.wechatBtn.hidden = YES;
        WechatHide = YES;
    }
    if (QQHide && WechatHide) {
        loginView.thirdLab.hidden = YES;
    }
    if (!QQHide && WechatHide) {
        CGRect qqF = loginView.qqBtn.frame;
        qqF.origin.x = SCREEN_WIDTH/2-22;
        loginView.qqBtn.frame = qqF;
    }
    if (QQHide && !WechatHide) {
        CGRect wechatF = loginView.wechatBtn.frame;
        wechatF.origin.x = SCREEN_WIDTH/2-22;
        loginView.wechatBtn.frame = wechatF;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWechatData:) name:@"wechatLogin" object:nil];
}

#pragma mark ------ 返回 ------
- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 注册 ------
- (void)didClickRegisterBtn {
    ADLRegisterController *registerVC = [[ADLRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark ------ 忘记密码 ------
- (void)didClickForgetBtn {
    ADLForgetPwdController *forgetVC = [[ADLForgetPwdController alloc] init];
    forgetVC.titleName = @"忘记密码";
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark ------ 点击QQ登录 ------
- (void)didClickQQLoginBtn {
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", nil];
    [tencentOAuth authorize:permissions];
    self.tencentOAuth = tencentOAuth;
}

#pragma mark ------ QQ登录成功,获取Unionid ------
- (void)tencentDidLogin {
    [ADLToast showLoadingMessage:@"登录中..."];
    NSString *path = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",_tencentOAuth.accessToken];
    [ADLNetWorkManager getNormalPath:path parameters:nil success:^(NSDictionary *responseDict) {
        if ([responseDict[@"unionid"] stringValue].length > 2) {
            [self submitThirdLoginWithType:1 unionid:responseDict[@"unionid"]];
        } else {
            [ADLToast showMessage:@"登录失败，请重试！"];
        }
    } failure:^(NSError *error) {
        [ADLToast showMessage:@"登录失败，请重试！"];
    }];
}

#pragma mark ------ QQ登录失败 ------
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [ADLToast showMessage:@"取消登录"];
    } else {
        [ADLToast showMessage:@"登录失败，请重试！"];
    }
}

#pragma mark ------ QQ登录时网络有问题 ------
- (void)tencentDidNotNetWork {
    [ADLToast showMessage:@"登录失败，请重试！"];
}

#pragma mark ------ 点击微信登录 ------
- (void)didClickWechatLoginBtn {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req completion:nil];
}

#pragma mark ------ 微信登录成功，获取微信Token通知 ------
- (void)getWechatData:(NSNotification *)notification {
    NSString *preStr = @"https://api.weixin.qq.com/sns/oauth2/access_token?grant_type=authorization_code&appid=";
    NSString *path = [NSString stringWithFormat:@"%@%@&secret=%@&code=%@",preStr,WEACHAT_APPID,WEACHAT_SECRET,notification.object];
    [ADLNetWorkManager getNormalPath:path parameters:nil success:^(NSDictionary *responseDict) {
        if ([responseDict[@"unionid"] stringValue].length > 2) {
            [self submitThirdLoginWithType:2 unionid:responseDict[@"unionid"]];
        } else {
            [ADLToast showMessage:@"登录失败，请重试！"];
        }
    } failure:^(NSError *error) {
        [ADLToast showMessage:@"登录失败，请重试！"];
    }];
}

#pragma mark ------ 提交第三方登录请求 ------
- (void)submitThirdLoginWithType:(NSInteger)type unionid:(NSString *)unionid {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(type) forKey:@"thirdPartyType"];
    [params setValue:unionid forKey:@"thirdPartyKey"];
    [params setValue:[ADLUtils valueForKey:DEVICE_TOKEN] forKey:@"imei"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_thirdPartyLogin parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self verifyToken:responseDict[@"data"]];
        } else if ([responseDict[@"code"] integerValue] == 10022) {
            [ADLToast hide];
            ADLBindHomeController *linkVC = [[ADLBindHomeController alloc] init];
            linkVC.type = type;
            linkVC.unionId = unionid;
            linkVC.finishLogin = ^{
                if (self.loginSuccess) {
                    self.loginSuccess();
                }
            };
            [self.navigationController pushViewController:linkVC animated:YES];
        } else {
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        [ADLToast showMessage:@"登录失败，请重试！"];
    }];
}

#pragma mark ------ 验证Token ------
- (void)verifyToken:(NSMutableDictionary *)userInfo {
    [ADLNetWorkManager sharedManager].token = userInfo[@"token"];
    [ADLNetWorkManager postWithPath:k_verify_token parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self loginIMWithDict:userInfo];
        }
    } failure:nil];
}

#pragma mark ------ 登录聊天 ------
- (void)loginIMWithDict:(NSMutableDictionary *)dict {
    [ADLNetWorkManager postWithPath:k_user_im_info parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [JMSGUser loginWithUsername:responseDict[@"data"][@"userName"] password:responseDict[@"data"][@"password"] completionHandler:^(id resultObject, NSError *error) {
                if (error) {
                    [ADLToast showMessage:@"登录失败"];
                } else {
                    [ADLToast hide];
                    [dict setValue:responseDict[@"data"][@"userName"] forKey:@"userName"];
                    [dict setValue:responseDict[@"data"][@"password"] forKey:@"password"];

                    ADLUserModel *model = [ADLUserModel sharedModel];
                    [model setValueWithDict:dict];
                    model.login = YES;
                    [ADLUserModel saveUserModel:model];
                    [[ADLRMQConnection sharedConnect] startConnection];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"login" userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.loginSuccess) {
                        self.loginSuccess();
                    }
                }
            }];
        }
    } failure:nil];
    
    //内网不登录聊天
//    [ADLToast hide];
//    ADLUserModel *model = [ADLUserModel sharedModel];
//    [model setValueWithDict:dict];
//    model.login = YES;
//    [ADLUserModel saveUserModel:model];
//    [[ADLRMQConnection sharedConnect] startConnection];
//    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"login" userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE object:nil userInfo:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    if (self.loginSuccess) {
//        self.loginSuccess();
//    }
}

@end
