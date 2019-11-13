//
//  ADLFUnlockManageController.m
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFSecretManageController.h"
#import "ADLFAddSecretController.h"
#import "ADLFSecretDetailController.h"
#import "ADLUnlockMethodCell.h"
#import "ADLDeviceModel.h"
#import "ADLBlankView.h"

@interface ADLFSecretManageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) NSMutableArray *permanentArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger secretType;//密钥类别:密钥类型:1:密码 2:卡 3:指纹,4:指纹卡  5:人脸
@property (nonatomic, assign) NSInteger unlockType;
@property (nonatomic, strong) NSString *deletePath;
@property (nonatomic, strong) NSString *promptStr;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ADLFSecretManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 0) {
        self.unlockType = 3;
        self.secretType = 2;
        self.promptStr = @"暂无RF卡";
        [self addRedNavigationView:@"IC卡管理"];
        self.path = ADEL_family_searchSecretCard;
        self.deletePath = ADEL_family_deleteSecretCard;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELfamilLocdDeleteCardNotification" object:nil];
    } else if (self.type == 1) {
        self.unlockType = 2;
        self.secretType = 3;
        self.promptStr = @"暂无指纹";
        [self addRedNavigationView:@"指纹管理"];
        self.path = ADEL_family_searchSecretFingerprint;
        self.deletePath = ADEL_family_deleteSecretFingerprint;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELfamilFingerprintNotification" object:nil];
    } else if (self.type == 2){
        self.unlockType = 1;
        self.secretType = 1;
        self.promptStr = @"暂无密码";
        [self addRedNavigationView:@"密码管理"];
        self.path = ADEL_family_searchSecretPassword;
        self.deletePath = ADEL_family_deleteSecretPassword;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELLockPasswordMQNotification" object:nil];
    } else{//增加一个人脸 3
        //TODO
        self.unlockType = 4;
        self.secretType = 5;
        self.promptStr = @"暂无人脸";
        [self addRedNavigationView:@"人脸管理"];
        self.path = ADEL_family_searchSecretPassword;
        self.deletePath = ADEL_family_deleteSecretPassword;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSecretNotification:) name:@"ADELLockPasswordMQNotification" object:nil];
    }
    [self addRightButtonWithImageName:@"nav_add_white" action:@selector(clickAddBtn)];
    self.permanentArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[ADLString(@"permanent"),ADLString(@"temp")]];
    [segControl addTarget:self action:@selector(segControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} forState:UIControlStateNormal];
    [segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} forState:UIControlStateSelected];
    segControl.frame = CGRectMake(60, NAVIGATION_H+20, SCREEN_WIDTH-120, 40);
    segControl.tintColor = COLOR_E0212A;
    segControl.selectedSegmentIndex = 0;
    [self.view addSubview:segControl];
    self.segControl = segControl;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+80, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-80)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    [self queryData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segControl.selectedSegmentIndex == 0) {
        return self.permanentArr.count;
    } else {
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLUnlockMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLUnlockMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = nil;
    if (self.segControl.selectedSegmentIndex == 0) {
        dict = self.permanentArr[indexPath.row];
        cell.endLab.text = ADLString(@"permanent");
    } else {
        dict = self.dataArr[indexPath.row];
        cell.endLab.text = [ADLUtils getDateFromTimestamp:[dict[@"endDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm"];
    }
    cell.remarkLab.text = dict[@"secretName"];
    cell.startLab.text = [ADLUtils getDateFromTimestamp:[dict[@"startDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ADLFSecretDetailController *detailVC = [[ADLFSecretDetailController alloc] init];
    detailVC.model = self.model;
    detailVC.secretType = self.secretType;
    detailVC.dataType = self.segControl.selectedSegmentIndex+1;
    if (self.segControl.selectedSegmentIndex == 0) {
        detailVC.infoDict = self.permanentArr[indexPath.row];
    } else {
        detailVC.infoDict = self.dataArr[indexPath.row];
    }
    detailVC.refreshBlock = ^{
        [self queryData];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"确定要删除这条数据吗?" confirmTitle:nil confirmAction:^{
            [self deleteData:indexPath];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }];
    NSArray *arr = @[deleteAC];
    return arr;
}

#pragma mark ------ 删除 ------
- (void)deleteData:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:self.model.gatewayCode forKey:@"gatewayCode"];
    [params setValue:@(self.secretType) forKey:@"secretType"];
    if (self.segControl.selectedSegmentIndex == 0) {
        [params setValue:@(1) forKey:@"dataType"];
        [params setValue:self.permanentArr[indexPath.row][@"secretId"] forKey:@"secretId"];
    } else {
        [params setValue:@(2) forKey:@"dataType"];
        [params setValue:self.dataArr[indexPath.row][@"secretId"] forKey:@"secretId"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:self.deletePath parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(deleteFailed) userInfo:nil repeats:NO];
        }
    } failure:nil];
}

#pragma mark ------ 删除秘钥通知 ------
- (void)deleteSecretNotification:(NSNotification *)notification {
    [self.timer invalidate];
    NSDictionary *dict = notification.userInfo;
    if ([dict[@"resultCode"] intValue] == 10000) {
        if ([dict[@"type"] intValue] == 1) {
            [ADLToast showMessage:@"删除成功"];
            if (self.segControl.selectedSegmentIndex == 0) {
                [self.permanentArr removeObjectAtIndex:self.indexPath.row];
            } else {
                [self.dataArr removeObjectAtIndex:self.indexPath.row];
            }
            [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self settingBlankView];
        } else {
            [ADLToast showMessage:@"删除失败"];
        }
    } else {
        [ADLToast showMessage:[notification.userInfo[@"msg"] stringValue]];
    }
}

#pragma mark ------ 删除超时 ------
- (void)deleteFailed {
    [ADLToast showMessage:@"删除失败"];
    [self.timer invalidate];
}

#pragma mark ------ 添加 ------
- (void)clickAddBtn {
    ADLFAddSecretController *methodVC = [[ADLFAddSecretController alloc] init];
    methodVC.gatewayCode = self.model.gatewayCode;
    methodVC.deviceCode = self.model.deviceCode;
    methodVC.deviceType = self.model.deviceType;
    methodVC.type = self.unlockType;
    methodVC.success = ^{
        [self queryData];
    };
    [self.navigationController pushViewController:methodVC animated:YES];
}

#pragma mark ------ 切换 ------
- (void)segControlValueChanged:(UISegmentedControl *)segControl {
    [self settingBlankView];
    [self.tableView reloadData];
}

#pragma mark ------ 获取数据 ------
- (void)queryData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:self.path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.permanentArr removeAllObjects];
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    if ([dict[@"endDatetime"] intValue] == -1000) {
                        [self.permanentArr addObject:dict];
                    } else {
                        [self.dataArr addObject:dict];
                    }
                }
            }
            [self settingBlankView];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ 设置BlankView ------
- (void)settingBlankView {
    if (self.segControl.selectedSegmentIndex == 0) {
        if (self.permanentArr.count == 0) {
            self.tableView.tableFooterView = self.blankView;
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
    } else {
        if (self.dataArr.count == 0) {
            self.tableView.tableFooterView = self.blankView;
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
    }
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:self.promptStr backgroundColor:nil];
    }
    return _blankView;
}

@end
