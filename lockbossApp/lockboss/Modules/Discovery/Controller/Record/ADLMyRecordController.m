//
//  ADLMyRecordController.m
//  lockboss
//
//  Created by adel on 2019/6/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMyRecordController.h"
#import "ADLRecordDataController.h"

#import "ADLMyRecordCell.h"
#import "ADLTitleView.h"
#import "ADLBlankView.h"

@interface ADLMyRecordController ()<UITableViewDelegate,UITableViewDataSource,ADLMyRecordCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView * blankView;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ADLMyRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"我的备案"];
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"全部",@"待审核",@"已驳回",@"已完成",@"已取消"]];
    titleView.clickTitle = ^(NSInteger index) {
        switch (index) {
            case 0:
                weakSelf.index = 0;
                weakSelf.blankView.promptLab.text = @"暂无项目备案";
                break;
            case 1:
                weakSelf.index = 2;
                weakSelf.blankView.promptLab.text = @"暂无待审核的备案";
                break;
            case 2:
                weakSelf.index = 5;
                weakSelf.blankView.promptLab.text = @"暂无已驳回的备案";
                break;
            case 3:
                weakSelf.index = 4;
                weakSelf.blankView.promptLab.text = @"暂无已完成的备案";
                break;
            case 4:
                weakSelf.index = 3;
                weakSelf.blankView.promptLab.text = @"暂无已取消的备案";
                break;
        }
        weakSelf.offset = 0;
        [weakSelf getDataWithIndex:weakSelf.index];
    };
    [self.view addSubview:titleView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 90;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithIndex:weakSelf.index];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getDataWithIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLMyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRecordCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLMyRecordCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.nameLab.text = dict[@"projectName"];
    cell.statusLab.text = dict[@"statusStr"];
    NSInteger status = [dict[@"status"] integerValue];
    if (status == 2) {
        cell.actionBtn.hidden = NO;
        [cell.actionBtn setTitle:@"取消" forState:UIControlStateNormal];
    } else if (status == 5) {
        [cell.actionBtn setTitle:@"修改" forState:UIControlStateNormal];
        cell.actionBtn.hidden = NO;
    } else {
        cell.actionBtn.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    ADLRecordDataController *recordVC = [[ADLRecordDataController alloc] init];
    recordVC.projectId = dict[@"id"];
    if ([dict[@"status"] integerValue] == 2) {
        recordVC.type = ADLRecordTypeReview;
    } else {
        recordVC.type = ADLRecordTypeLook;
    }
    recordVC.modifySuccess = ^{
        self.offset = 0;
        [self getDataWithIndex:self.index];
    };
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark ------ 点击Cell按钮 ------
- (void)didClickActionBtn:(UIButton *)sender {
    ADLMyRecordCell *cell = (ADLMyRecordCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"status"] integerValue] == 2) {
        [self cancleProjectRecord:dict[@"id"] indexPath:indexPath];
    } else {
        ADLRecordDataController *recordVC = [[ADLRecordDataController alloc] init];
        recordVC.projectId = dict[@"id"];
        recordVC.type = ADLRecordTypeModify;
        recordVC.modifySuccess = ^{
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.offset = self.dataArr.count;
            if (self.offset == 0) {
                [self getDataWithIndex:self.index];
            }
        };
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

#pragma mark ------ 取消项目备案 ------
- (void)cancleProjectRecord:(NSString *)projectId indexPath:(NSIndexPath *)indexPath {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:projectId forKey:@"id"];
    [ADLNetWorkManager postWithPath:k_cancle_project_record parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"取消成功"];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.offset = self.dataArr.count;
        }
    } failure:nil];
}

#pragma mark ------ 获取项目备案信息 ------
- (void)getDataWithIndex:(NSInteger)index {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    if (index > 0) {
        [params setValue:@(index) forKey:@"status"];
    }
    
    [ADLNetWorkManager postWithPath:k_record_my_project parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    switch ([dict[@"status"] integerValue]) {
                        case 1:
                            [dict setValue:@"待完成" forKey:@"statusStr"];
                            break;
                        case 2:
                            [dict setValue:@"待审核" forKey:@"statusStr"];
                            break;
                        case 3:
                            [dict setValue:@"已取消" forKey:@"statusStr"];
                            break;
                        case 4:
                            [dict setValue:@"已完成" forKey:@"statusStr"];
                            break;
                        case 5:
                            [dict setValue:@"已驳回" forKey:@"statusStr"];
                            break;
                        default:
                            break;
                    }
                    [self.dataArr addObject:dict];
                }
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
            [self.tableView reloadData];
            if (self.offset == 0) {
                [self.tableView layoutIfNeeded];
                [self.tableView setContentOffset:CGPointZero animated:YES];
            }
            self.offset = self.dataArr.count;
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无项目备案" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
