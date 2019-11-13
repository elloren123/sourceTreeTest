//
//  ADLEvaluateRecorderView.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEvaluateRecorderView.h"
#import "ADLRecorderEvaListCell.h"
#import "ADLRefreshHeader.h"
#import "ADLRefreshFooter.h"
#import "ADLBlankView.h"

#import "ADLNetWorkManager.h"
#import "ADLGlobalDefine.h"
#import "ADLUserModel.h"
#import "ADLApiDefine.h"

@interface ADLEvaluateRecorderView ()<UITableViewDelegate,UITableViewDataSource,ADLRecorderEvaListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger offset;

@end

@implementation ADLEvaluateRecorderView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initView {
    self.offset = 0;
    self.dataArr = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 159;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf loadData];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self addSubview:tableView];
    self.tableView = tableView;
    [self loadData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLRecorderEvaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecorderEvaListCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLRecorderEvaListCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.nameLab.text = dict[@"recorder"];
    cell.dateLab.text = dict[@"serviceTime"];
    if ([dict[@"isEvaluate"] boolValue]) {
        cell.right.constant = 12;
    } else {
        cell.right.constant = 104;
    }
    return cell;
}

#pragma mark ------ 备案人详情 ------
- (void)didClickRecorderDetailBtn:(UIButton *)sender {
    ADLRecorderEvaListCell *cell = (ADLRecorderEvaListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (self.clickDetailBtn) {
        self.clickDetailBtn(self.dataArr[indexPath.row]);
    }
}

#pragma mark ------ 备案人评价 ------
- (void)didClickRecorderEvaluateBtn:(UIButton *)sender {
    ADLRecorderEvaListCell *cell = (ADLRecorderEvaListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    if (self.clickEvaluateBtn) {
        self.clickEvaluateBtn(dict);
    }
}

#pragma mark ------ 刷新数据 ------
- (void)updateData {
    [self.tableView reloadData];
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(self.offset) forKey:@"offeSet"];
    [params setValue:@(20) forKey:@"pageSize"];
    [ADLNetWorkManager postWithPath:k_recorder_evaluate_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    [dict setValue:[NSString stringWithFormat:@"备案人：%@",dict[@"recordManName"]] forKey:@"recorder"];
                    NSString *serviceTime = dict[@"serviceTime"];
                    if (serviceTime.length > 2) {
                        serviceTime = [serviceTime substringToIndex:serviceTime.length-2];
                        [dict setValue:[NSString stringWithFormat:@"服务时间：%@",serviceTime] forKey:@"serviceTime"];
                    }
                }
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
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT) imageName:nil prompt:@"暂无备案人评价" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
