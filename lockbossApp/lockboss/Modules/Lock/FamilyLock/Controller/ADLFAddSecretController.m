//
//  ADLFAddSecretController.m
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFAddSecretController.h"
#import "ADLPwdKeyboardView.h"
#import "ADLSelectTimeView.h"
#import "ADLAttachView.h"
#import "ADLL2PlusAddFaceController.h"
@interface ADLFAddSecretController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *remarkTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UILabel *fingerLab;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *endLab;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSString *fingerId;
@property (nonatomic, assign) CGRect attachF;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ADLFAddSecretController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titStr = @"添加密码";
    if (self.type == 2) titStr = @"添加指纹";
    if (self.type == 3) titStr = @"添加IC卡";
    if (self.type == 4) titStr = @"添加人脸";
    [self addRedNavigationView:titStr];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self setupSubView];
}

#pragma mark ------ 初始化视图 ------
- (void)setupSubView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat remarkW = [ADLUtils calculateString:ADLString(@"remark_name") rectSize:CGSizeMake(MAXFLOAT, 36) fontSize:FONT_SIZE].width+2;
    UILabel *remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+20, remarkW, 44)];
    remarkLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    remarkLab.text = ADLString(@"remark_name");
    remarkLab.textColor = COLOR_333333;
    [self.view addSubview:remarkLab];
    
    UIView *remarkView = [[UIView alloc] initWithFrame:CGRectMake(remarkW+12, NAVIGATION_H+20, SCREEN_WIDTH-remarkW-24, 44)];
    remarkView.layer.borderColor = COLOR_D3D3D3.CGColor;
    remarkView.layer.cornerRadius = CORNER_RADIUS;
    remarkView.layer.borderWidth = 0.5;
    [self.view addSubview:remarkView];
    
    UITextField *remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-remarkW-41, 44)];
    remarkTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    remarkTF.placeholder = ADLString(@"remark_name_ph");
    remarkTF.font = [UIFont systemFontOfSize:FONT_SIZE];
    remarkTF.keyboardType = UIKeyboardTypeDefault;
    remarkTF.returnKeyType = UIReturnKeyDone;
    remarkTF.delegate = self;
    [remarkView addSubview:remarkTF];
    self.remarkTF = remarkTF;
    
    UILabel *validLab = [[UILabel alloc] init];
    validLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    validLab.text = ADLString(@"valid_time");
    validLab.textColor = COLOR_333333;
    [self.view addSubview:validLab];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    UILabel *startLab = [[UILabel alloc] init];
    startLab.font = [UIFont systemFontOfSize:13];
    startLab.textAlignment = NSTextAlignmentCenter;
    startLab.text = [formatter stringFromDate:[NSDate date]];
    startLab.textColor = APP_COLOR;
    [self.view addSubview:startLab];
    self.startLab = startLab;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"arrow_right"];
    [self.view addSubview:imgView];
    
    UILabel *endLab = [[UILabel alloc] init];
    endLab.font = [UIFont systemFontOfSize:13];
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.text = ADLString(@"permanent");
    endLab.textColor = APP_COLOR;
    [self.view addSubview:endLab];
    self.endLab = endLab;
    
    CGFloat validY = 0;
    if (self.type == 3) {
        validY = NAVIGATION_H+76;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResultNotification:) name:@"ADELfamilLocCardNotification" object:nil];
    } else {
        UILabel *pwdLab = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+76, remarkW, 44)];
        pwdLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        pwdLab.textColor = COLOR_333333;
        [self.view addSubview:pwdLab];
        
        UIView *pwdView = [[UIView alloc] initWithFrame:CGRectMake(remarkW+12, NAVIGATION_H+76, SCREEN_WIDTH-remarkW-24, 44)];
        pwdView.layer.borderColor = COLOR_D3D3D3.CGColor;
        pwdView.layer.cornerRadius = CORNER_RADIUS;
        pwdView.layer.borderWidth = 0.5;
        [self.view addSubview:pwdView];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-remarkW-63, 0, 39, 44)];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        rightBtn.adjustsImageWhenHighlighted = NO;
        [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pwdView addSubview:rightBtn];
        self.rightBtn = rightBtn;
        
        if (self.type == 1) {
            validY = NAVIGATION_H+164;
            pwdLab.text = [NSString stringWithFormat:@"%@：",ADLString(@"password")];
            [rightBtn setImage:[UIImage imageNamed:@"login_pwd_hidden"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"login_pwd_show"] forState:UIControlStateSelected];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResultNotification:) name:@"ADELLockPasswordMQNotification" object:nil];
            
            UILabel *promLab = [[UILabel alloc] initWithFrame:CGRectMake(remarkW+12, NAVIGATION_H+120, SCREEN_WIDTH-remarkW-24, 44)];
            promLab.font = [UIFont systemFontOfSize:12];
            promLab.text = @"请输入以1为开头的11位数的密码";
            promLab.numberOfLines = 2;
            promLab.textColor = APP_COLOR;
            [self.view addSubview:promLab];
            
            __weak typeof(self)weakSelf = self;
            ADLPwdKeyboardView *kbView = [ADLPwdKeyboardView keyboardView];
            kbView.clickAction = ^(NSInteger num) {
                if (num == 4) {
                    [weakSelf.pwdTF resignFirstResponder];
                } else {
                    NSInteger location = [weakSelf.pwdTF offsetFromPosition:weakSelf.pwdTF.beginningOfDocument toPosition:weakSelf.pwdTF.selectedTextRange.start];
                    NSInteger selectLenght = [weakSelf.pwdTF offsetFromPosition:weakSelf.pwdTF.selectedTextRange.start toPosition:weakSelf.pwdTF.selectedTextRange.end];
                    if (num == 5) {
                        if (weakSelf.pwdTF.text.length > 0) {
                            if (selectLenght > 0) {
                                [weakSelf.pwdTF replaceRange:weakSelf.pwdTF.selectedTextRange withText:@""];
                            } else {
                                UITextPosition *begin = weakSelf.pwdTF.beginningOfDocument;
                                UITextPosition *start = [weakSelf.pwdTF positionFromPosition:begin offset:location];
                                UITextPosition *end = [weakSelf.pwdTF positionFromPosition:start offset:-1];
                                UITextRange *textRange = [weakSelf.pwdTF textRangeFromPosition:start toPosition:end];
                                [weakSelf.pwdTF replaceRange:textRange withText:@""];
                            }
                        }
                    } else {
                        if (selectLenght > 0) {
                            [weakSelf.pwdTF replaceRange:weakSelf.pwdTF.selectedTextRange withText:[NSString stringWithFormat:@"%ld",num]];
                        } else {
                            if (weakSelf.pwdTF.text.length < 11) {
                                UITextPosition *begin = weakSelf.pwdTF.beginningOfDocument;
                                UITextPosition *start = [weakSelf.pwdTF positionFromPosition:begin offset:location];
                                UITextPosition *end = [weakSelf.pwdTF positionFromPosition:start offset:0];
                                UITextRange *textRange = [weakSelf.pwdTF textRangeFromPosition:start toPosition:end];
                                [weakSelf.pwdTF replaceRange:textRange withText:[NSString stringWithFormat:@"%ld",num]];
                            }
                        }
                    }
                }
            };
            
            UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-remarkW-80, 44)];
            pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            pwdTF.font = [UIFont systemFontOfSize:FONT_SIZE];
            pwdTF.placeholder = @"请输入密码";
            pwdTF.secureTextEntry = YES;
            pwdTF.inputView = kbView;
            [pwdView addSubview:pwdTF];
            self.pwdTF = pwdTF;
            
        } else {
            validY = NAVIGATION_H+132;
            pwdLab.text = ADLString(@"fingerp_lib");
            [rightBtn setImage:[UIImage imageNamed:@"pull_down"] forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResultNotification:) name:@"ADELfamilFingerprintNotification" object:nil];
            
            UILabel *fingerLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-remarkW-80, 44)];
            fingerLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            fingerLab.userInteractionEnabled = YES;
            fingerLab.text = @"本地上传指纹";
            fingerLab.textColor = COLOR_333333;
            [pwdView addSubview:fingerLab];
            self.fingerLab = fingerLab;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFingerLab)];
            [fingerLab addGestureRecognizer:tap];
            
            self.attachF = CGRectMake(remarkW+12, NAVIGATION_H+120, SCREEN_WIDTH-remarkW-24, 44);
            [self.dataArr addObject:@{@"name":@"本地上传指纹"}];
            [self queryFingerPrintData];
        }
    }
    
    validLab.frame = CGRectMake(12, validY, 200, 44);
    startLab.frame = CGRectMake(0, validY+54, (SCREEN_WIDTH-25)/2, 20);
    imgView.frame = CGRectMake((SCREEN_WIDTH-25)/2, validY+54, 25, 20);
    endLab.frame = CGRectMake((SCREEN_WIDTH+25)/2, validY+54, (SCREEN_WIDTH-25)/2, 20);
    
    self.btnArr = [[NSMutableArray alloc] init];
    CGFloat dayW = [ADLUtils calculateString:ADLString(@"one_day") rectSize:CGSizeMake(MAXFLOAT, 32) fontSize:13].width+26;
    CGFloat weekW = [ADLUtils calculateString:ADLString(@"one_week") rectSize:CGSizeMake(MAXFLOAT, 32) fontSize:13].width+26;
    CGFloat monthW = [ADLUtils calculateString:ADLString(@"one_month") rectSize:CGSizeMake(MAXFLOAT, 32) fontSize:13].width+26;
    CGFloat permW = [ADLUtils calculateString:ADLString(@"permanent") rectSize:CGSizeMake(MAXFLOAT, 32) fontSize:13].width+26;
    CGFloat custW = [ADLUtils calculateString:ADLString(@"customize") rectSize:CGSizeMake(MAXFLOAT, 32) fontSize:13].width+49;
    
    CGFloat btnY = validY+129;
    [self creatBtnWithFrame:CGRectMake(12, btnY, dayW, 32) title:ADLString(@"one_day") tag:0];
    [self creatBtnWithFrame:CGRectMake(dayW+24, btnY, weekW, 32) title:ADLString(@"one_week") tag:1];
    [self creatBtnWithFrame:CGRectMake(dayW+weekW+36, btnY, monthW, 32) title:ADLString(@"one_month") tag:2];
    
    CGRect permF = CGRectMake(dayW+weekW+monthW+48, btnY, permW, 32);
    CGRect custF = CGRectMake(12, btnY+44, custW, 32);
    if (SCREEN_WIDTH-dayW-weekW-monthW-permW-60 > 0) {
        if (SCREEN_WIDTH-dayW-weekW-monthW-permW-custW-72 > 0) {
            custF = CGRectMake(dayW+weekW+monthW+permW+60, btnY, custW, 32);
        }
    } else {
        permF = CGRectMake(12, btnY+44, permW, 32);
        custF = CGRectMake(permW+24, btnY+44, custW, 32);
    }
    [self creatBtnWithFrame:permF title:ADLString(@"permanent") tag:3];
    [self creatBtnWithFrame:custF title:ADLString(@"customize") tag:4];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(20, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT-24, SCREEN_WIDTH-40, VIEW_HEIGHT);
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    if(self.type == 4){
       [addBtn setTitle:ADLString(@"next_step") forState:UIControlStateNormal];
    }else{
        [addBtn setTitle:ADLString(@"add") forState:UIControlStateNormal];
    }
    
    
    addBtn.backgroundColor = APP_COLOR;
    addBtn.layer.cornerRadius = CORNER_RADIUS;
    [addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

#pragma mark ------ 创建按钮 ------
- (void)creatBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [button setTitleColor:APP_COLOR forState:UIControlStateSelected];
    button.layer.borderColor = COLOR_D3D3D3.CGColor;
    button.layer.cornerRadius = 4;
    button.layer.borderWidth = 0.5;
    button.tag = tag;
    if (tag == 4) {
        [button setImage:[UIImage imageNamed:@"sel_date_n"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"sel_date_s"] forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 21, 0, 0);
    } else {
        if (tag == 3) {
            button.selected = YES;
            button.layer.borderColor = APP_COLOR.CGColor;
        }
    }
    [self.btnArr addObject:button];
    [button addTarget:self action:@selector(clickDateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [ADLUtils limitedTextField:textField replacementString:string maxLength:18];
}

#pragma mark ------ 点击选择指纹Lab ------
- (void)clickFingerLab {
    [self selectFingerprint];
}

#pragma mark ------ 显示隐藏密码 ------
- (void)clickRightBtn:(UIButton *)sender {
    if (self.type == 2) {
        [self selectFingerprint];
    } else {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.pwdTF.secureTextEntry = NO;
        } else {
            self.pwdTF.secureTextEntry = YES;
        }
        [ADLUtils dealWithSecureEntryWithTextField:self.pwdTF];
    }
}

#pragma mark ------ 选择指纹 ------
- (void)selectFingerprint {
    NSArray *titArr = [ADLUtils dictArrayToArray:self.dataArr key:@"name"];
    CGRect aframe = self.attachF;
    NSInteger count = self.dataArr.count;
    if (count > 6) count = 6;
    aframe.size.height = count*44;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [ADLAttachView showWithFrame:aframe titleArr:titArr finish:^(NSInteger index) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rightBtn.transform = CGAffineTransformIdentity;
        }];
        if (index != -1) {
            self.fingerId = self.dataArr[index][@"id"];
            self.fingerLab.text = self.dataArr[index][@"name"];
        }
    }];
}

#pragma mark ------ 点击日期按钮 ------
- (void)clickDateBtn:(UIButton *)sender {
    if (sender.tag == 4) {
        [self.view endEditing:YES];
        [ADLSelectTimeView showWithTitle:@"选择时间" period:YES posterior:NO finish:^(NSString *dateStr) {
            NSArray *arr = [dateStr componentsSeparatedByString:@","];
            self.startLab.text = arr.firstObject;
            self.endLab.text = arr.lastObject;
            if (!sender.selected) {
                [self dealwithBtn:sender];
            }
        }];
    } else {
        if (sender.selected) return;
        [self dealwithBtn:sender];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        self.startLab.text = [formatter stringFromDate:[NSDate date]];
        switch (sender.tag) {
            case 0:
                self.endLab.text = [ADLUtils dateWithMinuteDelay:1440 format:nil];
                break;
            case 1:
                self.endLab.text = [ADLUtils dateWithMinuteDelay:10080 format:nil];
                break;
            case 2:
                self.endLab.text = [ADLUtils dateWithMonthDelay:1 format:nil];
                break;
            case 3:
                self.endLab.text = ADLString(@"permanent");
                break;
        }
    }
}

#pragma mark ------ 处理按钮选中 ------
- (void)dealwithBtn:(UIButton *)sender {
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == sender.tag) {
            obj.selected = YES;
            obj.layer.borderColor = APP_COLOR.CGColor;
        } else {
            obj.selected = NO;
            obj.layer.borderColor = COLOR_D3D3D3.CGColor;
        }
    }];
}

#pragma mark ------ 退出编辑 ------
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark ------ 获取指纹数据 ------
- (void)queryFingerPrintData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_searchMyFingers parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
        }
    } failure:nil];
}

#pragma mark ------ 添加 ------
- (void)clickAddBtn {
    NSString *remark = [self.remarkTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (remark.length == 0) {
        [ADLToast showMessage:@"请输入备注名称"];
        return;
    }
    
    if (self.type == 1) {
        if (self.pwdTF.text.length == 0) {
            [ADLToast showMessage:@"请输入密码"];
            return;
        }
        if (![self.pwdTF.text hasPrefix:@"1"]) {
            [ADLToast showMessage:@"密码必须为1开头"];
            return;
        }
        if (self.pwdTF.text.length != 11) {
            [ADLToast showMessage:@"密码必须为11位"];
            return;
        }
    }
    
//    if(self.type == 4){
        ADLLog(@"去添加人脸的界面-------->");
        ADLL2PlusAddFaceController *plusAddVC = [[ADLL2PlusAddFaceController alloc] init];
        [self.navigationController pushViewController:plusAddVC animated:YES];
        return;
//    }
    
    NSString *path = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.deviceCode forKey:@"deviceCode"];
    [params setValue:self.deviceType forKey:@"deviceType"];
    [params setValue:self.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.remarkTF.text forKey:@"remarkName"];
    
    if (self.type == 1) {
        path = ADEL_family_addSecretPassword;
        [params setValue:[NSString stringWithFormat:@"%@00",[self dealwithPwd:self.pwdTF.text]] forKey:@"devicePassWord"];
    } else if (self.type == 2) {
        if (self.fingerId.length > 0) {
            path = ADEL_family_sendHoldFingerprint;
            [params setValue:self.fingerId forKey:@"secretId"];
        } else {
            path = ADEL_family_addSecretFingerprint;
        }
    } else {
        path = ADEL_family_activateRoomCrad;
    }
    
    NSInteger tag = 0;
    for (UIButton *btn in self.btnArr) {
        if (btn.selected) {
            tag = btn.tag;
            break;
        }
    }
    
    if (tag == 4) {
        [params setValue:[ADLUtils timestampWithDateStr:self.startLab.text format:@"yyyy-MM-dd HH:mm"] forKey:@"startDatetime"];
    } else {
        [params setValue:@"" forKey:@"startDatetime"];
    }
    
    if ([self.endLab.text isEqualToString:ADLString(@"permanent")]) {
        [params setValue:@"-1" forKey:@"endDatetime"];
    } else {
        [params setValue:[ADLUtils timestampWithDateStr:self.endLab.text format:@"yyyy-MM-dd HH:mm"] forKey:@"endDatetime"];
    }
    
    if (self.type != 3) {
        [params setValue:@"2" forKey:@"dataType"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:@"添加中..."];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(addFailed) userInfo:nil repeats:NO];
        }
    } failure:nil];
}

#pragma mark ------ 处理密码 ------
- (NSString *)dealwithPwd:(NSString *)pwd {
    pwd = [pwd stringByReplacingOccurrencesOfString:@"3" withString:@"33"];
    pwd = [pwd stringByReplacingOccurrencesOfString:@"2" withString:@"32"];
    pwd = [pwd stringByReplacingOccurrencesOfString:@"1" withString:@"31"];
    pwd = [pwd stringByReplacingOccurrencesOfString:@"0" withString:@"30"];
    return pwd;
}

#pragma mark ------ 添加超时 ------
- (void)addFailed {
    [self.timer invalidate];
    [ADLToast showMessage:@"添加失败"];
}

#pragma mark ------ 添加结果通知 ------
- (void)addResultNotification:(NSNotification *)notification {
    [self.timer invalidate];
    if ([notification.userInfo[@"resultCode"] intValue] == 10000) {
        [ADLToast showMessage:@"添加成功"];
        if (self.success) {
            self.success();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        [ADLToast showMessage:[notification.userInfo[@"msg"] stringValue]];
    }
}

@end
