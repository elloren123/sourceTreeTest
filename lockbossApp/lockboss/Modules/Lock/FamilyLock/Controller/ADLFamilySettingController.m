//
//  ADLFamilySettingController.m
//  lockboss
//
//  Created by Adel on 2019/9/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFamilySettingController.h"

#import "ADLDeviceInfoController.h"

#import "ADLNetworkInfoController.h"

#import "ADLUnlockPatternController.h"

#import "ADLFamilyUpgradeController.h"

#import "ADLTransPermissionController.h"

#import "ADLSettingViewCell.h"

#import "ADLMsgSettingCell.h"

#import "ADLDeviceModel.h"

@interface ADLFamilySettingController ()<UITableViewDelegate,UITableViewDataSource,ADLMsgSettingCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL open;
@end

@implementation ADLFamilySettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:ADLString(@"general_setting")];
    [self initializationData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark ------ 初始化数据 ------
- (void)initializationData {
    if (self.type == 1) {
        [self.dataArr addObjectsFromArray:@[ADLString(@"device_name"),ADLString(@"device_info"),ADLString(@"network_info"),ADLString(@"firmware_update"),ADLString(@"transfer_permission"),ADLString(@"delete_device")]];
    } else {
        if ([self.model.jurisdiction isEqualToString:@"1"]) {
            [self getGroupOpenType];
            [self.dataArr addObjectsFromArray:@[ADLString(@"device_name"),ADLString(@"device_info"),ADLString(@"passage_locked"),ADLString(@"unlock_method_setting"),ADLString(@"restore_factory"),ADLString(@"firmware_update"),ADLString(@"delete_device")]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passageLockedChanged:) name:@"ADELLockHomeMedallionNotification" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreSettingNotification:) name:@"ADELfamilRestoreSettingsNotification" object:nil];
        } else {
            [self.dataArr addObjectsFromArray:@[ADLString(@"device_name"),ADLString(@"device_info"),ADLString(@"unlock_method"),ADLString(@"delete_device")]];
        }
    }
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:ADLString(@"passage_locked")]) {
        ADLMsgSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch"];
        if (cell == nil) {
            cell = [[ADLMsgSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switch"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        cell.titleLab.text = title;
        cell.swc.on = self.open;
        return cell;
    } else {
        ADLSettingViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
        if (settingCell == nil) {
            settingCell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
        }
        settingCell.firstLab.text = title;
        if ([title isEqualToString:ADLString(@"device_name")]) {
            if (self.type == 1 || self.model.name.length > 0) {
                settingCell.secondLab.text = self.model.name;
            } else {
                settingCell.secondLab.text = self.model.deviceName;
            }
        } else {
            settingCell.secondLab.text = @"";
        }
        return settingCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ADLString(@"device_name") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"cancle") style:UIAlertActionStyleCancel handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alertVC.textFields.firstObject;
            NSString *name = textField.text;
            if (name.length > 0) {
                if (name.length > 18) {
                    name = [name substringToIndex:18];
                }
                if ([ADLUtils hasEmoji:name]) {
                    [ADLToast showMessage:@"暂时不支持表情或特殊符号"];
                } else {
                    [self modifyDeviceName:name];
                }
            }
        }]];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = ADLString(@"device_name_ph");
            if (self.type == 1 || self.model.name.length > 0) {
                textField.text = self.model.name;
            } else {
                textField.text = self.model.deviceName;
            }
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    } else {
        NSString *title = self.dataArr[indexPath.row];
        if ([title isEqualToString:ADLString(@"device_info")]) {
            ADLDeviceInfoController *infoVC = [[ADLDeviceInfoController alloc] init];
            infoVC.model = self.model;
            [self.navigationController pushViewController:infoVC animated:YES];
            
        } else if ([title isEqualToString:ADLString(@"network_info")]) {
            ADLNetworkInfoController *networkVC = [[ADLNetworkInfoController alloc] init];
            networkVC.deviceId = self.model.id;
            networkVC.deviceMac = self.model.mac;
            networkVC.deviceType = self.model.deviceType;
            [self.navigationController pushViewController:networkVC animated:YES];
            
        } else if ([title hasPrefix:ADLString(@"unlock_method")]) {
            ADLUnlockPatternController *patternVC = [[ADLUnlockPatternController alloc] init];
            patternVC.model = self.model;
            [self.navigationController pushViewController:patternVC animated:YES];
            
        } else if ([title isEqualToString:ADLString(@"firmware_update")]) {
            ADLFamilyUpgradeController *upgradeVC = [[ADLFamilyUpgradeController alloc] init];
            upgradeVC.model = self.model;
            upgradeVC.type = self.type;
            [self.navigationController pushViewController:upgradeVC animated:YES];
            
        } else if ([title isEqualToString:ADLString(@"transfer_permission")]) {
            ADLTransPermissionController *transVC = [[ADLTransPermissionController alloc] init];
            transVC.model = self.model;
            [self.navigationController pushViewController:transVC animated:YES];
            
        } else if ([title isEqualToString:ADLString(@"delete_device")]) {
            [ADLAlertView showWithTitle:ADLString(@"delete_device") message:ADLString(@"delete_device_pp") confirmTitle:nil confirmAction:^{
                [self deleteFamilyDevice];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
            
        } else if ([title isEqualToString:ADLString(@"restore_factory")]) {
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
            
        } else {
            
        }
    }
}

#pragma mark ------ 修改设备名称 ------
- (void)modifyDeviceName:(NSString *)name {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.type == 1 || self.model.name.length > 0) {
        [params setValue:self.model.id forKey:@"deviceId"];
    } else {
        [params setValue:self.model.deviceId forKey:@"deviceId"];
    }
    [params setValue:name forKey:@"deviceName"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_updateDeviceName parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.model.name = name;
            self.model.deviceName = name;
            [self.tableView reloadData];
            if (self.familyNameChanged) {
                self.familyNameChanged(name);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GATEWAY_NAME_CHANGE_NOTICATION" object:nil userInfo:nil];
                
            }
        }
    } failure:nil];
}

#pragma mark ------ 常开常闭 ------
- (void)switchValueChanged:(UISwitch *)sender cell:(ADLMsgSettingCell *)cell {
    self.open = sender.on;
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:@(sender.on) forKey:@"isUsing"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_keepStatus parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] != 10000) {
            sender.on = !sender.on;
            self.open = sender.on;
        }
    } failure:^(NSError *error) {
        sender.on = !sender.on;
        self.open = sender.on;
    }];
}

#pragma mark ------ 常开常闭通知 ------
- (void)passageLockedChanged:(NSNotification *)notification {
    if ([notification.userInfo[@"resultCode"] integerValue] == 10000) {
        [ADLToast showMessage:@"设置成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
    } else {
        ADLMsgSettingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.swc.on = !cell.swc.on;
        self.open = cell.swc.on;
    }
}

#pragma mark ------ 删除设备 ------
- (void)deleteFamilyDevice {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSString *path = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.type == 1) {
        [params setValue:self.model.code forKey:@"deviceCode"];
        path = ADEL_family_deleteGateway;
    } else {
        if ([self.model.jurisdiction isEqualToString:@"1"]) {
            path = ADEL_family_deleteDevice;
            [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
            [params setValue:@"2" forKey:@"operationType"];
        } else {
            path = ADEL_family_ordinaryRelieveShareDevice;
            [params setValue:self.model.deviceId forKey:@"deviceId"];
        }
        [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    }
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([self.model.jurisdiction isEqualToString:@"1"]) {
                [self resetPushBadge];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
            [ADLToast showMessage:ADLString(@"delete_device_success")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ 推送消息清零 ------
- (void)resetPushBadge {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(-1) forKey:@"num"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_decrease parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    } failure:nil];
}

#pragma mark ------ 校验密码 ------
- (void)verifyLoginPassword:(NSString *)pwd {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils md5Encrypt:pwd lower:YES] forKey:@"password"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_verifyPasswrod parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self restoreFactorySetting:responseDict[@"data"][@"validateCode"]];
        }
    } failure:nil];
}

#pragma mark ------ 恢复出厂设置 ------
- (void)restoreFactorySetting:(NSString *)verifyCode {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:verifyCode forKey:@"validateCode"];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    if (self.model.id.length > 0) {
        [params setValue:self.model.code forKey:@"deviceCode"];
    } else {
        [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_factoryReset parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(restoreFailed) userInfo:nil repeats:NO];
        }
    } failure:nil];
}

#pragma mark ------ 恢复出厂设置通知 ------
- (void)restoreSettingNotification:(NSNotification *)notification {
    if ([notification.userInfo[@"resultCode"] integerValue] == 10000) {
        [self.timer invalidate];
        [ADLToast showMessage:ADLString(@"restore_factory_success")];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
    } else {
        [self.timer invalidate];
        [ADLToast showMessage:[notification.userInfo[@"msg"] stringValue]];
    }
}

#pragma mark ------ 恢复出厂失败 ------
- (void)restoreFailed {
    [self.timer invalidate];
    [ADLToast showMessage:ADLString(@"restore_factory_failed")];
}

#pragma mark ------ 查询开门方式 ------
- (void)getGroupOpenType {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getGroupOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([responseDict[@"data"][@"openStatus"] intValue] == 1) {
                self.open = YES;
            } else {
                self.open = NO;
            }
            [self.tableView reloadData];
        }
    } failure:nil];
}

@end
