//
//  ADLOrderTypeController.m
//  lockboss
//
//  Created by Adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLOrderTypeController.h"
#import "ADLStoreOrderController.h"
#import "ADLSettingViewCell.h"
#import "ADLPayOrdersViewController.h"
#import "ADLHotelOrderListController.h"
@interface ADLOrderTypeController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ADLOrderTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"我的订单"];
    
    [self.dataArr addObjectsFromArray:@[@"商城订单",@"酒店订单",@"餐饮订单"]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
    }
    cell.firstLab.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        ADLStoreOrderController *storeVC = [[ADLStoreOrderController alloc] init];
        [self.navigationController pushViewController:storeVC animated:YES];
        
    } else if (indexPath.row == 1) {
        ADLHotelOrderListController *VC =[[ADLHotelOrderListController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        ADLPayOrdersViewController *vc = [[ADLPayOrdersViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
