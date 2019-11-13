//
//  ADLCoverCityView.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCoverCityView.h"
#import "ADLNetWorkManager.h"
#import "ADLRefreshFooter.h"
#import "ADLCoverCityCell.h"
#import "ADLGlobalDefine.h"
#import "ADLApiDefine.h"
#import "ADLBlankView.h"
#import "ADLUtils.h"

@interface ADLCoverCityView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation ADLCoverCityView

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
    tableView.rowHeight = 90;
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
    ADLCoverCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cover"];
    if (cell == nil) {
        cell = [[ADLCoverCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cover" cellH:90];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titLab.text = [NSString stringWithFormat:@"代理地区：%@",dict[@"areaName"]];
    cell.nameLab.text = [NSString stringWithFormat:@"备案人：%@",dict[@"recordMenName"]];
    cell.satisfyImgView.image = [ADLUtils getStarImageWithCount:[dict[@"evaluationScore"] integerValue]];
    return cell;
}

- (void)getData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(0) forKey:@"status"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(20) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_league_city parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
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
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无已覆盖的城市" backgroundColor:nil];
        _blankView.topMargin = 60;
    }
    return _blankView;
}

@end
