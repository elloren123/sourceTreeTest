//
//  ADLFShareDeviceController.m
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFShareDeviceController.h"
#import "ADLFSharedPersonController.h"
#import "ADLFAuthorityDetailController.h"

#import "ADLShareListCell.h"
#import "ADLDeviceModel.h"

@interface ADLFShareDeviceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLFShareDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"共享设备"];
    [self addRightButtonWithImageName:@"nav_add_white" action:@selector(clickAddBtn)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf queryUserList];
    }];
    [self queryUserList];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"share"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLShareListCell" owner:nil options:nil].lastObject;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.descLab.hidden = NO;
        cell.descLab.text = @"管理员";
        cell.indicatorView.hidden = YES;
    } else {
        cell.descLab.hidden = YES;
        cell.indicatorView.hidden = NO;
    }
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[dict[@"url"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    cell.nameLab.text = dict[@"userName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row > 0) {
        ADLFAuthorityDetailController *authorityVC = [[ADLFAuthorityDetailController alloc] init];
        authorityVC.infoDict = self.dataArr[indexPath.row];
        authorityVC.refresh = ^{
            [self queryUserList];
        };
        [self.navigationController pushViewController:authorityVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定要删除该用户吗?" confirmTitle:nil confirmAction:^{
            [self deleteUser:indexPath];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }];
    NSArray *arr = @[deleteAC];
    return arr;
}

#pragma mark ------ 添加共享人 ------
- (void)clickAddBtn {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"共享设备" message:@"请输入共享人手机号或邮箱账号" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"cancle") style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = alertVC.textFields.firstObject;
        if (textfield.text.length > 0) {
            if ([ADLUtils hasEmoji:textfield.text]) {
                [ADLToast showMessage:@"未搜索到此账号"];
            } else if (textfield.text.length < 6 || textfield.text.length > 18) {
                [ADLToast showMessage:@"未搜索到此账号"];
            } else {
                [self searchUser:textfield.text];
            }
        }
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ------ 搜索用户 ------
- (void)searchUser:(NSString *)text {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:text forKey:@"key"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_preciseSearchUser parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [ADLToast hide];
                ADLFSharedPersonController *personVC = [[ADLFSharedPersonController alloc] init];
                personVC.infoDict = resArr.firstObject;
                personVC.success = ^{
                    [self queryUserList];
                };
                [self.navigationController pushViewController:personVC animated:YES];
            } else {
                [ADLToast showMessage:@"未搜索到此账号"];
            }
        }
    } failure:nil];
}

#pragma mark ------ 删除用户 ------
- (void)deleteUser:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dict[@"id"] forKey:@"id"];
    [params setValue:dict[@"userId"] forKey:@"userId"];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_family_relieveShare parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"删除成功"];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:nil];
}

#pragma mark ------ 获取数据 ------
- (void)queryUserList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getDeviceCrew parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    if ([dict[@"jurisdiction"] intValue] == 1) {
                        [self.dataArr insertObject:dict atIndex:0];
                    } else {
                        [self.dataArr addObject:dict];
                    }
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

@end
