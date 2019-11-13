//
//  ADLUnlockPatternController.m
//  lockboss
//
//  Created by Adel on 2019/9/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLUnlockPatternController.h"
#import "ADLFAddSecretController.h"
#import "ADLDeviceModel.h"

@interface ADLUnlockPatternController ()
@property (nonatomic, strong) UILabel *promptLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIButton *groupBtn;
@property (nonatomic, strong) UIButton *customBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSDictionary *secretDict;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ADLUnlockPatternController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.model.jurisdiction isEqualToString:@"1"]) {
        [self addRedNavigationView:ADLString(@"unlock_method_setting")];
    } else {
        [self addRedNavigationView:ADLString(@"unlock_method")];
    }
    [self queryUnlockType];
    [self querySecret];
}

#pragma mark ------ 初始化视图 ------
- (void)setupSubview {
    //白色背景视图
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    //当前开门方式
    UILabel *promptLab = [[UILabel alloc] init];
    promptLab.font = [UIFont systemFontOfSize:13];
    promptLab.textColor = COLOR_333333;
    [self.view addSubview:promptLab];
    self.promptLab = promptLab;
    
    //开门包含的类型
    UILabel *typeLab = [[UILabel alloc] init];
    typeLab.font = [UIFont systemFontOfSize:13];
    typeLab.textColor = APP_COLOR;
    [self.view addSubview:typeLab];
    self.typeLab = typeLab;
    
    if ([self.model.jurisdiction isEqualToString:@"1"]) {
        self.btnArr = [[NSMutableArray alloc] init];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+20, SCREEN_WIDTH-24, 20)];
        label1.font = [UIFont systemFontOfSize:FONT_SIZE];
        label1.text = ADLString(@"select_unlock_m");
        label1.textColor = COLOR_333333;
        [self.view addSubview:label1];
        
        CGFloat groupBtnW = [ADLUtils calculateString:ADLString(@"multi_unlock_way") rectSize:CGSizeMake(MAXFLOAT, 38) fontSize:13].width+46;
        self.groupBtn = [self creatBtn:CGRectMake(29, NAVIGATION_H+55, groupBtnW, 38) title:ADLString(@"multi_unlock_way") tag:0];
        self.customBtn = [self creatBtn:CGRectMake(29, NAVIGATION_H+108, groupBtnW, 38) title:ADLString(@"custom_unlock_way") tag:1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+166, SCREEN_WIDTH-24, 20)];
        label2.font = [UIFont systemFontOfSize:FONT_SIZE];
        label2.text = ADLString(@"select_combination");
        label2.textColor = COLOR_333333;
        [self.view addSubview:label2];
        
        CGFloat phoneW = [ADLUtils calculateString:ADLString(@"phone") rectSize:CGSizeMake(MAXFLOAT, 34) fontSize:13].width+46;
        CGFloat pwdW = [ADLUtils calculateString:ADLString(@"password") rectSize:CGSizeMake(MAXFLOAT, 34) fontSize:13].width+46;
        CGFloat fingerW = [ADLUtils calculateString:ADLString(@"fingerprint") rectSize:CGSizeMake(MAXFLOAT, 34) fontSize:13].width+46;
        CGFloat mcardW = [ADLUtils calculateString:ADLString(@"mcard") rectSize:CGSizeMake(MAXFLOAT, 34) fontSize:13].width+46;
        
        [self creatBtn:CGRectMake(29, NAVIGATION_H+201, phoneW, 34) title:ADLString(@"phone") tag:2];
        [self creatBtn:CGRectMake(phoneW+41, NAVIGATION_H+201, pwdW, 34) title:ADLString(@"password") tag:3];
        
        CGRect fingerF = CGRectMake(phoneW+pwdW+53, NAVIGATION_H+201, fingerW, 34);
        CGRect mcardF = CGRectMake(29, NAVIGATION_H+250, mcardW, 34);
        if (SCREEN_WIDTH-phoneW-pwdW-82 > fingerW) {
            if (SCREEN_WIDTH-phoneW-pwdW-fingerW-94 > mcardW) {
                mcardF = CGRectMake(phoneW+pwdW+fingerW+65, NAVIGATION_H+201, mcardW, 34);
            }
        } else {
            fingerF = CGRectMake(29, NAVIGATION_H+250, fingerW, 34);
            mcardF = CGRectMake(fingerW+41, NAVIGATION_H+250, mcardW, 34);
        }
        [self creatBtn:fingerF title:ADLString(@"fingerprint") tag:4];
        [self creatBtn:mcardF title:ADLString(@"mcard") tag:5];
        
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, mcardF.origin.y+34, 20, 40)];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        setBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 29);
        setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [setBtn addTarget:self action:@selector(clickSetBtn:) forControlEvents:UIControlEventTouchUpInside];
        setBtn.hidden = YES;
        [self.view addSubview:setBtn];
        self.setBtn = setBtn;
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(12, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT-24, SCREEN_WIDTH-24, VIEW_HEIGHT);
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn setTitle:ADLString(@"confirm") forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        confirmBtn.layer.cornerRadius = CORNER_RADIUS;
        confirmBtn.backgroundColor = APP_COLOR;
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmBtn];
        
        whiteView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, mcardF.origin.y-NAVIGATION_H+74);
        promptLab.frame = CGRectMake(12, mcardF.origin.y+94, SCREEN_WIDTH-24, 20);
        typeLab.frame = CGRectMake(12, mcardF.origin.y+124, SCREEN_WIDTH-24, 20);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockTypeChanged:) name:@"ADELLoccombinationMQNotification" object:nil];
    } else {
        whiteView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
        promptLab.frame = CGRectMake(12, NAVIGATION_H+20, SCREEN_WIDTH-24, 20);
        typeLab.frame = CGRectMake(12, NAVIGATION_H+50, SCREEN_WIDTH-24, 20);
    }
}

#pragma mark ------ 创建按钮 ------
- (UIButton *)creatBtn:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 24, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 4;
    button.tag = tag;
    if (tag > 1) {
        button.layer.borderWidth = 0.5;
        [button setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"box_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"box_selected"] forState:UIControlStateSelected];
        [self.btnArr addObject:button];
    } else {
        button.layer.borderColor = APP_COLOR.CGColor;
        [button setTitleColor:APP_COLOR forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"unlock_group_n"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"unlock_group_s"] forState:UIControlStateSelected];
    }
    [button addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark ------ 查询开门方式 ------
- (void)queryUnlockType {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getGroupOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self setupSubview];
            [self updateUnlockMethod:responseDict[@"data"]];
        }
    } failure:nil];
}

#pragma mark ------ 更新开门方式 ------
- (void)updateUnlockMethod:(NSDictionary *)dict {
    BOOL phone = [dict[@"openApp"] boolValue];
    BOOL pwd = [dict[@"openPassword"] boolValue];
    BOOL finger = [dict[@"openFingerprint"] boolValue];
    BOOL mcard = [dict[@"openCard"] boolValue];
    NSString *typeStr = @"";
    NSMutableArray *openArr = [[NSMutableArray alloc] init];
    if (phone) {
        [openArr addObject:@(2)];
        typeStr = ADLString(@"phone");
    }
    if (pwd) {
        [openArr addObject:@(3)];
        typeStr = [NSString stringWithFormat:@"%@ + %@",typeStr,ADLString(@"password")];
    }
    if (finger) {
        [openArr addObject:@(4)];
        typeStr = [NSString stringWithFormat:@"%@ + %@",typeStr,ADLString(@"fingerprint")];
    }
    if (mcard) {
        [openArr addObject:@(5)];
        typeStr = [NSString stringWithFormat:@"%@ + %@",typeStr,ADLString(@"mcard")];
    }
    if ([typeStr hasPrefix:@" +"]) {
        typeStr = [typeStr substringFromIndex:2];
    }
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([openArr containsObject:@(obj.tag)]) {
            obj.layer.borderColor = APP_COLOR.CGColor;
            obj.selected = YES;
        } else {
            obj.layer.borderColor = COLOR_999999.CGColor;
            obj.selected = NO;
        }
    }];
    
    if ([dict[@"openGroup"] intValue] == 1) {
        self.promptLab.text = ADLString(@"unlock_method_multi");
        if (self.groupBtn) [self dealwithOpenMethodWithSelectBtn:self.groupBtn normalBtn:self.customBtn];
    } else {
        self.promptLab.text = ADLString(@"unlock_method_custom");
        typeStr = [typeStr stringByReplacingOccurrencesOfString:@"+ " withString:@"、"];
        if (self.groupBtn) [self dealwithOpenMethodWithSelectBtn:self.customBtn normalBtn:self.groupBtn];
    }
    self.typeLab.text = typeStr;
}

#pragma mark ------ 选择开门方式处理Button ------
- (void)dealwithOpenMethodWithSelectBtn:(UIButton *)selectBtn normalBtn:(UIButton *)normalBtn {
    selectBtn.selected = YES;
    selectBtn.layer.borderWidth = 0;
    selectBtn.backgroundColor = APP_COLOR;
    
    normalBtn.selected = NO;
    normalBtn.layer.borderWidth = 0.5;
    normalBtn.backgroundColor = [UIColor whiteColor];
}

#pragma mark ------ 查询秘钥 ------
- (void)querySecret {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_selectSecretCase parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.secretDict = responseDict[@"data"];
        }
    } failure:nil];
}

#pragma mark ------ 点击开门方式按钮 ------
- (void)clickActionBtn:(UIButton *)sender {
    if (sender.tag == 0) {
        if (sender.selected == NO) {
            [self dealwithOpenMethodWithSelectBtn:sender normalBtn:self.customBtn];
            [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.layer.borderColor = COLOR_999999.CGColor;
                obj.selected = NO;
            }];
        }
    } else if (sender.tag == 1) {
        if (sender.selected == NO) {
            self.setBtn.hidden = YES;
            [self dealwithOpenMethodWithSelectBtn:sender normalBtn:self.groupBtn];
            [self.btnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.layer.borderColor = APP_COLOR.CGColor;
                obj.selected = YES;
            }];
        }
    } else if (sender.tag == 2) {
        [self dealwithUnlockTypeSelected:sender];
    } else if (sender.tag == 3) {
        if (self.groupBtn.selected && ![self.secretDict[@"isPassword"] boolValue]) {
            [self dealwithNoPasswordWithText:ADLString(@"lock_no_pwd") tag:1];
        } else {
            [self dealwithUnlockTypeSelected:sender];
        }
    } else if (sender.tag == 4) {
        if (self.groupBtn.selected && ![self.secretDict[@"isFingerprint"] boolValue]) {
            [self dealwithNoPasswordWithText:ADLString(@"lock_no_fps") tag:2];
        } else {
            [self dealwithUnlockTypeSelected:sender];
        }
    } else {
        if (self.groupBtn.selected && ![self.secretDict[@"isCard"] boolValue]) {
            [self dealwithNoPasswordWithText:ADLString(@"lock_no_card") tag:3];
        } else {
            [self dealwithUnlockTypeSelected:sender];
        }
    }
}

#pragma mark ------ 处理开门类型选中 ------
- (void)dealwithUnlockTypeSelected:(UIButton *)sender {
    self.setBtn.hidden = YES;
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = APP_COLOR.CGColor;
    } else {
        sender.layer.borderColor = COLOR_999999.CGColor;
    }
}

#pragma mark ------ 处理点击密码、指纹、RF卡时没有设置的情况 ------
- (void)dealwithNoPasswordWithText:(NSString *)text tag:(NSInteger)tag {
    self.setBtn.hidden = NO;
    CGFloat textW = [ADLUtils calculateString:text rectSize:CGSizeMake(MAXFLOAT, 40) fontSize:13].width+32;
    CGRect setF = self.setBtn.frame;
    setF.origin.x = SCREEN_WIDTH-textW;
    setF.size.width = textW;
    self.setBtn.frame = setF;
    self.setBtn.tag = tag;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(text.length-4, 4)];
    [self.setBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
}

#pragma mark ------ 点击设置密码、指纹、RF卡按钮 ------
- (void)clickSetBtn:(UIButton *)sender {
    ADLFAddSecretController *addVC = [[ADLFAddSecretController alloc] init];
    addVC.gatewayCode = self.model.gatewayCode;
    addVC.deviceCode = self.model.deviceCode;
    addVC.deviceType = self.model.deviceType;
    addVC.type = sender.tag;
    addVC.success = ^{
        [self querySecret];
        self.setBtn.hidden = YES;
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    if (self.groupBtn.selected) {
        int num = 0;
        for (UIButton *btn in self.btnArr) {
            if (btn.selected) {
                num++;
            }
        }
        if (num < 2) {
            [ADLToast showMessage:@"当前选中的是组合开门方式，最少要选两项以上"];
            return;
        }
    }
    
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
}

#pragma mark ------ 校验密码 ------
- (void)verifyLoginPassword:(NSString *)text {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils md5Encrypt:text lower:YES] forKey:@"password"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_verifyPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self submitUnlockType:responseDict[@"data"][@"validateCode"]];
        }
    } failure:nil];
}

#pragma mark ------ 提交开门方式设置请求 ------
- (void)submitUnlockType:(NSString *)validateCode {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:@(self.groupBtn.selected) forKey:@"openGroup"];
    [params setValue:validateCode forKey:@"validateCode"];
    UIButton *appBtn = self.btnArr[0];
    UIButton *pwdBtn = self.btnArr[1];
    UIButton *figBtn = self.btnArr[2];
    UIButton *mcaBtn = self.btnArr[3];
    [params setValue:@(appBtn.selected) forKey:@"openApp"];
    [params setValue:@(pwdBtn.selected) forKey:@"openPassword"];
    [params setValue:@(figBtn.selected) forKey:@"openFingerprint"];
    [params setValue:@(mcaBtn.selected) forKey:@"openCard"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_family_setOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(unlockTypeFailed) userInfo:nil repeats:NO];
        }
    } failure:nil];
}

#pragma mark ------ 设置成功的通知 ------
- (void)unlockTypeChanged:(NSNotification *)notification {
    [self.timer invalidate];
    if ([notification.userInfo[@"resultCode"] integerValue] == 10000) {
        [ADLToast showMessage:@"设置成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        [ADLToast showMessage:[notification.userInfo[@"msg"] stringValue]];
    }
}

#pragma mark ------ 设置超时失败 ------
- (void)unlockTypeFailed {
    [self.timer invalidate];
    [ADLToast showMessage:@"设置失败"];
}

@end
