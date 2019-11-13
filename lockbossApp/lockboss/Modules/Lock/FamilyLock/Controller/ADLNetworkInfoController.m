//
//  ADLNetworkInfoController.m
//  lockboss
//
//  Created by Adel on 2019/9/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLNetworkInfoController.h"
#import "ADLAddFamilyDeviceController.h"
#import "ADLDeviceInfoCell.h"

@interface ADLNetworkInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoArr;
@end

@implementation ADLNetworkInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:ADLString(@"network_info")];
    [self.dataArr addObjectsFromArray:@[ADLString(@"wifi_name"),ADLString(@"ip_address"),ADLString(@"mac_address")]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-VIEW_HEIGHT-60)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    editBtn.frame = CGRectMake(20, SCREEN_HEIGHT-BOTTOM_H-VIEW_HEIGHT-30, SCREEN_WIDTH-40, VIEW_HEIGHT);
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    editBtn.backgroundColor = APP_COLOR;
    editBtn.layer.cornerRadius = CORNER_RADIUS;
    [editBtn setTitle:ADLString(@"change_network") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEditNetwork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    [self getNetworkData];
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

#pragma mark ------ 更换网络 ------
- (void)clickEditNetwork {
    ADLAddFamilyDeviceController *deviceVC = [[ADLAddFamilyDeviceController alloc] init];
    deviceVC.titName = ADLString(@"change_network");
    deviceVC.deviceMac = self.deviceMac;
    [self.navigationController pushViewController:deviceVC animated:YES];
}

#pragma mark ------ 获取网络信息 ------
- (void)getNetworkData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.deviceId forKey:@"deviceId"];
    [params setValue:self.deviceMac forKey:@"deviceMac"];
    [params setValue:self.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getInfoByGatewayId parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            self.infoArr = [[NSMutableArray alloc] initWithObjects:[dict[@"name"] stringValue],[dict[@"ip"] stringValue],[dict[@"mac"] stringValue], nil];
            [self.tableView reloadData];
        }
    } failure:nil];
}

@end
