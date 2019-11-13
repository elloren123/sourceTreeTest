//
//  ADLReviewController.m
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLReviewController.h"
#import "ADLBlankView.h"
#import "ADLReviewCell.h"
#import "ADLImagePreView.h"

@interface ADLReviewController ()<UITableViewDelegate,UITableViewDataSource,ADLReviewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"申请审核"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(8, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 66;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    ADLRefreshHeader *header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf loadData];
    }];
    header.ignoredScrollViewContentInsetTop = 8;
    tableView.mj_header = header;
    
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self loadData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLReviewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"applyHeadShot"]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    cell.nameLab.text = dict[@"applyUserNickName"];
    NSInteger state = [dict[@"status"] integerValue];
    
    if ([dict[@"userId"] isEqualToString:[ADLUserModel sharedModel].userId]) {
        cell.descLab.text = [NSString stringWithFormat:@"您申请加入【%@】群组",dict[@"groupName"]];
        cell.agreeBtn.hidden = YES;
        cell.ignoreBtn.hidden = YES;
        cell.stateLab.hidden = NO;
        if (state == 1) {
            cell.stateLab.text = @"等待审核";
        } else if (state == 2) {
            cell.stateLab.text = @"已同意";
        } else {
            cell.stateLab.text = @"已拒绝";
        }
    } else {
        cell.descLab.text = [NSString stringWithFormat:@"申请加入您创建的【%@】群组",dict[@"groupName"]];
        if (state == 1) {
            cell.agreeBtn.hidden = NO;
            cell.ignoreBtn.hidden = NO;
            cell.stateLab.hidden = YES;
        } else if (state == 2) {
            cell.agreeBtn.hidden = YES;
            cell.ignoreBtn.hidden = YES;
            cell.stateLab.hidden = NO;
            cell.stateLab.text = @"已同意";
        } else {
            cell.agreeBtn.hidden = YES;
            cell.ignoreBtn.hidden = YES;
            cell.stateLab.hidden = NO;
            cell.stateLab.text = @"已忽略";
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"userId"] isEqualToString:[ADLUserModel sharedModel].userId] || [dict[@"status"] integerValue] != 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *deleteStr = @"删除";
    if ([self.dataArr[indexPath.row][@"status"] integerValue] == 1) {
        deleteStr = @"删除申请";
    }
    
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:deleteStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteApplyWithIndexPath:indexPath];
    }];
    NSArray *arr = @[deleteAC];
    return arr;
}

#pragma mark ------ 删除申请 ------
- (void)deleteApplyWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"applyId"];
    [ADLNetWorkManager postWithPath:k_circle_review_delete parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"删除成功"];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (self.dataArr.count == 0) {
                self.offset = 0;
                [self loadData];
            }
        }
    } failure:nil];
}

#pragma mark ------ 点击头像 ------
- (void)didClickImageView:(UIImageView *)imageView {
    ADLReviewCell *cell = (ADLReviewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *headimgUrl = @"";
    if (dict[@"applyHeadShot"]) headimgUrl = dict[@"applyHeadShot"];
    [ADLImagePreView showWithImageViews:@[imageView] urlArray:@[headimgUrl] currentIndex:0];
}

#pragma mark ------ 同意 ------
- (void)didClickAgreeBtn:(UIButton *)sender {
    ADLReviewCell *cell = (ADLReviewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self joinGroupWithType:2 index:indexPath.row];
}

#pragma mark ------ 忽略 ------
- (void)didClickIgnoreBtn:(UIButton *)sender {
    ADLReviewCell *cell = (ADLReviewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self joinGroupWithType:3 index:indexPath.row];
}

#pragma mark ------ 进群审核 ------
- (void)joinGroupWithType:(NSInteger)type index:(NSInteger)index {
    NSMutableDictionary *dict = self.dataArr[index];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(type) forKey:@"type"];
    [params setValue:dict[@"id"] forKey:@"applyId"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_circle_review_join parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            [dict setValue:@(type) forKey:@"status"];
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [ADLNetWorkManager postWithPath:k_circle_review_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"][@"rows"];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无审核申请" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
