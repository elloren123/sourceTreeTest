//
//  ADLAccountSecController.m
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAccountSecController.h"
#import "ADLSettingViewCell.h"
#import "ADLForgetPwdController.h"
#import "ADLModPhoneMailController.h"

@interface ADLAccountSecController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLAccountSecController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"账户安全"];
    [self.dataArr addObjectsFromArray:@[@"修改登录密码",@"修改手机号",@"修改邮箱"]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ROW_HEIGHT;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
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
    if (indexPath.row == 0) {
        ADLForgetPwdController *pwdVC = [[ADLForgetPwdController alloc] init];
        pwdVC.titleName = @"修改登录密码";
        [self.navigationController pushViewController:pwdVC animated:YES];
    } else if (indexPath.row == 1) {
        ADLModPhoneMailController *phoneVC = [[ADLModPhoneMailController alloc] init];
        phoneVC.phone = YES;
        [self.navigationController pushViewController:phoneVC animated:YES];
    } else {
        ADLModPhoneMailController *mailVC = [[ADLModPhoneMailController alloc] init];
        mailVC.phone = NO;
        [self.navigationController pushViewController:mailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
