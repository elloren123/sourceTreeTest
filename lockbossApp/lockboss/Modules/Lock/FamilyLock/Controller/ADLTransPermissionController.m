//
//  ADLTransPermissionController.m
//  lockboss
//
//  Created by Adel on 2019/9/17.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLTransPermissionController.h"
#import "ADLPersonalDetailController.h"
#import "ADLShareListCell.h"
#import "ADLDeviceModel.h"

@interface ADLTransPermissionController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLTransPermissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"转让权限"];
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
    cell.indicatorView.hidden = YES;
    if (indexPath.row == 0) {
        cell.descLab.hidden = NO;
        cell.descLab.text = @"管理员";
    } else {
        cell.descLab.hidden = YES;
    }
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[dict[@"url"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    cell.nameLab.text = dict[@"remark"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row > 0) {
        [self searchUserAccount:self.dataArr[indexPath.row]];
    }
}

#pragma mark ------ 添加共享人 ------
- (void)clickAddBtn {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"转让设备" message:@"请输入共享人手机号或邮箱号" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"cancle") style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertVC.textFields.firstObject;
        NSString *account = textField.text;
        if (account.length > 0) {
            if (account.length > 18) {
                account = [account substringToIndex:18];
            }
            if ([ADLUtils hasEmoji:account]) {
                [ADLToast showMessage:@"未搜索到此账号"];
            } else {
                [self searchUserAccount:@{@"loginAccount":account}];
            }
        }
    }]];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ------ 获取数据 ------
- (void)queryUserList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.id forKey:@"deviceId"];
    [params setValue:self.model.code forKey:@"deviceCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getGatewayCrewUser parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
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

#pragma mark ------ 搜索用户 ------
- (void)searchUserAccount:(NSDictionary *)dict {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dict[@"loginAccount"] forKey:@"key"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_preciseSearchUser parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [ADLToast hide];
                NSMutableDictionary *userDict = resArr.firstObject;
                [userDict setValue:self.model.id forKey:@"deviceId"];
                if ([dict[@"remark"] stringValue].length > 0) {
                    [userDict setValue:dict[@"remark"] forKey:@"remark"];
                }
                ADLPersonalDetailController *detailVC = [[ADLPersonalDetailController alloc] init];
                detailVC.userInfo = userDict;
                [self.navigationController pushViewController:detailVC animated:YES];
            } else {
                [ADLToast showMessage:@"未搜索到此账号"];
            }
        }
    } failure:nil];
}

@end
