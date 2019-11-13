//
//  ADLFamilyDevicesController.m
//  ADEL-APP
//
//  Created by bailun91 on 2018/12/19.
//

#import "ADLFamilyDevicesController.h"
#import "ADLAddDevicePromptController.h"
#import "ADLFamilySettingController.h"
#import "ADLDeviceListCell.h"
#import "ADLDeviceModel.h"
#import "ADLLockModel.h"
#import "ADLBlankView.h"

#import <NSObject+MJKeyValue.h>

@interface ADLFamilyDevicesController ()<UITableViewDelegate,UITableViewDataSource,ADLDeviceListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLFamilyDevicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:ADLString(@"device")];
    [self addRightButtonWithImageName:@"nav_add_white" action:@selector(clickAddDevice)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = 85;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf queryDeviceList];
    }];
    
    [self queryDeviceList];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ADLDeviceModel *model = self.dataArr[section];
    return model.devices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    headerView.backgroundColor = COLOR_F2F2F2;
    headerView.tag = section+2019;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 49, 49)];
    imgView.image = [UIImage imageNamed:@"lock_gateway"];
    [headerView addSubview:imgView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(71, 18, SCREEN_WIDTH-90, 20)];
    nameLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    nameLab.textColor = COLOR_333333;
    [headerView addSubview:nameLab];
    
    UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(71, 45, 100, 20)];
    stateLab.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:stateLab];
    
    ADLDeviceModel *model = self.dataArr[section];
    nameLab.text = [NSString stringWithFormat:@"%@ (%@)",model.name,ADLString(@"gateway")];
    if ([model.isFirstConnection isEqualToString:@"1"]) {
        stateLab.text = ADLString(@"online");
        stateLab.textColor = COLOR_0AAA00;
    } else {
        stateLab.text = ADLString(@"offline");
        stateLab.textColor = COLOR_999999;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickheaderView:)];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"devices"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLDeviceListCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    ADLDeviceModel *deviceModel = self.dataArr[indexPath.section];
    ADLLockModel *model = deviceModel.devices[indexPath.row];
    cell.nameLab.text = model.name;
    cell.imgView.image = [ADLUtils lockImageWithType:model.deviceType];
    cell.modelLab.text = [self dealwithModel:model.deviceType];
    if ([model.isBing isEqualToString:@"1"]) {
        [cell.bindBtn setTitle:ADLString(@"unbind") forState:UIControlStateNormal];
        cell.bindBtn.backgroundColor = COLOR_CCCCCC;
    } else {
        [cell.bindBtn setTitle:ADLString(@"bind") forState:UIControlStateNormal];
        cell.bindBtn.backgroundColor = APP_COLOR;
    }
    if ([model.isFirstConnection isEqualToString:@"1"]) {
        cell.stateLab.textColor = COLOR_0AAA00;
        cell.stateLab.text = ADLString(@"online");
    } else {
        cell.stateLab.textColor = COLOR_999999;
        cell.stateLab.text = ADLString(@"offline");
    }
    return cell;
}

#pragma mark ------ 处理型号 ------
- (NSString *)dealwithModel:(NSString *)type {
    if ([type isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%@：L0",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"2"]) {
        return [NSString stringWithFormat:@"%@：H10",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"3"]) {
        return [NSString stringWithFormat:@"%@：HOH77",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"4"]) {
        return [NSString stringWithFormat:@"%@：USB12",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"5"]) {
        return [NSString stringWithFormat:@"%@：BOX",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"6"]) {
        return [NSString stringWithFormat:@"%@：US3-6",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"7"]) {
        return [NSString stringWithFormat:@"%@：LS99",ADLString(@"lock_model")];
    } else {
        return [NSString stringWithFormat:@"%@：%@",ADLString(@"lock_model"),ADLString(@"unknown")];
    }
}

#pragma mark ------ 添加设备 ------
- (void)clickAddDevice {
    ADLAddDevicePromptController *addVC = [[ADLAddDevicePromptController alloc] init];
    addVC.titName = ADLString(@"add_gateway");
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark ------ 点击Header ------
- (void)clickheaderView:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag-2019;
    if (section >= 0 && section < self.dataArr.count) {
        ADLDeviceModel *model = self.dataArr[section];
        ADLFamilySettingController *settingVC = [[ADLFamilySettingController alloc] init];
        settingVC.model = model;
        settingVC.type = 1;
        settingVC.familyNameChanged = ^(NSString *name) {
            [self queryDeviceList];
        };
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

#pragma mark ------ 绑定设备 ------
- (void)didClickBindingBtn:(UIButton *)sender {
    ADLDeviceListCell *cell = (ADLDeviceListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([sender.titleLabel.text isEqualToString:ADLString(@"bind")]) {
        ADLDeviceModel *deviceModel = self.dataArr[indexPath.section];
        ADLLockModel *model = deviceModel.devices[indexPath.row];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:model.name forKey:@"name"];
        [params setValue:model.id forKey:@"deviceId"];
        [params setValue:model.mac forKey:@"deviceMac"];
        [params setValue:model.deviceType forKey:@"deviceType"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:ADEL_family_addLock parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:ADLString(@"bind_success")];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
                [self queryDeviceList];
            }
        } failure:nil];
        
    } else {
        [ADLAlertView showWithTitle:ADLString(@"unbind_device") message:ADLString(@"unbind_device_pp") confirmTitle:nil confirmAction:^{
            [self unbindDeviceWithIndexPath:indexPath];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 解绑设备 ------
- (void)unbindDeviceWithIndexPath:(NSIndexPath *)indexPath {
    ADLDeviceModel *deviceModel = self.dataArr[indexPath.section];
    ADLLockModel *model = deviceModel.devices[indexPath.row];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:deviceModel.deviceId forKey:@"deviceId"];
    [params setValue:model.deviceType forKey:@"deviceType"];
    [params setValue:model.code forKey:@"deviceCode"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_family_relieveShareDevice parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:ADLString(@"unbind_success")];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
            [self queryDeviceList];
        }
    } failure:nil];
}

#pragma mark ------ 获取设备列表 ------
- (void)queryDeviceList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getGatewayDevice parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.dataArr = [ADLDeviceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:ADLString(@"no_device") backgroundColor:nil];
    }
    return _blankView;
}

@end
