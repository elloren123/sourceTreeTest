//
//  ADLRegisterView.m
//  lockboss
//
//  Created by adel on 2019/4/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRegisterView.h"
#import "ADLLocalizedHelper.h"
#import "ADLSelectNationView.h"
#import "ADLLocalizedHelper.h"
#import "ADLNetWorkManager.h"
#import "ADLGlobalDefine.h"
#import "ADLApiDefine.h"
#import "ADELUrlpath.h"
#import "ADLToast.h"
#import "ADLUtils.h"

@interface ADLRegisterView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *areaLab;
@property (nonatomic, strong) UIView *areaView;
@property (nonatomic, strong) UIImageView *areaImgView;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UIView *confirmView;
@property (nonatomic, strong) UITextField *confirmTF;
@property (nonatomic, strong) UILabel *switchLab;
@property (nonatomic, strong) UIImageView *switchView;
@property (nonatomic, strong) NSString *nationName;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@end

@implementation ADLRegisterView

+ (instancetype)registerViewWithFrame:(CGRect)frame delegate:(id)delegate {
    return [[self alloc] initWithFrame:frame delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        [self initializationViews];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationViews {
    NSDictionary *dict = @{@"en":@"China", @"zh-Hant":@"中國大陸", @"zh-Hans":@"中国大陆"};
    self.nationName = dict[[ADLLocalizedHelper helper].currentLanguage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self addGestureRecognizer:tap];
    
    UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(29, 29, 70, VIEW_HEIGHT)];
    areaView.layer.borderWidth = 0.5;
    areaView.layer.cornerRadius = CORNER_RADIUS;
    areaView.layer.borderColor = COLOR_D3D3D3.CGColor;
    [self addSubview:areaView];
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
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(108, 29, SCREEN_WIDTH-136, VIEW_HEIGHT)];
    phoneView.layer.borderColor = COLOR_D3D3D3.CGColor;
    phoneView.layer.cornerRadius = CORNER_RADIUS;
    phoneView.layer.borderWidth = 0.5;
    [self addSubview:phoneView];
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
    
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(29, 29, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    emailView.layer.borderColor = COLOR_D3D3D3.CGColor;
    emailView.layer.cornerRadius = CORNER_RADIUS;
    emailView.layer.borderWidth = 0.5;
    [self addSubview:emailView];
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
    
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(29, VIEW_HEIGHT+41, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    confirmView.layer.borderColor = COLOR_D3D3D3.CGColor;
    confirmView.layer.cornerRadius = CORNER_RADIUS;
    confirmView.layer.borderWidth = 0.5;
    [self addSubview:confirmView];
    self.confirmView = confirmView;
    confirmView.hidden = YES;
    
    UITextField *confirmTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-70-VIEW_HEIGHT, VIEW_HEIGHT)];
    confirmTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    confirmTF.keyboardType = UIKeyboardTypeASCIICapable;
    confirmTF.returnKeyType = UIReturnKeyDone;
    confirmTF.placeholder = @"请输入6-18位密码";
    confirmTF.secureTextEntry = YES;
    if (@available(iOS 10.0, *)) {
        confirmTF.textContentType = UITextContentTypeName;
    }
    [confirmView addSubview:confirmTF];
    confirmTF.delegate = self;
    self.confirmTF = confirmTF;
    
    UIButton *hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-VIEW_HEIGHT-58, 0, VIEW_HEIGHT, VIEW_HEIGHT)];
    [hideBtn setImage:[UIImage imageNamed:@"login_pwd_hidden"] forState:UIControlStateNormal];
    [hideBtn setImage:[UIImage imageNamed:@"login_pwd_show"] forState:UIControlStateSelected];
    [hideBtn addTarget:self action:@selector(clickHidePwdBtn:) forControlEvents:UIControlEventTouchUpInside];
    hideBtn.adjustsImageWhenHighlighted = NO;
    [confirmView addSubview:hideBtn];
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(29, VIEW_HEIGHT+41, SCREEN_WIDTH-174, VIEW_HEIGHT)];
    codeView.layer.borderColor = COLOR_D3D3D3.CGColor;
    codeView.layer.cornerRadius = CORNER_RADIUS;
    codeView.layer.borderWidth = 0.5;
    [self addSubview:codeView];
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
    
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-137, 41+VIEW_HEIGHT, 108, VIEW_HEIGHT)];
    codeBtn.layer.cornerRadius = CORNER_RADIUS;
    codeBtn.backgroundColor = APP_COLOR;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickMsgCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:codeBtn];
    self.codeBtn = codeBtn;
    
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(29, VIEW_HEIGHT*2+53, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    pwdView.layer.borderColor = COLOR_D3D3D3.CGColor;
    pwdView.layer.cornerRadius = CORNER_RADIUS;
    pwdView.layer.borderWidth = 0.5;
    [self addSubview:pwdView];
    
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
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(29, 103+VIEW_HEIGHT*3, SCREEN_WIDTH-58, VIEW_HEIGHT);
    registerBtn.layer.cornerRadius = CORNER_RADIUS;
    registerBtn.backgroundColor = APP_COLOR;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(29, 113+VIEW_HEIGHT*4, SCREEN_WIDTH-58, 20)];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:13];
    lab1.textColor = COLOR_999999;
    lab1.text = @"注册表示您同意并愿意遵守";
    [self addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-14)/2+20, 137+VIEW_HEIGHT*4, 14, 16)];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textColor = COLOR_999999;
    lab2.text = @"和";
    [self addSubview:lab2];
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    protocolBtn.frame = CGRectMake(lab2.frame.origin.x-118, 130+VIEW_HEIGHT*4, 120, 30);
    [protocolBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [protocolBtn setTitle:@"《爱迪尔用户协议》" forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(clickProtocolBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:protocolBtn];
    
    UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    privacyBtn.frame = CGRectMake(lab2.frame.origin.x+13, 130+VIEW_HEIGHT*4, 80, 30);
    [privacyBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    privacyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [privacyBtn setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [privacyBtn addTarget:self action:@selector(clickPrivacyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:privacyBtn];
    
    UILabel *switchLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-95, SCREEN_WIDTH, 20)];
    switchLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    switchLab.textAlignment = NSTextAlignmentCenter;
    switchLab.textColor = COLOR_333333;
    switchLab.text = @"邮箱注册";
    [self addSubview:switchLab];
    self.switchLab = switchLab;
    
    UIImageView *switchView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-44)/2, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-70, 44, 44)];
    switchView.image = [UIImage imageNamed:@"register_email"];
    switchView.userInteractionEnabled = YES;
    [self addSubview:switchView];
    self.switchView = switchView;
    UITapGestureRecognizer *swiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoneEmailRegister)];
    [switchView addGestureRecognizer:swiTap];
}

#pragma mark ------ 选择手机号地区 ------
- (void)clickAreaView {
    [self endEditing:YES];
    BOOL sec = NO;
    if (self.pwdTF.secureTextEntry) {
        sec = YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.areaImgView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        if (sec == YES) {
            self.pwdTF.secureTextEntry = NO;
        }
    }];
    [ADLSelectNationView showWithFrame:CGRectMake(29, VIEW_HEIGHT+NAVIGATION_H+36, SCREEN_WIDTH-58, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-BOTTOM_H-60) finish:^(NSDictionary *dict) {
        if (sec == YES) {
            self.pwdTF.secureTextEntry = YES;
        }
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
    if (self.phoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入手机号"];
    } else {
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"0" forKey:@"type"];
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
- (void)clickHidePwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.confirmTF.secureTextEntry = NO;
    } else {
        self.confirmTF.secureTextEntry = YES;
    }
    [ADLUtils dealWithSecureEntryWithTextField:self.confirmTF];
}

- (void)clickShowPwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdTF.secureTextEntry = NO;
    } else {
        self.pwdTF.secureTextEntry = YES;
    }
    [ADLUtils dealWithSecureEntryWithTextField:self.pwdTF];
}

#pragma mark ------ 切换注册方式 ------
- (void)clickPhoneEmailRegister {
    if (self.emailView.hidden) {
        self.emailView.hidden = NO;
        self.confirmView.hidden = NO;
        self.areaView.hidden = YES;
        self.phoneView.hidden = YES;
        self.codeView.hidden = YES;
        self.codeBtn.hidden = YES;
        self.switchLab.text = @"手机注册";
        self.pwdTF.placeholder = @"请输入确认密码";
        self.switchView.image = [UIImage imageNamed:@"register_phone"];
    } else {
        self.areaView.hidden = NO;
        self.phoneView.hidden = NO;
        self.codeView.hidden = NO;
        self.codeBtn.hidden = NO;
        self.emailView.hidden = YES;
        self.confirmView.hidden = YES;
        self.switchLab.text = @"邮箱注册";
        self.pwdTF.placeholder = @"请输入6-18位密码";
        self.switchView.image = [UIImage imageNamed:@"register_email"];
    }
}

#pragma mark ------ 注册 ------
- (void)clickRegisterBtn {
    if (self.areaView.hidden) {
        if (self.emailTF.text.length == 0) {
            [ADLToast showMessage:@"请输入邮箱账号"];
            return;
        }
        if (![ADLUtils verifyEmailAddress:self.emailTF.text]) {
            [ADLToast showMessage:@"请输入正确的邮箱账号"];
            return;
        }
        if (self.confirmTF.text.length < 6) {
            [ADLToast showMessage:@"请输入6-18位密码"];
            return;
        }
        if (self.pwdTF.text.length < 6) {
            [ADLToast showMessage:@"请输入6-18位确认密码"];
            return;
        }
        if (![self.confirmTF.text isEqualToString:self.pwdTF.text]) {
            [ADLToast showMessage:@"两次密码输入不一致"];
            return;
        }
    } else {
        if (self.phoneTF.text.length == 0) {
            [ADLToast showMessage:@"请输入手机号"];
            return;
        }
        if (self.codeTF.text.length == 0) {
            [ADLToast showMessage:@"请输入验证码"];
            return;
        }
        if (self.pwdTF.text.length == 0) {
            [ADLToast showMessage:@"请输入密码"];
            return;
        }
        if (self.pwdTF.text.length < 6) {
            [ADLToast showMessage:@"请输入6-18位密码"];
            return;
        }
    }
    [self endEditing:YES];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    
    if (self.areaView.hidden) {
        [self submitRegisterInfo];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@(0) forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:self.codeTF.text forKey:@"messageVerificationCode"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_verifyMessageVerificationCode parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [self submitRegisterInfo];
            }
        } failure:nil];
    }
}

#pragma mark ------ 提交注册请求 ------
- (void)submitRegisterInfo {
    NSString *path = ADEL_registerPhone;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.areaView.hidden) {
        path = ADEL_email;
        [params setValue:self.emailTF.text forKey:@"email"];
        [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
    } else {
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:self.nationName forKey:@"nationName"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didRegistPhoneAccount:)]) {
                [self.delegate didRegistPhoneAccount:!self.areaView.hidden];
            }
        }
    } failure:nil];
}

#pragma mark ------ 用户协议 ------
- (void)clickProtocolBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickProtocolBtn)]) {
        [self.delegate didClickProtocolBtn];
    }
}

#pragma mark ------ 隐私政策 ------
- (void)clickPrivacyBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPrivacyBtn)]) {
        [self.delegate didClickPrivacyBtn];
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
    if (textField == self.pwdTF || textField == self.confirmTF) {
        [ADLUtils dealWithSecureEntryWithTextField:textField];
    }
}

#pragma mark ------ 退出键盘 ------
- (void)hideKeyboard {
    [self endEditing:YES];
}

#pragma mark ------ 销毁Timer ------
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
