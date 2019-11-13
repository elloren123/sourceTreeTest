//
//  ADLActivityController.m
//  lockboss
//
//  Created by adel on 2019/5/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLActivityController.h"
#import "ADLActGoodsController.h"
#import "ADLActivityCell.h"
#import "ADLBlankView.h"

@interface ADLActivityController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ADLActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"活动频道"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H+12, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = SCREEN_WIDTH/2;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self loadData];
}

#pragma mark ------ UITableView Delegate && DataSources ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLActivityCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"bannerImgUrl"]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    cell.titLab.text = [NSString stringWithFormat:@"  %@",dict[@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLActGoodsController *actVC = [[ADLActGoodsController alloc] init];
    actVC.activityId = self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:actVC animated:YES];
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:@(1) forKey:@"type"];
    [ADLNetWorkManager postWithPath:k_query_activity_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"][@"activityInfo"];
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
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无活动" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
