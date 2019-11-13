//
//  ADLSelectLockerController.m
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectLockerController.h"
#import "ADLLockerDetailController.h"
#import "ADLSelectLockerCell.h"
#import "ADLTitleView.h"
#import "ADLBlankView.h"

@interface ADLSelectLockerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) ADLTitleView *titleView;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ADLSelectLockerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"选择锁匠"];
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"综合排序",@"按距离排序",@"按满意度排序"]];
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.index = index;
        weakSelf.offset = 0;
        [weakSelf getLockerDataWithIndex:index];
    };
    titleView.hidden = YES;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 82;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getLockerDataWithIndex:weakSelf.index];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getLockerDataWithIndex:0];
}

#pragma mark ------ UITableView Delegate && DataSource------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSelectLockerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectLockerCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLSelectLockerCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.nameLab.text = dict[@"name"];
    cell.startView.image = [ADLUtils getStarImageWithCount:[dict[@"avgScore"] integerValue]];
    cell.orderLab.text = [NSString stringWithFormat:@"接单 %@",dict[@"orderNum"]];
    cell.distanceLab.text = [NSString stringWithFormat:@"距您 %@km",dict[@"drivingDistance"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLLockerDetailController *detailVC = [[ADLLockerDetailController alloc] init];
    detailVC.lockerId = self.dataArr[indexPath.row][@"id"];
    detailVC.hideSelBtn = NO;
    detailVC.selectLocker = ^{
        if (self.clickAction) {
            self.clickAction(self.dataArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 获取锁匠信息 ------
- (void)getLockerDataWithIndex:(NSInteger)index {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.address forKey:@"userAddress"];
    if (index == 0) {
        [params setValue:@(1) forKey:@"sortWay"];
    } else if (index == 1) {
        [params setValue:@(0) forKey:@"sortWay"];
    } else {
        [params setValue:@(2) forKey:@"sortWay"];
    }
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_query_locker_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
                self.tableView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
            } else {
                self.titleView.hidden = NO;
                self.tableView.tableFooterView = [UIView new];
            }
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"该地区暂时没有锁匠" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
