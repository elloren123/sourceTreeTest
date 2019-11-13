//
//  ADLFrogetPwdController.m
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLForgetPwdController.h"
#import "ADLModifySuccessController.h"
#import "ADLSelectNationView.h"

@interface ADLForgetPwdController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *areaView;
@property (nonatomic, strong) UILabel *areaLab;
@property (nonatomic, strong) UIImageView *areaImgView;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *conPwdTF;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UILabel *switchLab;
@property (nonatomic, strong) UIImageView *switchView;
@property (nonatomic, strong) NSString *nationName;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger type;
@end

@implementation ADLForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:self.titleName];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.titleName hasPrefix:@"修改"]) {
        self.type = 2;
    } else {
        self.type = 1;
    }
    [self initializationViews];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

#pragma mark ------ 初始化视图 ------
- (void)initializationViews {
    NSDictionary *dict = @{@"en":@"China", @"zh-Hant":@"中國大陸", @"zh-Hans":@"中国大陆"};
    self.nationName = dict[[ADLLocalizedHelper helper].currentLanguage];
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
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(108, 29+NAVIGATION_H, SCREEN_WIDTH-136, VIEW_HEIGHT)];
    phoneView.layer.borderColor = COLOR_D3D3D3.CGColor;
    phoneView.layer.cornerRadius = CORNER_RADIUS;
    phoneView.layer.borderWidth = 0.5;
    [self.view addSubview:phoneView];
    self.phoneView = phoneView;
    
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-154, VIEW_HEIGHT)];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    phoneTF.returnKeyType = UIReturnKeyDone;
    phoneTF.placeholder = @"请输入手机号码";
    [phoneView addSubview:phoneTF];
    phoneTF.delegate = self;
    self.phoneTF = phoneTF;
    
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(29, 29+NAVIGATION_H, SCREEN_WIDTH-58, VIEW_HEIGHT)];
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
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(29, 41+VIEW_HEIGHT+NAVIGATION_H, SCREEN_WIDTH-174, VIEW_HEIGHT)];
    codeView.layer.borderColor = COLOR_D3D3D3.CGColor;
    codeView.layer.cornerRadius = CORNER_RADIUS;
    codeView.layer.borderWidth = 0.5;
    [self.view addSubview:codeView];
    
    UITextField *codeTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-192, VIEW_HEIGHT)];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    codeTF.returnKeyType = UIReturnKeyDone;
    codeTF.placeholder = @"请输入验证码";
    [codeView addSubview:codeTF];
    codeTF.delegate = self;
    self.codeTF = codeTF;
    
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-137, 41+VIEW_HEIGHT+NAVIGATION_H, 108, VIEW_HEIGHT)];
    codeBtn.layer.cornerRadius = CORNER_RADIUS;
    codeBtn.backgroundColor = APP_COLOR;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickMsgCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    self.codeBtn = codeBtn;
    
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(29, 53+VIEW_HEIGHT*2+NAVIGATION_H, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    pwdView.layer.borderColor = COLOR_D3D3D3.CGColor;
    pwdView.layer.cornerRadius = CORNER_RADIUS;
    pwdView.layer.borderWidth = 0.5;
    [self.view addSubview:pwdView];
    
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-74, VIEW_HEIGHT)];
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.placeholder = @"设置新密码";
    pwdTF.secureTextEntry = YES;
    if (@available(iOS 10.0, *)) {
        pwdTF.textContentType = UITextContentTypeName;
    }
    [pwdView addSubview:pwdTF];
    pwdTF.delegate = self;
    self.pwdTF = pwdTF;
    
    UIView *conPwdView = [[UIView alloc] initWithFrame:CGRectMake(29, 65+VIEW_HEIGHT*3+NAVIGATION_H, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    conPwdView.layer.borderColor = COLOR_D3D3D3.CGColor;
    conPwdView.layer.cornerRadius = CORNER_RADIUS;
    conPwdView.layer.borderWidth = 0.5;
    [self.view addSubview:conPwdView];
    
    UITextField *conPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-74, VIEW_HEIGHT)];
    conPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    conPwdTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    conPwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    conPwdTF.returnKeyType = UIReturnKeyDone;
    conPwdTF.placeholder = @"重输新密码";
    conPwdTF.secureTextEntry = YES;
    if (@available(iOS 10.0, *)) {
        conPwdTF.textContentType = UITextContentTypeName;
    }
    [conPwdView addSubview:conPwdTF];
    conPwdTF.delegate = self;
    self.conPwdTF = conPwdTF;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(29, 105+VIEW_HEIGHT*4+NAVIGATION_H, SCREEN_WIDTH-58, VIEW_HEIGHT);
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    submitBtn.backgroundColor = APP_COLOR;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:ADLString(@"submit") forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    UILabel *switchLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_H-95, SCREEN_WIDTH, 20)];
    switchLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    switchLab.textAlignment = NSTextAlignmentCenter;
    switchLab.textColor = COLOR_333333;
    switchLab.text = @"邮箱";
    [self.view addSubview:switchLab];
    self.switchLab = switchLab;
    
    UIImageView *switchView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-44)/2, SCREEN_HEIGHT-BOTTOM_H-70, 44, 44)];
    switchView.image = [UIImage imageNamed:@"register_email"];
    switchView.userInteractionEnabled = YES;
    [self.view addSubview:switchView];
    self.switchView = switchView;
    UITapGestureRecognizer *swiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoneEmail)];
    [switchView addGestureRecognizer:swiTap];
}

#pragma mark ------ 选择手机号地区 ------
- (void)clickAreaView {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.areaImgView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        self.pwdTF.secureTextEntry = NO;
    }];
    [ADLSelectNationView showWithFrame:CGRectMake(29, VIEW_HEIGHT+NAVIGATION_H+36, SCREEN_WIDTH-58, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-BOTTOM_H-60) finish:^(NSDictionary *dict) {
        self.pwdTF.secureTextEntry = YES;
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

#pragma mark ------ 获取验证码 ------
- (void)clickMsgCodeBtn:(UIButton *)sender {
    if (self.areaView.hidden) {
        if (self.emailTF.text.length == 0) {
            [ADLToast showMessage:@"请输入邮箱账号"];
            return;
        }
        if (![ADLUtils verifyEmailAddress:self.emailTF.text]) {
            [ADLToast showMessage:@"请输入正确的邮箱账号"];
            return;
        }
    } else {
        if (self.phoneTF.text.length == 0) {
            [ADLToast showMessage:@"请输入手机号"];
            return;
        }
    }
    
    NSString *path = ADEL_getCode;
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.areaView.hidden) {
        path = ADEL_modifyPasswordSendEmail;
        [params setValue:self.emailTF.text forKey:@"loginAccount"];
        [params setValue:@(self.type) forKey:@"type"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    } else {
        [params setValue:@"2" forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    }
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
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

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTF) {
        return [ADLUtils phoneTextField:textField replacementString:string];
    } else if (textField == self.codeTF) {
        return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:YES];
    } else if (textField == self.emailTF) {
        return YES;
    } else {
        return [ADLUtils limitedTextField:textField replacementString:string maxLength:18];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.pwdTF || textField == self.conPwdTF) {
        [ADLUtils dealWithSecureEntryWithTextField:textField];
    }
}

#pragma mark ------ 切换修改密码方式 ------
- (void)clickPhoneEmail {
    if (self.areaView.hidden) {
        self.areaView.hidden = NO;
        self.phoneView.hidden = NO;
        self.emailView.hidden = YES;
        self.switchLab.text = @"邮箱";
        self.switchView.image = [UIImage imageNamed:@"register_email"];
    } else {
        self.areaView.hidden = YES;
        self.phoneView.hidden = YES;
        self.emailView.hidden = NO;
        self.switchLab.text = @"手机";
        self.switchView.image = [UIImage imageNamed:@"register_phone"];
    }
}

#pragma mark ------ 提交 ------
- (void)clickSubmitBtn {
    if (self.areaView.hidden) {
        if (self.emailTF.text.length == 0) {
            [ADLToast showMessage:@"请输入邮箱账号"];
            return;
        }
        if (![ADLUtils verifyEmailAddress:self.emailTF.text]) {
            [ADLToast showMessage:@"请输入正确的邮箱账号"];
            return;
        }
    } else {
        if (self.phoneTF.text.length == 0) {
            [ADLToast showMessage:@"请输入手机号"];
            return;
        }
    }
    if (self.codeTF.text.length == 0) {
        [ADLToast showMessage:@"请输入验证码"];
        return;
    }
    if (self.pwdTF.text.length == 0) {
        [ADLToast showMessage:@"请输入新密码"];
        return;
    }
    if (self.pwdTF.text.length < 6) {
        [ADLToast showMessage:@"请输入6-18位新密码"];
        return;
    }
    if (self.conPwdTF.text.length == 0) {
        [ADLToast showMessage:@"请重新输入新密码"];
        return;
    }
    if (self.conPwdTF.text.length < 6) {
        [ADLToast showMessage:@"请重新输入6-18位新密码"];
        return;
    }
    if (![self.pwdTF.text isEqualToString:self.conPwdTF.text]) {
        [ADLToast showMessage:@"两次密码输入不一致"];
        return;
    }
    [self.view endEditing:YES];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    
    NSString *type = @"phone";
    NSString *path = ADEL_verifyMessageVerificationCode;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.areaView.hidden) {
        type = @"email";
        path = ADEL_validateEmailCode;
        [params setValue:@(self.type) forKey:@"type"];
        [params setValue:self.codeTF.text forKey:@"code"];
        [params setValue:self.emailTF.text forKey:@"eMail"];
    } else {
        [params setValue:@"2" forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:self.codeTF.text forKey:@"messageVerificationCode"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (responseDict[@"data"][@"validateCode"]) {
                [self submitWithType:type validateCode:responseDict[@"data"][@"validateCode"]];
            } else {
                [ADLToast showMessage:responseDict[@"msg"]];
            }
        }
    } failure:nil];
}

#pragma mark ------ 提交修改请求 ------
- (void)submitWithType:(NSString *)type validateCode:(NSString *)validateCode {
    NSString *path = ADEL_modifyPasswordByPhone;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([type isEqualToString:@"email"]) {
        path = ADEL_modifyPasswordByEmail;
        [params setValue:@(self.type) forKey:@"type"];
        [params setValue:self.emailTF.text forKey:@"eMail"];
    } else {
        [params setValue:@(2) forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
    }
    [params setValue:validateCode forKey:@"validateCode"];
    [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ADLToast hide];
                ADLModifySuccessController *modifyVC = [[ADLModifySuccessController alloc] init];
                modifyVC.titleName = @"修改密码";
                modifyVC.promptStr = @"密码修改成功";
                if (self.type == 2) {
                    modifyVC.btnTitle = @"确定";
                } else {
                    modifyVC.btnTitle = @"去登录";
                }
                [self.navigationController pushViewController:modifyVC animated:YES];
            });
        }
    } failure:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
