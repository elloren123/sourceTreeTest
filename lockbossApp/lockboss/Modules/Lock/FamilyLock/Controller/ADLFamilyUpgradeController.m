//
//  ADLFamilyUpgradeController.m
//  lockboss
//
//  Created by Adel on 2019/9/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFamilyUpgradeController.h"
#import "ADLProgressView.h"
#import "ADLDeviceModel.h"

@interface ADLFamilyUpgradeController ()
@property (nonatomic, strong) UILabel *currentLab;
@property (nonatomic, strong) UILabel *latestLab;
@property (nonatomic, strong) UILabel *progressLab;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) ADLProgressView *progressView;
@end

@implementation ADLFamilyUpgradeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:ADLString(@"firmware_update")];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-136)/2, NAVIGATION_H+54, 136, 136)];
    imgView.image = [UIImage imageNamed:@"family_upgrade"];
    [self.view addSubview:imgView];
    
    UILabel *currentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_H+237, SCREEN_WIDTH-40, 30)];
    currentLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    currentLab.textAlignment = NSTextAlignmentCenter;
    currentLab.textColor = COLOR_333333;
    [self.view addSubview:currentLab];
    self.currentLab = currentLab;
    
    UILabel *latestLab = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_H+270, SCREEN_WIDTH-40, 30)];
    latestLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    latestLab.textAlignment = NSTextAlignmentCenter;
    latestLab.textColor = COLOR_333333;
    [self.view addSubview:latestLab];
    self.latestLab = latestLab;
    
    CGFloat cenY = (SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT-NAVIGATION_H-324)/2;
    UILabel *progressLab = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_H+cenY+260, SCREEN_WIDTH-40, 40)];
    progressLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    progressLab.textAlignment = NSTextAlignmentCenter;
    progressLab.textColor = COLOR_333333;
    [self.view addSubview:progressLab];
    self.progressLab = progressLab;
    
    ADLProgressView *progressView = [[ADLProgressView alloc] initWithFrame:CGRectMake(50, NAVIGATION_H+cenY+300, SCREEN_WIDTH-100, 6) type:ADLProgressViewTypeHorizontal];
    progressView.layer.cornerRadius = 3;
    progressView.progressColor = APP_COLOR;
    progressView.trackColor = COLOR_D3D3D3;
    progressView.hidden = YES;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(20, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT-24, SCREEN_WIDTH-40, VIEW_HEIGHT);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    confirmBtn.backgroundColor = APP_COLOR;
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.hidden = YES;
    [self.view addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatingProgressNotification:) name:@"ADELfamillockUpgradeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateResultNotification:) name:@"ADELfamillockUpgradeStateNotification" object:nil];
    
    [self queryUpdating];
}

#pragma mark ------ 查询设备是否正在升级 ------
- (void)queryUpdating {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    if (self.model.id.length > 0) {
        [params setValue:self.model.code forKey:@"deviceCode"];
    } else {
        [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_upgradeFirmwareVersion parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self queryDeviceVersion:[responseDict[@"data"][@"upgrade"] boolValue]];
        }
    } failure:nil];
}

#pragma mark ------ 获取设备版本信息 ------
- (void)queryDeviceVersion:(BOOL)updating {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    if (self.model.id.length > 0) {
        [params setValue:self.model.id forKey:@"deviceId"];
        [params setValue:self.model.mac forKey:@"deviceMac"];
    } else {
        [params setValue:self.model.deviceId forKey:@"deviceId"];
        [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_checkFirmwareVersion parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.confirmBtn.hidden = NO;
            NSDictionary *dict = responseDict[@"data"];
            self.currentLab.text = [NSString stringWithFormat:@"当前版本号：%@",dict[@"firmwareVersion"]];
            if (updating) {
                [self confirmBtnEnable:NO title:@"升级中..."];
                self.latestLab.text = [NSString stringWithFormat:@"最新版本号：%@",dict[@"newFirmwareVersion"]];
            } else {
                if ([dict[@"firmwareVersion"] intValue] == [dict[@"newFirmwareVersion"] intValue]) {
                    [self confirmBtnEnable:NO title:@"已是最新版本"];
                    self.latestLab.text = @"";
                } else {
                    [self confirmBtnEnable:YES title:@"升级"];
                    self.latestLab.text = [NSString stringWithFormat:@"最新版本号：%@",dict[@"newFirmwareVersion"]];
                }
            }
        }
    } failure:nil];
}

#pragma mark ------ 升级进度通知 ------
- (void)updatingProgressNotification:(NSNotification *)notification {
    if (self.progressView.hidden) {
        self.progressView.hidden = NO;
    }
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"resultCode"] intValue] == 10000) {
        NSInteger complete = [dict[@"num"] integerValue];
        NSInteger total = [dict[@"sumNum"] integerValue];
        CGFloat progress = complete*1.0/total;
        self.progressLab.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
        [self.progressView setProgress:progress animated:YES];
    }
}

#pragma mark ------ 升级结果通知 ------
- (void)updateResultNotification:(NSNotification *)notification {
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    self.progressLab.text = @"";
    if ([notification.userInfo[@"resultCode"] intValue] == 10000) {
        [ADLToast showMessage:@"升级完成"];
        [self queryDeviceVersion:NO];
    } else {
        [self confirmBtnEnable:YES title:@"升级"];
        [ADLToast showMessage:@"升级失败"];
        [self stopUpdating];
    }
}

#pragma mark ------ 停止升级 ------
- (void)stopUpdating {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    if (self.model.id.length > 0) {
        [params setValue:self.model.code forKey:@"deviceCode"];
    } else {
        [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_stopUpgrade parameters:params autoToast:NO success:nil failure:nil];
}

#pragma mark ------ 点击确定按钮 ------
- (void)clickConfirmBtn {
    NSString *path = ADEL_family_upgrade;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    if (self.model.id.length > 0) {
        [params setValue:self.model.code forKey:@"deviceCode"];
        if (self.type == 1) {
            path = ADEL_family_gatewayUpgrade;
        } else {
            [params setValue:self.model.mac forKey:@"deviceMac"];
            [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
            [params setValue:self.model.deviceType forKey:@"type"];
        }
    } else {
        [params setValue:self.model.deviceMac forKey:@"deviceMac"];
        [params setValue:self.model.deviceCode forKey:@"deviceCode"];
        [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
        [params setValue:self.model.deviceType forKey:@"type"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [self confirmBtnEnable:NO title:nil];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.confirmBtn setTitle:@"升级中..." forState:UIControlStateNormal];
        } else {
            [self confirmBtnEnable:YES title:nil];
        }
    } failure:^(NSError *error) {
        [self confirmBtnEnable:YES title:nil];
    }];
}

#pragma mark ------ 设置确认按钮状态 ------
- (void)confirmBtnEnable:(BOOL)enable title:(NSString *)title {
    self.confirmBtn.enabled = enable;
    if (enable) {
        self.confirmBtn.alpha = 1;
    } else {
        self.confirmBtn.alpha = 0.6;
    }
    if (title) {
        [self.confirmBtn setTitle:title forState:UIControlStateNormal];
    }
}

@end
