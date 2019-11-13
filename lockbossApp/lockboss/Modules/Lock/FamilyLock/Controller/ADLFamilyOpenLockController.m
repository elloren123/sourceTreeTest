//
//  ADLFamilyOpenLockController.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFamilyOpenLockController.h"

#import "ADLDeviceModel.h"

#import "ADLFamilyOpenLockCell.h"

#import "ADLLockRecordModel.h"

#import "ADLBasButton.h"

#import "ADLGlobalDefine.h"

#import "ADLBlankView.h"

@interface ADLFamilyOpenLockController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ADLBasButton *dateBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString * year;

@property (nonatomic, copy) NSString *month;

@property (nonatomic ,strong) ADLBlankView *blackView;//无数据视图

@end

static NSString *FamilyOpenLockCell = @"FamilyOpenLockCell";

@implementation ADLFamilyOpenLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addRedNavigationView:@"开锁记录"];
    //重写了一个导航,所以self.navigationItem,没意义了;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dateBtn];
    [self.view addSubview:self.tableView];
    
    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws openLockRecordData:@""];
        [ws.dataArray  removeAllObjects];
    } ];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (ws.dataArray > 0) {
            ADLLockRecordModel *model = ws.dataArray.lastObject;
            [ws openLockRecordData:model.id];
        }else {
            [ws openLockRecordData:@""];
        }
    }];

    [self openLockRecordData:@""];
}


#pragma mark ------ 数据源请求 ------
-(void)openLockRecordData:(NSString *)recordId {
    if (!self.model) {
        self.tableView.tableFooterView = self.blackView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([ADLToast isShowLoading]) {
                [ADLToast hide];
            }
        });
        return;
    }
    
    if([self.model.deviceType isEqualToString:@"51"] ||[self.model.deviceType isEqualToString:@"41"] ){
        [self getStorageBoxGasValveDataSourceWithID:recordId];
    }else {
        [self lockDataSourceWithID:recordId];
    }
    
}

//锁的记录
-(void)lockDataSourceWithID:(NSString *)recordId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    url = ADEL_family_openLockRecord;
    params[@"deviceId"] = self.model.deviceId;// 设备id
    params[@"deviceMac"] = self.model.deviceMac;// 设备id
    params[@"deviceCode"] = self.model.deviceCode;// 设备id
    params[@"deviceType"] = self.model.deviceType;// 设备id
    NSString *string = self.dateBtn.titleLabel.text;
    NSArray *array = [string componentsSeparatedByString:@"-"];
    params[@"recordId"] =recordId;// 记录id
    params[@"year"] =array[0];
    params[@"month"] =array[1];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [self networkWith:url mes:params];
}

//储物箱,燃气阀的记录
-(void)getStorageBoxGasValveDataSourceWithID:(NSString *)recordId{
    NSString *url = nil;
    if ([self.model.deviceType isEqualToString:@"51"]) {
        url = ADEL_family_openLockStorageBox;
    }else if ([self.model.deviceType isEqualToString:@"41"]){
        url = ADEL_family_openLockGasValve;
    }else {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = self.model.deviceId;
    params[@"deviceCode"] = self.model.deviceCode;
    params[@"id"] =recordId;// 记录id ,这样定义字段真的好吗????
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [self networkWith:url mes:params];
}

-(void)networkWith:(NSString *)url mes:(NSDictionary *)params {
     WS(ws);
    [ADLNetWorkManager postWithPath:url parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        NSDictionary *dict;
        if ([responseDict[@"code"] integerValue] == 10000) {
            @synchronized (self) {
                [ws decreaseData];
                dict =responseDict[@"data"];
                NSMutableArray *arr = [ADLLockRecordModel mj_objectArrayWithKeyValuesArray:dict[@"records"]];
                [ws.dataArray addObjectsFromArray:arr];
            }
        }
        
        if (ws.dataArray.count == 0) {
            ws.tableView.tableFooterView = self.blackView;
        }else {
            if (ws.dataArray >= dict[@"count"]) {
                [ws.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            ws.tableView.tableFooterView = [UIView new];
        }
        [ws.tableView reloadData];
        
    } failure:^(NSError *error) {
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        [ws.dataArray removeAllObjects];
        [ws.tableView reloadData];
        ws.tableView.tableFooterView = self.blackView;
    }];
}


#pragma mark ------ 推送的数量设置 ------
//推送消息数量设置为空
-(void)decreaseData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"num"] = @(-1);
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLNetWorkManager postWithPath:ADEL_decrease parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            //远程推送消息数量归0
//            [ADLEFdaluts setObject:@"0" forKey:ADEL_message];
            
            //TODO  这里没有一个消息数量的Key  ?? 无效这个
//            [ADLUtils saveValue:@"0" forKey:ADEL_message];
            [UIApplication  sharedApplication].applicationIconBadgeNumber = 0;
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark ------ 日期的选则 ------
-(void)dateTarget:(UIButton *)dateBtn {
//    XFDaterView *dater=[[XFDaterView alloc]initWithFrame:CGRectMake(0, 0, 100, 0)];
//    dater.dateViewType = XFDateViewTypedateMonth;
//    dater.delegate=self;
//    [dater showInView:self.view animated:YES];
//    self.dater = dater;
}

#pragma mark ------ tableview Delegate ------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ADLFamilyOpenLockCell *cell = [ADLFamilyOpenLockCell cellWithTableView:tableView];
    ADLLockRecordModel *model =self.dataArray[indexPath.row];
    model.deviceName = self.model.deviceName;
    cell.model =model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

#pragma mark ------ 懒加载 ------

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return  _dataArray;
}
-(ADLBasButton *)dateBtn {
    if (!_dateBtn) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM"];
        NSString *start=[dateformatter stringFromDate:currentDate];
        _dateBtn = [ADLBasButton butonWithTyp:UIButtonTypeCustom frame:CGRectMake(SCREEN_WIDTH - 130,0, 90, 35) image:nil handler:nil title:start];
        [_dateBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];//   icon_triangle
        [_dateBtn addTarget:self action:@selector(dateTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _dateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dateBtn;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H-BOTTOM_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    }
    return  _tableView ;
}


#pragma mark ------ 空数据视图 ------
-(ADLBlankView *)blackView {
    if (!_blackView) {
        _blackView = [ADLBlankView blankViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_H) imageName:@"data_blank" prompt:@"您还没有任何开锁记录!" backgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
        _blackView.actionBtn.hidden = NO;
        [_blackView.actionBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        __weak typeof(self)weakSelf = self;
        _blackView.clickActionBtn = ^{
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            [weakSelf openLockRecordData:@""];
        };
        
    }
    return _blackView;
}


@end
