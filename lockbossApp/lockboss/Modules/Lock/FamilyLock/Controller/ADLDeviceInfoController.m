//
//  ADLDeviceInfoController.m
//  lockboss
//
//  Created by Adel on 2019/9/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLDeviceInfoController.h"
#import "ADLDeviceInfoCell.h"
#import "ADLDeviceModel.h"

@interface ADLDeviceInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoArr;
@end

@implementation ADLDeviceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:ADLString(@"device_info")];
    if(self.isHotelDevice){
        [self.dataArr addObjectsFromArray:@[ADLString(@"device_name"),ADLString(@"serial_number"),ADLString(@"model_number")]];
    }else{
        [self.dataArr addObjectsFromArray:@[ADLString(@"device_name"),ADLString(@"serial_number"),ADLString(@"model_number"),ADLString(@"firmware_version"),ADLString(@"hardware_version")]];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getDeviceData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLDeviceInfoCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titLab.text = self.dataArr[indexPath.row];
    cell.infoLab.text = self.infoArr[indexPath.row];
    return cell;
}

#pragma mark ------ 获取设备信息 ------
- (void)getDeviceData {
    if (self.isHotelDevice) {//酒店的不需要请求
        self.infoArr = [NSMutableArray arrayWithArray:@[self.model.deviceName,self.model.deviceCode,self.model.deviceType]];
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        if (self.model.id.length > 0) {
            [params setValue:self.model.id forKey:@"deviceId"];
            [params setValue:self.model.mac forKey:@"deviceMac"];
        } else {
            [params setValue:self.model.deviceId forKey:@"deviceId"];
            [params setValue:self.model.deviceMac forKey:@"deviceMac"];
        }
        [params setValue:self.model.deviceType forKey:@"deviceType"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_family_getDeviceInfo parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSDictionary *dict = responseDict[@"data"];
                self.infoArr = [[NSMutableArray alloc] initWithArray:@[[dict[@"name"] stringValue],[dict[@"code"] stringValue],[dict[@"model"] stringValue],[dict[@"firmwareVersion"] stringValue],[dict[@"hardwareVersion"] stringValue]]];
                [self.tableView reloadData];
            }
        } failure:nil];
    }
   
}

@end
