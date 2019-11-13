//
//  ADLPersonalDetailController.m
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLPersonalDetailController.h"
#import "ADLImagePreView.h"

@interface ADLPersonalDetailController ()

@end

@implementation ADLPersonalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"个人详情"];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 60, 60)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.userInteractionEnabled = YES;
    iconView.layer.cornerRadius = 6;
    iconView.clipsToBounds = YES;
    [whiteView addSubview:iconView];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[self.userInfo[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconView:)];
    [iconView addGestureRecognizer:tap];
    
    UILabel *remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(82, 18, SCREEN_WIDTH-92, 20)];
    remarkLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    remarkLab.textColor = COLOR_333333;
    if ([self.userInfo[@"remark"] stringValue].length > 0) {
        remarkLab.text = self.userInfo[@"remark"];
    } else {
        remarkLab.text = self.userInfo[@"userName"];
    }
    [whiteView addSubview:remarkLab];
    
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(82, 38, SCREEN_WIDTH-92, 24)];
    nickLab.text = [NSString stringWithFormat:@"昵称：%@",self.userInfo[@"userName"]];
    nickLab.font = [UIFont systemFontOfSize:13];
    nickLab.textColor = COLOR_999999;
    [whiteView addSubview:nickLab];
    
    UILabel *accountLab = [[UILabel alloc] initWithFrame:CGRectMake(82, 62, SCREEN_WIDTH-92, 20)];
    accountLab.text = [NSString stringWithFormat:@"锁老大账号：%@",self.userInfo[@"loginAccount"]];
    accountLab.font = [UIFont systemFontOfSize:13];
    accountLab.textColor = COLOR_999999;
    [whiteView addSubview:accountLab];
    
    UIButton *transBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    transBtn.frame = CGRectMake(0, NAVIGATION_H+108, SCREEN_WIDTH, 50);
    [transBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [transBtn setTitle:@"转让权限" forState:UIControlStateNormal];
    transBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    transBtn.backgroundColor = [UIColor whiteColor];
    [transBtn addTarget:self action:@selector(clickTransBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transBtn];
}

#pragma mark ------ 点击用户头像 ------
- (void)clickIconView:(UITapGestureRecognizer *)tap {
    if ([self.userInfo[@"headShot"] stringValue].length > 0) {
        [ADLImagePreView showWithImageViews:@[tap.view] urlArray:@[self.userInfo[@"headShot"]] currentIndex:0];
    }
}

#pragma mark ------ 点击转让权限按钮 ------
- (void)clickTransBtn {
    [ADLAlertView showWithTitle:@"转让权限" message:[NSString stringWithFormat:@"您确定要把管理权限转让给%@吗？转让后您将失去对该设备的管理权限",self.userInfo[@"userName"]] confirmTitle:nil confirmAction:^{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ADLString(@"admin_verify") message:ADLString(@"enter_login_pwd") preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.secureTextEntry = YES;
        }];
        [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"cancle") style:UIAlertActionStyleCancel handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textfield = alertVC.textFields.firstObject;
            if (textfield.text.length > 0) {
                if (textfield.text.length < 6 || textfield.text.length > 18) {
                    [ADLToast showMessage:@"密码错误"];
                } else {
                    [self verifyLoginPassword:textfield.text];
                }
            }
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ 验证密码 ------
- (void)verifyLoginPassword:(NSString *)pwd {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils md5Encrypt:pwd lower:YES] forKey:@"password"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_verifyPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self transPermissionWithCode:responseDict[@"data"][@"validateCode"]];
        }
    } failure:nil];
}

#pragma mark ------ 转让权限 ------
- (void)transPermissionWithCode:(NSString *)code {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.userInfo[@"deviceId"] forKey:@"deviceId"];
    [params setValue:self.userInfo[@"userId"] forKey:@"userId"];
    [params setValue:code forKey:@"validateCode"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_setPermission parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"转让成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

@end
