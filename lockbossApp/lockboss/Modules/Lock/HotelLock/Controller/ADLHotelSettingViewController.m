//
//  ADLHotelSettingViewController.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
/*
 
 给入住用户设置锁的权限, 开门方式  和  门锁的常开常闭
 
 */

#import "ADLHotelSettingViewController.h"

#import "ADLDeviceInfoController.h"

#import "ADLNetworkInfoController.h"

#import "ADLUnlockPatternController.h"

#import "ADLFamilyUpgradeController.h"

#import "ADLTransPermissionController.h"

#import "ADLSettingViewCell.h"

#import "ADLMsgSettingCell.h"

#import "ADLDeviceModel.h"

#import "ADLOpenLockDeviceTypeController.h"

#import "ADLLockModeController.h"

#import "ADLlockSetsController.h"
#import "ADLHomeServiceModel.h"
@interface ADLHotelSettingViewController ()<UITableViewDelegate,UITableViewDataSource,ADLMsgSettingCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL open;

@end

@implementation ADLHotelSettingViewController

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
    [self.dataArr addObjectsFromArray:@[ADLString(@"unlock_method_setting"),ADLString(@"device_info"),ADLString(@"passage_locked")]];
    [self getGroupOpenType];
}
//查询开门方式
- (void)getGroupOpenType {
    self.open = [self.model.status boolValue];
    //    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //    [params setValue:self.model.deviceId forKey:@"deviceId"];
    //    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    //    [params setValue:self.model.deviceType forKey:@"deviceType"];
    //    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    //    [ADLNetWorkManager postWithPath:ADEL_family_getGroupOpenType parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
    //        if ([responseDict[@"code"] integerValue] == 10000) {
    //            if ([responseDict[@"data"][@"openStatus"] intValue] == 1) {
    //                self.open = YES;
    //            } else {
    //                self.open = NO;
    //            }
    //            [self.tableView reloadData];
    //        }
    //    } failure:nil];
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
            NSString *model_name = self.model.name;
            if (model_name && model_name.length>0) {
                settingCell.secondLab.text = model_name;
            }else{
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
    if (indexPath.row == 0) {//开门方式管理
         NSArray *array  =@[@"110",@"22",@"24",@"19"];
       if ([array containsObject:self.model.deviceType]) {
            ADLLockModeController * vc = [[ADLLockModeController alloc]init];
            NSMutableDictionary *dict = self.model.mj_keyValues;
            vc.model =  [ADLHomeServiceModel mj_objectWithKeyValues:dict];
            [self.navigationController pushViewController:vc animated:YES];
        }else   if ([self.model.deviceType isEqualToString:@"1111"]){
            
        ADLOpenLockDeviceTypeController *lockTypeVC = [[ADLOpenLockDeviceTypeController alloc] init];
        lockTypeVC.model = self.model;
        [self.navigationController pushViewController:lockTypeVC animated:YES];
            
        }else {
            
            ADLlockSetsController *VC= [[ADLlockSetsController alloc]init];
            NSMutableDictionary *dict = self.model.mj_keyValues;
            VC.model =  [ADLHomeServiceModel mj_objectWithKeyValues:dict];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    
    } else {
        NSString *title = self.dataArr[indexPath.row];
        if ([title isEqualToString:ADLString(@"device_info")]) {
            ADLDeviceInfoController *infoVC = [[ADLDeviceInfoController alloc] init];
            infoVC.model = self.model;
            infoVC.isHotelDevice = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
        }
        else if ([title hasPrefix:ADLString(@"passage_locked")]) {
            ADLUnlockPatternController *patternVC = [[ADLUnlockPatternController alloc] init];
            patternVC.model = self.model;
            [self.navigationController pushViewController:patternVC animated:YES];
            
        }
    }
}

#pragma mark ------ 常开常闭 delegate------
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






@end
