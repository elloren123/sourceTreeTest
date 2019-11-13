//
//  ADLPhoneMailController.m
//  lockboss
//
//  Created by adel on 2019/4/18.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLModPhoneMailController.h"
#import "ADLSelectNationView.h"

@interface ADLModPhoneMailController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *areaLab;
@property (nonatomic, strong) UIImageView *areaImgView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@end

@implementation ADLModPhoneMailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializationView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

#pragma mark ------ 初始化 ------
- (void)initializationView {
    UIView *phoneView = [[UIView alloc] init];
    phoneView.layer.borderColor = COLOR_D3D3D3.CGColor;
    phoneView.layer.cornerRadius = CORNER_RADIUS;
    phoneView.layer.borderWidth = 0.5;
    [self.view addSubview:phoneView];
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    phoneTF.returnKeyType = UIReturnKeyDone;
    [phoneView addSubview:phoneTF];
    phoneTF.delegate = self;
    self.phoneTF = phoneTF;
    
    if (self.phone) {
        UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(29, NAVIGATION_H+29, 70, VIEW_HEIGHT)];
        areaView.layer.borderWidth = 0.5;
        areaView.layer.cornerRadius = CORNER_RADIUS;
        areaView.layer.borderColor = COLOR_D3D3D3.CGColor;
        [self.view addSubview:areaView];
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
        
        phoneView.frame = CGRectMake(108, 29+NAVIGATION_H, SCREEN_WIDTH-136, VIEW_HEIGHT);
        phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-154, VIEW_HEIGHT);
        [self addNavigationView:@"修改手机号"];
        phoneTF.placeholder = @"请输入手机号码";
        phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        phoneView.frame = CGRectMake(29, NAVIGATION_H+29, SCREEN_WIDTH-58, VIEW_HEIGHT);
        phoneTF.frame = CGRectMake(12, 0, SCREEN_WIDTH-76, VIEW_HEIGHT);
        [self addNavigationView:@"修改邮箱"];
        phoneTF.placeholder = @"输入新邮箱";
        phoneTF.keyboardType = UIKeyboardTypeASCIICapable;
    }
    
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
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(29, 129+VIEW_HEIGHT*2+NAVIGATION_H, SCREEN_WIDTH-58, VIEW_HEIGHT);
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

#pragma mark ------ 选择手机号地区 ------
- (void)clickAreaView {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.areaImgView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLSelectNationView showWithFrame:CGRectMake(29, VIEW_HEIGHT+NAVIGATION_H+36, SCREEN_WIDTH-58, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-BOTTOM_H-60) finish:^(NSDictionary *dict) {
        if (dict) {
            self.areaLab.text = dict[@"code"];
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
    if (self.phone) {
        if (self.phoneTF.text.length == 0) {
            [ADLToast showMessage:@"请输入手机号"];
        } else {
            [self getMessageCode:k_send_msg_code key:@"phoneNumber"];
        }
    } else {
        if (self.phoneTF.text.length == 0) {
            [ADLToast showMessage:@"请输入邮箱账号"];
        } else {
            if ([ADLUtils verifyEmailAddress:self.phoneTF.text]) {
                [self getMessageCode:k_send_email_code key:@"email"];
            } else {
                [ADLToast showMessage:@"请输入正确邮箱"];
            }
        }
    }
}

#pragma mark ------ 获取验证码 ------
- (void)getMessageCode:(NSString *)path key:(NSString *)key {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.phone) {
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
    }
    [params setValue:self.phoneTF.text forKey:key];
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

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    NSString *path = k_update_phone;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *phone = self.phoneTF.text;
    if (self.phone) {
        if (phone.length == 0) {
            [ADLToast showMessage:@"请输入手机号"];
            return;
        }
        [params setValue:self.phoneTF.text forKey:@"phone"];
    } else {
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (phone.length == 0) {
            [ADLToast showMessage:@"请输入邮箱账号"];
            return;
        }
        if (![ADLUtils verifyEmailAddress:phone]) {
            [ADLToast showMessage:@"请输入正确邮箱"];
            return;
        }
        path = k_update_email;
        [params setValue:phone forKey:@"email"];
    }
    
    if (self.codeTF.text.length == 0) {
        [ADLToast showMessage:@"请输入验证码"];
        return;
    }
    
    [self.view endEditing:YES];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.codeTF.text forKey:@"code"];
    [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"修改成功"];
            ADLUserModel *model = [ADLUserModel sharedModel];
            if (self.phone) {
                model.phone = phone;
            } else {
                model.email = phone;
            }
            [ADLUserModel saveUserModel:model];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
