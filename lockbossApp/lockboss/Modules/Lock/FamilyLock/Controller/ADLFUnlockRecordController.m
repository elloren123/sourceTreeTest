//
//  ADLFUnlockRecordController.m
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFUnlockRecordController.h"
#import "ADLFUnlockRecordCell.h"
#import "ADLSelectMonthView.h"
#import "ADLDeviceModel.h"
#import "ADLBlankView.h"

@interface ADLFUnlockRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation ADLFUnlockRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:ADLString(@"unlock_records")];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    self.dateBtn = [self addRightButtonWithTitle:dateStr action:@selector(clickSelectMonthBtn)];
    [self.dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(5, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 108;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    ADLRefreshHeader *header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.lastId = nil;
        [weakSelf queryUnlockData];
    }];
    header.ignoredScrollViewContentInsetTop = 5;
    tableView.mj_header = header;
    
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf queryUnlockData];
    }];
    tableView.mj_footer.hidden = YES;
    
    [self queryUnlockData];
    [self resetPushBadge];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLFUnlockRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unlockRecord"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLFUnlockRecordCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell dealwithData:self.dataArr[indexPath.row]];
    cell.deviceLab.text = self.model.deviceName;
    return cell;
}

#pragma mark ------ 选择月份 ------
- (void)clickSelectMonthBtn {
    [ADLSelectMonthView showWithTitle:nil period:NO selectTime:self.dateBtn.titleLabel.text finish:^(NSString *dateStr) {
        [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
        self.lastId = nil;
        [self queryUnlockData];
    }];
}

#pragma mark ------ 查询数据 ------
- (void)queryUnlockData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.model.deviceId forKey:@"deviceId"];
    [params setValue:self.model.deviceMac forKey:@"deviceMac"];
    [params setValue:self.model.deviceCode forKey:@"deviceCode"];
    [params setValue:self.model.deviceType forKey:@"deviceType"];
    [params setValue:self.lastId forKey:@"recordId"];
    [params setValue:[self.dateBtn.titleLabel.text substringToIndex:4] forKey:@"year"];
    [params setValue:[self.dateBtn.titleLabel.text substringFromIndex:5] forKey:@"month"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_openLockRecord parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.lastId == nil) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"][@"records"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
            if (self.dataArr.count == 0) {
                self.lastId = nil;
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.lastId = self.dataArr.lastObject[@"id"];
                self.tableView.tableFooterView = [UIView new];
            }
            if (self.dataArr.count >= [responseDict[@"data"][@"count"] integerValue]) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 推送消息清零 ------
- (void)resetPushBadge {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(-1) forKey:@"num"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_decrease parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无记录" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
