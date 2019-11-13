//
//  ADLModifyView.m
//  lockboss
//
//  Created by adel on 2019/7/31.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLModifyView.h"
#import "ADLGlobalDefine.h"
#import "ADLNetWorkManager.h"
#import "ADLLocalizedHelper.h"
#import "ADLSelectNationView.h"
#import "ADLToast.h"
#import "ADLUtils.h"

@interface ADLModifyView ()<UITextFieldDelegate>
@property (nonatomic, copy) void (^confirmAction) (NSString *input);
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) ADLModifyType type;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *areaLab;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation ADLModifyView

+ (instancetype)modifyViewWithType:(ADLModifyType)type
                          dataDict:(NSDictionary *)dataDict
                     confirmAction:(void(^)(NSString *))confirmAction {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds type:type dataDict:dataDict confirmAction:confirmAction];
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(ADLModifyType)type
                     dataDict:(NSDictionary *)dataDict
                confirmAction:(void (^)(NSString *))confirmAction {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.dataDict = dataDict;
        self.confirmAction = confirmAction;
        
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        [self addSubview:coverView];
        self.coverView = coverView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleEditing)];
        [coverView addGestureRecognizer:tap];
        
        UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, SCREEN_HEIGHT, 300, 220)];
        panelView.backgroundColor = [UIColor whiteColor];
        panelView.layer.cornerRadius = 5;
        panelView.clipsToBounds = YES;
        [self addSubview:panelView];
        self.panelView = panelView;
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.textColor = COLOR_333333;
        titLab.text = dataDict[@"title"];
        [panelView addSubview:titLab];
        
        UITextField *inputTF = [[UITextField alloc] init];
        inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputTF.borderStyle = UITextBorderStyleRoundedRect;
        inputTF.font = [UIFont systemFontOfSize:FONT_SIZE];
        inputTF.placeholder = dataDict[@"placeholder"];
        inputTF.returnKeyType = UIReturnKeyDone;
        inputTF.delegate = self;
        inputTF.tag = 23;
        [panelView addSubview:inputTF];
        self.inputTF = inputTF;
        
        UITextField *codeTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 111, 150, 45)];
        codeTF.keyboardType = UIKeyboardTypeNumberPad;
        codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        codeTF.borderStyle = UITextBorderStyleRoundedRect;
        codeTF.font = [UIFont systemFontOfSize:FONT_SIZE];
        codeTF.returnKeyType = UIReturnKeyDone;
        codeTF.placeholder = @"请输入验证码";
        codeTF.delegate = self;
        [panelView addSubview:codeTF];
        self.codeTF = codeTF;
        
        UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(176, 111, 108, 45)];
        [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeBtn.backgroundColor = APP_COLOR;
        codeBtn.layer.cornerRadius = CORNER_RADIUS;
        [codeBtn addTarget:self action:@selector(getMsgCode) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:codeBtn];
        self.codeBtn = codeBtn;
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancleBtn.frame = CGRectMake(0, 170, 150, 50);
        [cancleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:cancleBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(150, 170, 150, 50);
        [confirmBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:confirmBtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 170, 300, 0.5)];
        line1.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(150, 170, 0.5, 50)];
        line2.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:line2];
        
        if (type == ADLModifyTypePhone) {
            UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(16, 54, 70, 45)];
            areaView.layer.borderWidth = 0.5;
            areaView.layer.cornerRadius = 5;
            areaView.layer.borderColor = COLOR_D3D3D3.CGColor;
            [panelView addSubview:areaView];
            UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAreaView)];
            [areaView addGestureRecognizer:areaTap];
            
            UILabel *areaLab = [[UILabel alloc] init];
            areaLab.font = [UIFont systemFontOfSize:13];
            areaLab.textColor = COLOR_333333;
            areaLab.text = @"+86";
            [areaView addSubview:areaLab];
            self.areaLab = areaLab;
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"phone_down"];
            [areaView addSubview:imgView];
            self.imgView = imgView;
            
            CGFloat titW = [ADLUtils calculateString:@"+86" rectSize:CGSizeMake(70, VIEW_HEIGHT) fontSize:13].width+15;
            areaLab.frame = CGRectMake(36-titW/2, 0, titW-13, 45);
            imgView.frame = CGRectMake(24+titW/2, 21, 9, 5);
            
            inputTF.frame = CGRectMake(96, 54, 188, 45);
            inputTF.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            inputTF.frame = CGRectMake(16, 54, 268, 45);
            inputTF.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.5;
            panelView.frame = CGRectMake(SCREEN_WIDTH/2-150, SCREEN_HEIGHT/2-110, 300, 220);
        }];
    }
    return self;
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 23) {
        if (self.type == ADLModifyTypePhone) {
            return [ADLUtils phoneTextField:textField replacementString:string];
        } else {
            return YES;
        }
    } else {
        return [ADLUtils numberTextField:textField replacementString:string maxLength:6 firstZero:YES];
    }
}

#pragma mark ------ 选择手机号地区 ------
- (void)clickAreaView {
    [self endEditing:YES];
    [ADLSelectNationView showWithFinish:^(NSDictionary *dict) {
        if (dict) {
            self.areaLab.text = dict[@"code"];
            CGFloat titW = [ADLUtils calculateString:dict[@"code"] rectSize:CGSizeMake(70, VIEW_HEIGHT) fontSize:13].width+15;
            self.areaLab.frame = CGRectMake(36-titW/2, 0, titW-13, VIEW_HEIGHT);
            self.imgView.frame = CGRectMake(24+titW/2, 21, 9, 5);
        }
    }];
}

#pragma mark ------ 获取验证码前检查输入信息 ------
- (void)getMsgCode {
    if (self.inputTF.text.length == 0) {
        [ADLToast showBottomMessage:self.dataDict[@"placeholder"]];
        return;
    }
    
    if (![ADLUtils verifyEmailAddress:self.inputTF.text] && self.type == ADLModifyTypeEmail) {
        [ADLToast showBottomMessage:@"请输入正确的邮箱账号"];
        return;
    }
    [self getMessageCodeWithPath:self.dataDict[@"code"] input:self.inputTF.text];
}

#pragma mark ------ 获取验证码 ------
- (void)getMessageCodeWithPath:(NSString *)path input:(NSString *)input {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:input forKey:self.dataDict[@"key"]];
    if (self.type == ADLModifyTypePhone) {
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
    }
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showBottomMessage:@"验证码已发送"];
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

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = CGRectMake(SCREEN_WIDTH/2-150, SCREEN_HEIGHT, 300, 220);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    if (self.inputTF.text.length == 0) {
        [ADLToast showBottomMessage:self.dataDict[@"placeholder"]];
        return;
    }
    if (![ADLUtils verifyEmailAddress:self.inputTF.text] && self.type == ADLModifyTypeEmail) {
        [ADLToast showBottomMessage:@"请输入正确的邮箱账号"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [ADLToast showBottomMessage:@"请输入验证码"];
        return;
    }
    
    NSDictionary *dict = self.dataDict[@"param"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [params setValue:self.codeTF.text forKey:dict[@"code"]];
    [params setValue:self.inputTF.text forKey:dict[@"input"]];
    if (self.type == ADLModifyTypePhone) {
        [params setValue:[self.areaLab.text substringFromIndex:1] forKey:@"nationCode"];
    }
    
    [ADLNetWorkManager postWithPath:self.dataDict[@"path"] parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showBottomMessage:@"修改成功"];
            [self clickCancleBtn];
            if (self.confirmAction) {
                self.confirmAction(self.inputTF.text);
            }
        }
    } failure:nil];
}

#pragma mark ------ 键盘将要显示 ------
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat keyboardH = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height ;
    if (SCREEN_HEIGHT/2-54-keyboardH < 0) {
        self.panelView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/2-54-keyboardH);
    }
}

#pragma mark ------ 键盘将要隐藏 ------
- (void)keyboardWillHide:(NSNotification *)notification {
    self.panelView.transform = CGAffineTransformIdentity;
}

#pragma mark ------ 退出编辑 ------
- (void)cancleEditing {
    [self endEditing:YES];
}

@end
