//
//  ADLLoginView.m
//  lockboss
//
//  Created by adel on 2019/4/16.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLoginView.h"
#import "ADLSelectNationView.h"
#import "ADLLocalizedHelper.h"
#import "ADLAccHistoryView.h"
#import "ADLNetWorkManager.h"
#import "ADLGlobalDefine.h"
#import "ADLApiDefine.h"
#import "ADELUrlpath.h"
#import "ADLToast.h"
#import "ADLUtils.h"

#import <JMessage/JMSGUser.h>

typedef NS_ENUM(NSInteger, ADLLoginType) {
    ADLLoginTypePassword,
    ADLLoginTypeAccount,
    ADLLoginTypeMessage,
    ADLLoginTypeEmail
};

@interface ADLLoginView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *areaLab;
@property (nonatomic, strong) UIImageView *areaImgView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIView *areaView;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIView *pwdView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) ADLLoginType type;
@property (nonatomic, strong) NSString *nationName;
@property (nonatomic, strong) NSArray *phoneArr;
@property (nonatomic, strong) NSArray *emailArr;
@property (nonatomic, strong) UIButton *pullBtn;
@end

@implementation ADLLoginView

+ (instancetype)loginViewWithDelegate:(id)delegate {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds delegate:delegate];
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
    self.type = ADLLoginTypePassword;
    self.phoneArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:HISTORY_PHONE permanent:YES]];
    self.emailArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:HISTORY_EMAIL permanent:YES]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5)];
    imageView.image = [UIImage imageNamed:@"login_bg"];
    [self addSubview:imageView];
    
    CGFloat logoS = (SCREEN_WIDTH > 500 ? 100 : 70);
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-logoS)/2, (SCREEN_WIDTH*0.5-logoS)/2, logoS, logoS)];
    logoView.image = [UIImage imageNamed:@"login_logo"];
    [self addSubview:logoView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 38-NAV_H, 0, 0);
    [backBtn setAdjustsImageWhenHighlighted:NO];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    CGFloat logoF = (SCREEN_WIDTH > 500 ? 17 : 12);
    UILabel *logoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/4+logoS/2+4, SCREEN_WIDTH, 26)];
    logoLab.text = @"LOCK BOSS";
    logoLab.font = [UIFont systemFontOfSize:logoF];
    logoLab.textColor = [UIColor whiteColor];
    logoLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:logoLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self addGestureRecognizer:tap];
    
    //区号视图
    UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH*0.5+30, 70, VIEW_HEIGHT)];
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
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(108, SCREEN_WIDTH*0.5+30, SCREEN_WIDTH-136, VIEW_HEIGHT)];
    phoneView.layer.borderColor = COLOR_D3D3D3.CGColor;
    phoneView.layer.cornerRadius = CORNER_RADIUS;
    phoneView.layer.borderWidth = 0.5;
    [self addSubview:phoneView];
    self.phoneView = phoneView;
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.returnKeyType = UIReturnKeyDone;
    phoneTF.placeholder = @"请输入手机号码";
    [phoneView addSubview:phoneTF];
    phoneTF.delegate = self;
    self.phoneTF = phoneTF;
    
    UIButton *pullBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-174, 0, 38, VIEW_HEIGHT)];
    [pullBtn setImage:[UIImage imageNamed:@"pull_down"] forState:UIControlStateNormal];
    [pullBtn addTarget:self action:@selector(clickPullBtn) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:pullBtn];
    self.pullBtn = pullBtn;
    
    if (self.phoneArr.count > 0) {
        phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-192, VIEW_HEIGHT);
    } else {
        pullBtn.hidden = YES;
        phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-154, VIEW_HEIGHT);
    }
    
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH*0.5+42+VIEW_HEIGHT, SCREEN_WIDTH-58, VIEW_HEIGHT)];
    pwdView.layer.borderColor = COLOR_D3D3D3.CGColor;
    pwdView.layer.cornerRadius = CORNER_RADIUS;
    pwdView.layer.borderWidth = 0.5;
    [self addSubview:pwdView];
    self.pwdView = pwdView;
    
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-114, VIEW_HEIGHT)];
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
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-102, 0, 44, VIEW_HEIGHT)];
    [showBtn setImage:[UIImage imageNamed:@"login_pwd_hidden"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"login_pwd_show"] forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(clickShowPwdBtn:) forControlEvents:UIControlEventTouchUpInside];
    showBtn.adjustsImageWhenHighlighted = NO;
    [pwdView addSubview:showBtn];
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH*0.5+42+VIEW_HEIGHT, SCREEN_WIDTH-174, VIEW_HEIGHT)];
    codeView.layer.borderColor = COLOR_D3D3D3.CGColor;
    codeView.layer.cornerRadius = CORNER_RADIUS;
    codeView.layer.borderWidth = 0.5;
    [self addSubview:codeView];
    self.codeView = codeView;
    codeView.hidden = YES;
    
    UITextField *codeTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-192, VIEW_HEIGHT)];
    codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.returnKeyType = UIReturnKeyDone;
    codeTF.placeholder = @"请输入验证码";
    [codeView addSubview:codeTF];
    codeTF.delegate = self;
    self.codeTF = codeTF;
    
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-137, SCREEN_WIDTH*0.5+42+VIEW_HEIGHT, 108, VIEW_HEIGHT)];
    codeBtn.layer.cornerRadius = CORNER_RADIUS;
    codeBtn.backgroundColor = APP_COLOR;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickMsgCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:codeBtn];
    self.codeBtn = codeBtn;
    codeBtn.hidden = YES;
    
    //手机短信、密码登录
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    switchBtn.frame = CGRectMake(29, SCREEN_WIDTH*0.5+VIEW_HEIGHT*2+60, 82, VIEW_HEIGHT-2);
    switchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [switchBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    [switchBtn setTitle:@"手机短信登录" forState:UIControlStateNormal];
    switchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [switchBtn addTarget:self action:@selector(clickSwitchLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchBtn];
    
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 15)];
    spLine.center = CGPointMake(117, switchBtn.center.y);
    spLine.backgroundColor = COLOR_666666;
    [self addSubview:spLine];
    
    //邮箱/账号登录
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    emailBtn.frame = CGRectMake(127, SCREEN_WIDTH*0.5+VIEW_HEIGHT*2+60, 100, VIEW_HEIGHT-2);
    emailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [emailBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    [emailBtn setTitle:@"邮箱/账号登录" forState:UIControlStateNormal];
    emailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [emailBtn addTarget:self action:@selector(clickEmailBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emailBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(29, SCREEN_WIDTH*0.5+63+VIEW_HEIGHT*3, SCREEN_WIDTH-58, VIEW_HEIGHT);
    loginBtn.layer.cornerRadius = CORNER_RADIUS;
    loginBtn.backgroundColor = APP_COLOR;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(29, SCREEN_WIDTH*0.5+63+VIEW_HEIGHT*4, 60, VIEW_HEIGHT-6);
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetBtn.frame = CGRectMake(SCREEN_WIDTH-109, SCREEN_WIDTH*0.5+63+VIEW_HEIGHT*4, 80, VIEW_HEIGHT-6);
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetBtn];
    
    CGFloat bottom = BOTTOM_H;
    if (bottom == 0) bottom = 20;
    else bottom = 30;
    NSMutableAttributedString *attrStr;
    if (SCREEN_WIDTH == 320) {
        attrStr = [[NSMutableAttributedString alloc] initWithString:@"———-    第三方登录    -———"];
        [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange(8, 5)];
    } else {
        attrStr = [[NSMutableAttributedString alloc] initWithString:@"——————    第三方登录    ——————"];
        [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_333333 range:NSMakeRange(10, 5)];
    }
    
    UILabel *thirdLab = [[UILabel alloc] initWithFrame:CGRectMake(18, SCREEN_HEIGHT-bottom-44-VIEW_HEIGHT, SCREEN_WIDTH-36, VIEW_HEIGHT)];
    thirdLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    thirdLab.textAlignment = NSTextAlignmentCenter;
    thirdLab.textColor = SEPARATOR_COLOR;
    [thirdLab setAttributedText:attrStr];
    [self addSubview:thirdLab];
    self.thirdLab = thirdLab;
    
    UIButton *qqBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-108)/2, SCREEN_HEIGHT-bottom-44, 44, 44)];
    [qqBtn setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(clickQQBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qqBtn];
    self.qqBtn = qqBtn;
    
    UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+20)/2, SCREEN_HEIGHT-bottom-44, 44, 44)];
    [wechatBtn setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(clickWeChatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wechatBtn];
    self.wechatBtn = wechatBtn;
}

#pragma mark ------ 选择手机号地区 ------
- (void)clickAreaView {
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.areaImgView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLSelectNationView showWithFrame:CGRectMake(29, SCREEN_WIDTH*0.5+38+VIEW_HEIGHT, SCREEN_WIDTH-58, SCREEN_HEIGHT-SCREEN_WIDTH*0.5-VIEW_HEIGHT-BOTTOM_H-60) finish:^(NSDictionary *dict) {
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

#pragma mark ------ 选择历史记录 ------
- (void)clickPullBtn {
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.pullBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    BOOL phone = NO;
    NSArray *history = self.emailArr;
    if (self.type == ADLLoginTypePassword || self.type == ADLLoginTypeMessage) {
        history = self.phoneArr;
        phone = YES;
    }
    [ADLAccHistoryView showWithFrame:CGRectMake(29, SCREEN_WIDTH*0.5+38+VIEW_HEIGHT, SCREEN_WIDTH-58, SCREEN_HEIGHT-SCREEN_WIDTH*0.5-VIEW_HEIGHT-BOTTOM_H-60) dataArr:history phone:phone finish:^(NSString *account, NSArray *history) {
        if (account) {
            self.phoneTF.text = account;
        }
        if (history.count == 0) {
            self.pullBtn.hidden = YES;
            CGRect frame = self.phoneTF.frame;
            frame.size.width = frame.size.width+38;
            self.phoneTF.frame = frame;
        }
        if (phone) {
            self.phoneArr = history;
        } else {
            self.emailArr = history;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.pullBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark ------ 获取验证码 ------
- (void)clickMsgCodeBtn:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        [ADLToast showMessage:@"请输入手机号"];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"3" forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
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

#pragma mark ------ 切换登录方式 ------
- (void)clickSwitchLoginBtn:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    BOOL editing = NO;
    if ([self.phoneTF isFirstResponder] || [self.pwdTF isFirstResponder]) {
        editing = YES;
    }
    [self endEditing:YES];
    if ([title isEqualToString:@"手机短信登录"]) {
        self.type = ADLLoginTypeMessage;
        self.pwdView.hidden = YES;
        self.codeView.hidden = NO;
        self.codeBtn.hidden = NO;
        [sender setTitle:@"手机账号登录" forState:UIControlStateNormal];
    } else {
        self.type = ADLLoginTypePassword;
        self.pwdView.hidden = NO;
        self.codeView.hidden = YES;
        self.codeBtn.hidden = YES;
        [sender setTitle:@"手机短信登录" forState:UIControlStateNormal];
    }
    if (self.areaView.hidden) {
        self.areaView.hidden = NO;
        self.phoneView.frame = CGRectMake(108, SCREEN_WIDTH*0.5+30, SCREEN_WIDTH-136, VIEW_HEIGHT);
        self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTF.placeholder = @"请输入手机号码";
        self.phoneTF.text = @"";
        self.codeTF.text = @"";
        self.pwdTF.text = @"";
        
        if (self.phoneArr.count == 0) {
            self.pullBtn.hidden = YES;
            self.phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-154, VIEW_HEIGHT);
        } else {
            self.pullBtn.hidden = NO;
            self.pullBtn.frame = CGRectMake(SCREEN_WIDTH-174, 0, 38, VIEW_HEIGHT);
            self.phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-192, VIEW_HEIGHT);
        }
    }
    if (editing) {
        [self.phoneTF becomeFirstResponder];
    }
}

#pragma mark ------ 邮箱账号登录 ------
- (void)clickEmailBtn {
    if (!self.areaView.hidden) {
        BOOL editing = NO;
        if ([self.phoneTF isFirstResponder] || [self.pwdTF isFirstResponder] || [self.codeTF isFirstResponder]) {
            editing = YES;
        }
        [self endEditing:YES];
        self.areaView.hidden = YES;
        self.phoneView.frame = CGRectMake(29, SCREEN_WIDTH*0.5+30, SCREEN_WIDTH-58, VIEW_HEIGHT);
        self.phoneTF.keyboardType = UIKeyboardTypeEmailAddress;
        self.phoneTF.placeholder = @"请输入邮箱/账号";
        self.phoneTF.text = @"";
        self.codeTF.text = @"";
        self.pwdTF.text = @"";
        if (self.emailArr.count == 0) {
            self.pullBtn.hidden = YES;
            self.phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-75, VIEW_HEIGHT);
        } else {
            self.pullBtn.hidden = NO;
            self.pullBtn.frame = CGRectMake(SCREEN_WIDTH-96, 0, 38, VIEW_HEIGHT);
            self.phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-108, VIEW_HEIGHT);
        }
        if (self.type == ADLLoginTypeMessage) {
            self.pwdView.hidden = NO;
            self.codeView.hidden = YES;
            self.codeBtn.hidden = YES;
        }
        if (editing) {
            [self.phoneTF becomeFirstResponder];
        }
        self.type = ADLLoginTypeEmail;
    }
}

#pragma mark ------ 登录 ------
- (void)clickLoginBtn {
    if (self.phoneTF.text.length == 0) {
        if (self.type == ADLLoginTypeEmail) {
            [ADLToast showMessage:@"请输入邮箱/账号"];
        } else {
            [ADLToast showMessage:@"请输入手机号"];
        }
        return;
    }
    if (self.type == ADLLoginTypeMessage) {
        if (self.codeTF.text.length == 0) {
            [ADLToast showMessage:@"请输入验证码"];
            return;
        }
    } else {
        if (self.pwdTF.text.length < 6) {
            [ADLToast showMessage:@"请输入6-18位密码"];
            return;
        }
    }
    
    [self endEditing:YES];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    
    NSString *path = ADEL_registerLogin;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN] forKey:@"imei"];
    
    BOOL phoneLogin = YES;
    if (self.type == ADLLoginTypePassword) {
        [params setValue:@"2" forKey:@"type"];
        [params setValue:self.nationName forKey:@"nationName"];
        [params setValue:self.phoneTF.text forKey:@"loginAccount"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
        
    } else if (self.type == ADLLoginTypeMessage) {
        [params setValue:@"4" forKey:@"type"];
        [params setValue:self.phoneTF.text forKey:@"phone"];
        [params setValue:self.nationName forKey:@"nationName"];
        [params setValue:self.codeTF.text forKey:@"verificationCode"];
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
        path = ADEL_LOGI;
    } else {
        phoneLogin = NO;
        [params setValue:self.phoneTF.text forKey:@"loginAccount"];
        [params setValue:[ADLUtils md5Encrypt:self.pwdTF.text lower:YES] forKey:@"password"];
        if ([ADLUtils verifyEmailAddress:self.phoneTF.text]) {
            [params setValue:@"3" forKey:@"type"];
        } else {
            [params setValue:@"1" forKey:@"type"];
        }
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self saveAccount:phoneLogin];
            if (self.delegate && [self.delegate respondsToSelector:@selector(verifyToken:)]) {
                [self.delegate verifyToken:responseDict[@"data"]];
            }
        }
    } failure:nil];
}

#pragma mark ------ 保存账号 ------
- (void)saveAccount:(BOOL)phoneLogin {
    if (phoneLogin) {
        if (![self.phoneArr containsObject:self.phoneTF.text]) {
            NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
            [phoneArray addObject:self.phoneTF.text];
            if (self.phoneArr.count > 0) {
                [phoneArray addObjectsFromArray:self.phoneArr];
            } else {
                self.pullBtn.hidden = NO;
                self.pullBtn.frame = CGRectMake(SCREEN_WIDTH-174, 0, 38, VIEW_HEIGHT);
                self.phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-192, VIEW_HEIGHT);
            }
            [ADLUtils saveObject:phoneArray fileName:HISTORY_PHONE permanent:YES];
            self.phoneArr = [NSArray arrayWithArray:phoneArray];
        }
    } else {
        if (![self.emailArr containsObject:self.phoneTF.text]) {
            NSMutableArray *emailArray = [[NSMutableArray alloc] init];
            [emailArray addObject:self.phoneTF.text];
            if (self.emailArr.count > 0) {
                [emailArray addObjectsFromArray:self.emailArr];
            } else {
                self.pullBtn.hidden = NO;
                self.pullBtn.frame = CGRectMake(SCREEN_WIDTH-96, 0, 38, VIEW_HEIGHT);
                self.phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-108, VIEW_HEIGHT);
            }
            [ADLUtils saveObject:emailArray fileName:HISTORY_EMAIL permanent:YES];
            self.emailArr = [NSArray arrayWithArray:emailArray];
        }
    }
}

#pragma mark ------ 注册 ------
- (void)clickRegisterBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRegisterBtn)]) {
        [self.delegate didClickRegisterBtn];
    }
}

#pragma mark ------ 忘记密码 ------
- (void)clickForgetBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickForgetBtn)]) {
        [self.delegate didClickForgetBtn];
    }
}

#pragma mark ------ QQ ------
- (void)clickQQBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickQQLoginBtn)]) {
        [self.delegate didClickQQLoginBtn];
    }
}

#pragma mark ------ 微信 ------
- (void)clickWeChatBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickWechatLoginBtn)]) {
        [self.delegate didClickWechatLoginBtn];
    }
}

#pragma mark ------ 返回 ------
- (void)clickBackBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackBtn)]) {
        [self.delegate didClickBackBtn];
    }
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
        if (self.type == ADLLoginTypeMessage || self.type == ADLLoginTypePassword) {
            return [ADLUtils phoneTextField:textField replacementString:string];
        } else {
            return YES;
        }
    } else if (textField == self.pwdTF) {
        return [ADLUtils limitedTextField:textField replacementString:string maxLength:18];
    } else {
        return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:YES];
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
