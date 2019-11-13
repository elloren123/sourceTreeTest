//
//  ADLInsuranceController.m
//  lockboss
//
//  Created by adel on 2019/7/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLInsuranceController.h"
#import "ADLInsuranceCell.h"

@interface ADLInsuranceController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ADLInsuranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"保险单信息"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 158;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.insuranceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLInsuranceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLInsuranceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.insuranceArr[indexPath.row];
    cell.serialLab.text = [NSString stringWithFormat:@"投保订单编号：%@",dict[@"goodsSerialNumber"]];
    cell.companyLab.text = [NSString stringWithFormat:@"投保公司：%@",dict[@"insuranceCompany"]];
    cell.moneyLab.text = [NSString stringWithFormat:@"保费金额：%@元",dict[@"insuranceMoney"]];
    cell.insuranceLab.text = [NSString stringWithFormat:@"保单号：%@",dict[@"insuranceNumber"]];
    return cell;
}

@end
