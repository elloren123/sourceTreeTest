//
//  ADLFUnlockWayDetailController.m
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFSecretDetailController.h"
#import "ADLFModifyTimeView.h"
#import "ADLDeviceModel.h"

@interface ADLFSecretDetailController ()
@property (nonatomic, strong) NSString *deletePath;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *endLab;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *end;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ADLFSecretDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.secretType == 1) {
        [self addRedNavigationView:@"密码详情"];
        self.deletePath =ADEL_family_deleteSecretPassword;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELLockPasswordMQNotification" object:nil];
    } else if (self.secretType == 2) {
        [self addRedNavigationView:@"卡详情"];
        self.deletePath = ADEL_family_deleteSecretCard;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELfamilLocdDeleteCardNotification" object:nil];
    } else {
        [self addRedNavigationView:@"指纹详情"];
        self.deletePath =ADEL_family_deleteSecretFingerprint;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELfamilFingerprintNotification" object:nil];
    }
    
    UILabel *remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+30, SCREEN_WIDTH-24, 20)];
    remarkLab.text = [NSString stringWithFormat:@"备注名称：%@",self.infoDict[@"secretName"]];
    remarkLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    remarkLab.textColor = COLOR_333333;
    [self.view addSubview:remarkLab];
    
    UILabel *limitLab = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+70, SCREEN_WIDTH-24, 20)];
    if (self.dataType == 1) {
        limitLab.text = [NSString stringWithFormat:@"有效期：%@",ADLString(@"permanent")];
    } else {
        limitLab.text = [NSString stringWithFormat:@"有效期：%@",[ADLUtils getDateFromTimestamp:[self.infoDict[@"endDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm"]];
    }
    limitLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    limitLab.textColor = COLOR_333333;
    [self.view addSubview:limitLab];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+115, SCREEN_WIDTH-24, 60)];
    redView.backgroundColor = [UIColor colorWithRed:1 green:109/255.0 blue:107/255.0 alpha:1];
    redView.layer.cornerRadius = 5;
    [self.view addSubview:redView];
    
    UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, (SCREEN_WIDTH-49)/2-12-12, 60)];
    startLab.text = [ADLUtils getDateFromTimestamp:[self.infoDict[@"startDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm"];
    startLab.textAlignment = NSTextAlignmentCenter;
    startLab.font = [UIFont systemFontOfSize:13];
    startLab.textColor = [UIColor whiteColor];
    [redView addSubview:startLab];
    self.startLab = startLab;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-49)/2, 0, 25, 60)];
    imgView.image = [UIImage imageNamed:@"arrow_right"];
    imgView.contentMode = UIViewContentModeCenter;
    [redView addSubview:imgView];
    
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-49)/2+25+12, 0, (SCREEN_WIDTH-49)/2-12-12, 60)];
    if (self.dataType == 1) {
        endLab.text = ADLString(@"permanent");
    } else {
        endLab.text = [ADLUtils getDateFromTimestamp:[self.infoDict[@"endDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm"];
    }
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.font = [UIFont systemFontOfSize:13];
    endLab.textColor = [UIColor whiteColor];
    [redView addSubview:endLab];
    self.endLab = endLab;
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    modifyBtn.frame = CGRectMake(12, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT*2-44, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [modifyBtn setTitle:@"修改时间" forState:UIControlStateNormal];
    modifyBtn.backgroundColor = APP_COLOR;
    modifyBtn.layer.cornerRadius = CORNER_RADIUS;
    [modifyBtn addTarget:self action:@selector(clickModifyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(12, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT-24, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.backgroundColor = APP_COLOR;
    deleteBtn.layer.cornerRadius = CORNER_RADIUS;
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeNotification:) name:@"ADELModifyPasswordTimeNotification" object:nil];
}

#pragma mark ------ 修改时间 ------
- (void)clickModifyBtn {
    [ADLFModifyTimeView showWithTitle:@"修改时间" finish:^(NSString *dateStr) {
        [self modifyTime:dateStr];
    }];
}

#pragma mark ------ 修改时间请求 ------
- (void)modifyTime:(NSString *)timeStr {
    NSString *format = @"yyyy-MM-dd HH:mm";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSString *currentStr = [formatter stringFromDate:[NSDate date]];
    NSString *currentTime = [ADLUtils timestampWithDateStr:currentStr format:format];
    NSString *endTime = timeStr;
    self.start = currentStr;
    if ([endTime isEqualToString:@"-1"]) {
        self.end = ADLString(@"permanent");
    } else {
        self.end = timeStr;
        endTime = [ADLUtils timestampWithDateStr:timeStr format:format];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:self.infoDict[@"secretId"] forKey:@"secretId"];
    [params setValue:@(self.secretType) forKey:@"secretType"];
    [params setValue:currentTime forKey:@"startDatetime"];
    [params setValue:endTime forKey:@"endDatetime"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_family_secretDelay parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(operateFailed) userInfo:@"time" repeats:NO];
        }
    } failure:nil];
}

#pragma mark ------ 删除 ------
- (void)clickDeleteBtn {
    [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定要删除这条数据吗?" confirmTitle:nil confirmAction:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.model.deviceCode forKey:@"deviceCode"];
        [params setValue:self.model.deviceType forKey:@"deviceType"];
        [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
        [params setValue:self.infoDict[@"secretId"] forKey:@"secretId"];
        [params setValue:@(self.secretType) forKey:@"secretType"];
        [params setValue:@(self.dataType) forKey:@"dataType"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:self.deletePath parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(operateFailed) userInfo:@"delete" repeats:NO];
            }
        } failure:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ 修改时间通知 ------
- (void)changeTimeNotification:(NSNotification *)notification {
    [self.timer invalidate];
    if ([notification.userInfo[@"resultCode"] intValue] == 10000) {
        [ADLToast showMessage:@"修改成功"];
        self.startLab.text = self.start;
        self.endLab.text = self.end;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    } else {
        [ADLToast showMessage:[notification.userInfo[@"msg"] stringValue]];
    }
}

#pragma mark ------ 删除秘钥通知 ------
- (void)deleteSecretNotification:(NSNotification *)notification {
    [self.timer invalidate];
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"resultCode"] intValue] == 10000) {
        if ([dict[@"type"] intValue] == 1) {
            [ADLToast showMessage:@"删除成功"];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [ADLToast showMessage:@"删除失败"];
        }
    } else {
        [ADLToast showMessage:[notification.userInfo[@"msg"] stringValue]];
    }
}

#pragma mark ------ 操作失败 ------
- (void)operateFailed {
    if ([self.timer.userInfo isEqualToString:@"time"]) {
        [ADLToast showMessage:@"修改失败"];
    } else {
        [ADLToast showMessage:@"删除失败"];
    }
    [self.timer invalidate];
}

@end
