//
//  ADLBindAccountController.m
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBindAccountController.h"
#import "ADLSelectNationView.h"
#import <JMessage/JMSGUser.h>
#import "ADLRMQConnection.h"

@interface ADLBindAccountController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *areaView;
@property (nonatomic, strong) UILabel *areaLab;
@property (nonatomic, strong) NSString *nationName;
@property (nonatomic, strong) UIImageView *areaImgView;

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailTF;

@property (nonatomic, strong) UIView *pwdView;
@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) UILabel *switchLab;
@property (nonatomic, strong) UIImageView *switchView;

@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation ADLBindAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubView];
}

#pragma mark ------ 初始化视图 ------
- (void)setupSubView {
    NSDictionary *dict = @{@"en":@"China", @"zh-Hant":@"中國大陸", @"zh-Hans":@"中国大陆"};
    self.nationName = dict[[ADLLocalizedHelper helper].currentLanguage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(29, NAVIGATION_H+29, 70, VIEW_HEIGHT)];
    areaView.layer.borderWidth = 0.5;
    areaView.layer.cornerRadius = CORNER_RADIUS;
    areaView.layer.borderColor = COLOR_D3D3D3.CGColor;
    [self.view addSubview:areaView];
    self.areaView = areaView;
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAreaView)];
    [areaView addGestureRecognizer:areaTap];
    
    UILabel *areaLab = [[UILabel alloc] init];
    areaLab.font = [UIFont systemFontOfSize:13];
    areaLab.textColor = COLOR_333333;
    areaLab.text = @"+86";
    [areaView addSubview:areaLab];
    self.areaLab = areaLab;
    
    UIImageView *areaImgView = [[UIImageView alloc] init];
    areaImgView.image = [UIImage imageNamed:@"phone_down"];
    [areaView addSubview:areaImgView];
    self.areaImgView = areaImgView;
    
    CGFloat titW = [ADLUtils calculateString:@"+86" rectSize:CGSizeMake(70, VIEW_HEIGHT) fontSize:13].width+15;
    areaLab.frame = CGRectMake(36-titW/2, 0, titW-13, VIEW_HEIGHT);
    areaImgView.frame = CGRectMake(24+titW/2, (VIEW_HEIGHT-3)/2, 9, 5);
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(108, NAVIGATION_H+29, SCREEN_WIDTH-136, VIEW_HEIGHT)];
    phoneView.layer.borderColor = COLOR_D3D3D3.CGColor;
    phoneView.layer.cornerRadius = CORNER_RADIUS;
    phoneView.layer.borderWidth = 0.5;
    [self.view addSubview:phoneView];
    self.phoneView = phoneView;
    
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-154, VIEW_HEIGHT)];
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.returnKeyType = UIReturnKeyDone;
    phoneTF.placeholder = @"请输入手机号码";
    [phoneView addSubview:phoneTF];
    phoneTF.delegate = self;
    self.phoneTF = phoneTF;
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(29, NAVIGATION_H+VIEW_HEIGHT+41, SCREEN_WIDTH-174, VIEW_HEIGHT)];
    codeView.layer.borderColor = COLOR_D3D3D3.CGColor;
    codeView.layer.cornerRadius = CORNER_RADIUS;
    codeView.layer.borderWidth = 0.5;
    [self.view addSubview:codeView];
    self.codeView = codeView;
    
    UITextField *codeTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-192, VIEW_HEIGHT)];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    codeTF.returnKeyType = UIReturnKeyDone;
    codeTF.placeholder = @"请输入验证码";
    [codeView addSubview:codeTF];
    codeTF.delegate = self;
    self.codeTF = codeTF;
    
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-137, NAVIGATION_H+VIEW_HEIGHT+41, 108, VIEW_HEIGHT)];
    codeBtn.layer.cornerRadius = CORNER_RADIUS;
    codeBtn.backgroundColor = APP_COLOR;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickMsgCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    self.codeBtn = codeBtn;
    
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(29, NAVIGATION_H+29, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    emailView.layer.borderColor = COLOR_D3D3D3.CGColor;
    emailView.layer.cornerRadius = CORNER_RADIUS;
    emailView.layer.borderWidth = 0.5;
    [self.view addSubview:emailView];
    self.emailView = emailView;
    emailView.hidden = YES;
    
    UITextField *emailTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-75, VIEW_HEIGHT)];
    emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    emailTF.returnKeyType = UIReturnKeyDone;
    emailTF.placeholder = @"请输入邮箱";
    [emailView addSubview:emailTF];
    emailTF.delegate = self;
    self.emailTF = emailTF;
    
    UIView *pwdView = [[UIView alloc] init];
    pwdView.layer.borderColor = COLOR_D3D3D3.CGColor;
    pwdView.layer.cornerRadius = CORNER_RADIUS;
    pwdView.layer.borderWidth = 0.5;
    [self.view addSubview:pwdView];
    self.pwdView = pwdView;
    
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-70-VIEW_HEIGHT, VIEW_HEIGHT)];
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.placeholder = @"请输入6-18位密码";
    pwdTF.secureTextEntry = YES;
    if (@available(iOS 10.0, *)) {
        pwdTF.textContentType = UITextContentTypeName;
    }
    [pwdView addSubview:pwdTF];
    pwdTF.delegate = self;
    self.pwdTF = pwdTF;
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-58-VIEW_HEIGHT, 0, VIEW_HEIGHT, VIEW_HEIGHT)];
    [showBtn setImage:[UIImage imageNamed:@"login_pwd_hidden"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"login_pwd_show"] forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(clickShowPwdBtn:) forControlEvents:UIControlEventTouchUpInside];
    showBtn.adjustsImageWhenHighlighted = NO;
    [pwdView addSubview:showBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    UILabel *switchLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-96, SCREEN_WIDTH, 20)];
    switchLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    switchLab.textAlignment = NSTextAlignmentCenter;
    switchLab.textColor = COLOR_333333;
    switchLab.text = @"邮箱账号";
    [self.view addSubview:switchLab];
    self.switchLab = switchLab;
    
    UIImageView *switchView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-44)/2, SCREEN_HEIGHT-BOTTOM_H-70, 44, 44)];
    switchView.image = [UIImage imageNamed:@"register_email"];
    switchView.userInteractionEnabled = YES;
    [self.view addSubview:switchView];
    self.switchView = switchView;
    UITapGestureRecognizer *swiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoneEmail)];
    [switchView addGestureRecognizer:swiTap];
    
    if (self.existing) {
        pwdView.hidden = YES;
        [self addNavigationView:@"关联已有账号"];
        pwdView.frame = CGRectMake(29, NAVIGATION_H+VIEW_HEIGHT+41, SCREEN_WIDTH-58, VIEW_HEIGHT);
        confirmBtn.frame = CGRectMake(29, VIEW_HEIGHT*2+NAVIGATION_H+119, SCREEN_WIDTH-58, VIEW_HEIGHT);
    } else {
        [self addNavigationView:@"关联新账号"];
        pwdView.frame = CGRectMake(29, NAVIGATION_H+VIEW_HEIGHT*2+53, SCREEN_WIDTH-58, VIEW_HEIGHT);
        confirmBtn.frame = CGRectMake(29, VIEW_HEIGHT*3+NAVIGATION_H+131, SCREEN_WIDTH-58, VIEW_HEIGHT);
    }
}

#pragma mark ------ 移除Timer ------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark ------ 点击地区 ------
- (void)clickAreaView {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.areaImgView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLSelectNationView showWithFrame:CGRectMake(29, VIEW_HEIGHT+NAVIGATION_H+36, SCREEN_WIDTH-58, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-BOTTOM_H-60) finish:^(NSDictionary *dict) {
        if (dict) {
            self.areaLab.text = dict[@"code"];
            self.nationName = dict[[ADLLocalizedHelper helper].currentLanguage];
            CGFloat titW = [ADLUtils calculateString:dict[@"code"] rectSize:CGSizeMake(70, VIEW_HEIGHT) fontSize:13].width+15;
            self.areaLab.frame = CGRectMake(36-titW/2, 0, titW-13, VIEW_HEIGHT);
            self.areaImgView.frame = CGRectMake(24+titW/2, (VIEW_HEIGHT-3)/2, 9, 5);
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.areaImgView.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.pwdTF) {
        [ADLUtils dealWithSecureEntryWithTextField:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTF) {
        return [ADLUtils phoneTextField:textField replacementString:string];
    } else if (textField == self.codeTF) {
        return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:YES];
    } else if (textField == self.pwdTF) {
        return [ADLUtils limitedTextField:textField replacementString:string maxLength:18];
    } else {
        return YES;
    }
}

#pragma mark ------ 获取验证码 ------
- (void)clickMsgCodeBtn:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入手机号码"];
    } else {
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        if (self.existing) [params setValue:@"1" forKey:@"type"];
        else [params setValue:@"0" forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_getCode parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"验证码已发送"];
                self.time = 60;
                self.codeBtn.enabled = NO;
                [self.codeTF becomeFirstResponder];
                [self.codeBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            }
        } failure:nil];
    }
}

#pragma mark ------ 更新验证码 ------
- (void)updateTime {
    self.time--;
    if (self.time == 0) {
        [self.timer invalidate];
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%lu)",self.time] forState:UIControlStateNormal];
    }
}

#pragma mark ------ 显示隐藏密码 ------
- (void)clickShowPwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdTF.secureTextEntry = NO;
    } else {
        self.pwdTF.secureTextEntry = YES;
    }
    [ADLUtils dealWithSecureEntryWithTextField:self.pwdTF];
}

#pragma mark ------ 切换账号类型 ------
- (void)clickPhoneEmail {
    [self.view endEditing:YES];
    if (self.existing) {
        if (self.areaView.hidden) {
            self.areaView.hidden = NO;
            self.phoneView.hidden = NO;
            self.codeView.hidden = NO;
            self.codeBtn.hidden = NO;
            self.emailView.hidden = YES;
            self.pwdView.hidden = YES;
            self.switchLab.text = @"邮箱账号";
            self.switchView.image = [UIImage imageNamed:@"register_email"];
        } else {
            self.areaView.hidden = YES;
            self.phoneView.hidden = YES;
            self.codeView.hidden = YES;
            self.codeBtn.hidden = YES;
            self.emailView.hidden = NO;
            self.pwdView.hidden = NO;
            self.switchLab.text = @"手机账号";
            self.switchView.image = [UIImage imageNamed:@"register_phone"];
        }
    } else {
        if (self.areaView.hidden) {
            self.areaView.hidden = NO;
            self.phoneView.hidden = NO;
            self.codeView.hidden = NO;
            self.codeBtn.hidden = NO;
            self.emailView.hidden = YES;
            self.pwdView.frame = CGRectMake(29, NAVIGATION_H+VIEW_HEIGHT*2+53, SCREEN_WIDTH-58, VIEW_HEIGHT);
            self.confirmBtn.frame = CGRectMake(29, VIEW_HEIGHT*3+NAVIGATION_H+131, SCREEN_WIDTH-58, VIEW_HEIGHT);
            self.switchLab.text = @"邮箱账号";
            self.switchView.image = [UIImage imageNamed:@"register_email"];
        } else {
            self.areaView.hidden = YES;
            self.phoneView.hidden = YES;
            self.codeView.hidden = YES;
            self.codeBtn.hidden = YES;
            self.emailView.hidden = NO;
            self.pwdView.frame = CGRectMake(29, NAVIGATION_H+VIEW_HEIGHT+41, SCREEN_WIDTH-58, VIEW_HEIGHT);
            self.confirmBtn.frame = CGRectMake(29, VIEW_HEIGHT*2+NAVIGATION_H+119, SCREEN_WIDTH-58, VIEW_HEIGHT);
            self.switchLab.text = @"手机账号";
            self.switchView.image = [UIImage imageNamed:@"register_phone"];
        }
    }
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    if (self.areaView.hidden) {
        if (self.emailTF.text.length == 0) {
            [ADLToast showMessage:@"请输入邮箱账号"];
            return;
        }
        if (self.pwdTF.text.length < 6) {
            [ADLToast showMessage:@"请输入6-18位密码"];
            return;
        }
        
        [self.view endEditing:YES];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSString *path = ADEL_bindThirdPartyByLoginAccoun;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.unionId forKey:@"thirdPartyKey"];
        [params setValue:@(self.type) forKey:@"thirdPartyType"];
        [params setValue:[ADLUtils valueForKey:DEVICE_TOKEN] forKey:@"imei"];
        [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
        if (self.existing) {
            [params setValue:@"3" forKey:@"type"];
            [params setValue:self.emailTF.text forKey:@"loginAccount"];
        } else {
            path = ADEL_thirdPartyEmail;
            [params setValue:self.emailTF.text forKey:@"email"];
        }
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        
        [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                if (self.existing) {
                    [self verifyToken:responseDict[@"data"]];
                } else {
                    [ADLToast hide];
                    [ADLAlertView showWithTitle:@"提示" message:@"激活链接已发送至邮箱，确认后方可登录" confirmTitle:nil confirmAction:^{
                        NSInteger count = self.navigationController.childViewControllers.count;
                        if (count > 3) {
                            [self.navigationController popToViewController:self.navigationController.childViewControllers[count-4] animated:YES];
                        }
                    } cancleTitle:nil cancleAction:nil showCancle:NO];
                }
            }
        } failure:nil];
    } else {
        if (self.phoneTF.text.length == 0) {
            [ADLToast showMessage:@"请输入手机号码"];
            return;
        }
        if (self.codeTF.text.length == 0) {
            [ADLToast showMessage:@"请输入验证码"];
            return;
        }
        if (self.pwdTF.text.length < 6 && !self.existing) {
            [ADLToast showMessage:@"请输入6-18位密码"];
            return;
        }
        [self.view endEditing:YES];
        [self checkCode];
    }
}

#pragma mark ------ 校验验证码 ------
- (void)checkCode {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
    [params setValue:self.codeTF.text forKey:@"messageVerificationCode"];
    [params setValue:self.phoneTF.text forKey:@"phone"];
    if (_existing) [params setValue:@"1" forKey:@"type"];
    else [params setValue:@"0" forKey:@"type"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_verifyMessageVerificationCode parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self bindPhone:responseDict[@"data"][@"validateCode"]];
        }
    } failure:nil];
}

#pragma mark ------ 绑定手机 ------
- (void)bindPhone:(NSString *)validateCode {
    NSString *path = ADEL_bindThirdPartyCode;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.phoneTF.text forKey:@"phone"];
    [params setValue:validateCode forKey:@"validateCode"];
    [params setValue:self.unionId forKey:@"thirdPartyKey"];
    [params setValue:@(self.type) forKey:@"thirdPartyType"];
    [params setValue:[ADLUtils valueForKey:DEVICE_TOKEN] forKey:@"imei"];
    if (!self.existing) {
        path = ADEL_thirdPartyPhone;
        [params setValue:self.nationName forKey:@"nationName"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self verifyToken:responseDict[@"data"]];
        }
    } failure:nil];
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
                    
                    if (self.loginSuccess) {
                        self.loginSuccess();
                    }
                    NSInteger count = self.navigationController.childViewControllers.count;
                    if (count > 3) {
                        [self.navigationController popToViewController:self.navigationController.childViewControllers[count-4] animated:YES];
                    }
                }
            }];
        }
    } failure:nil];
}

#pragma mark ------ 取消编辑 ------
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

@end
