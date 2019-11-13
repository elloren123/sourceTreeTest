//
//  ADLFaceManagerController.m
//  lockboss
//
//  Created by Adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFaceManagerController.h"
#import "ADLAddFaceController.h"
#import "ADLSingleTextCell.h"
#import "ADLBlankView.h"

@interface ADLFaceManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLFaceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"人脸管理"];
    [self addRightButtonWithImageName:@"nav_add" action:@selector(clickAddFace)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf queryFaceList];
    }];
    [self queryFaceList];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftMargin = 12;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titLab.text = [NSString stringWithFormat:@"人脸名称：%@",dict[@"name"]];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteFace:indexPath];
    }];
    return @[deleteAC];
}

#pragma mark ------ 删除人脸 ------
- (void)deleteFace:(NSIndexPath *)indexPath {
    [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定要删除这条人脸数据吗?" confirmTitle:nil confirmAction:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"secretId"];
        [params setValue:@(2) forKey:@"dataType"];
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        [ADLNetWorkManager postWithPath:ADEL_face_delete parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"删除成功"];
                [self.dataArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (self.dataArr.count == 0) {
                    self.tableView.tableFooterView = self.blankView;
                }
            }
        } failure:nil];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ 添加人脸 ------
- (void)clickAddFace {
    ADLCameraStatus status = [ADLUtils getCameraStatus];
    if (status == ADLCameraStatusAllow) {
        ADLAddFaceController *addVC = [[ADLAddFaceController alloc] init];
        addVC.success = ^{
            [self queryFaceList];
        };
        [self.navigationController pushViewController:addVC animated:YES];
    } else if (status == ADLCameraStatusUnavailable) {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:ADLString(@"photo_camera") confirmTitle:nil confirmAction:nil cancleTitle:nil cancleAction:nil showCancle:NO];
    } else {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:ADLString(@"camera_permission") confirmTitle:nil confirmAction:^{
            [[UIApplication sharedApplication] openURL:APP_SETTING_URL];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 查询人脸列表 ------
- (void)queryFaceList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_L3_userface_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
                self.tableView.tableFooterView = [UIView new];
            } else {
                self.tableView.tableFooterView = self.blankView;
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
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无人脸" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
