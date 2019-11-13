//
//  ADLTalkCityView.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLTalkCityView.h"
#import "ADLApiDefine.h"
#import "ADLNetWorkManager.h"
#import "ADLGlobalDefine.h"
#import "ADLRefreshFooter.h"
#import "ADLSingleTextCell.h"
#import "ADLBlankView.h"
#import "ADLUtils.h"

@interface ADLTalkCityView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation ADLTalkCityView

- (instancetype)init {
    if (self = [super init]) {
        [self initializationView];
    }
    return self;
}

- (void)initializationView {
    self.offset = 0;
    self.dataArr = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    tableView.mj_footer.hidden = YES;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.leftMargin = 12;
    }
    cell.titLab.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(2) forKey:@"status"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(20) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_league_city parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    [self.dataArr addObject:dict[@"areaName"]];
                }
            }
            if (resArr.count < 20) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
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
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无洽谈中的城市" backgroundColor:nil];
        _blankView.topMargin = 60;
    }
    return _blankView;
}

@end
