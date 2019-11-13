//
//  ADLCouponController.m
//  lockboss
//
//  Created by adel on 2019/5/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCouponController.h"
#import "ADLDrawCouponController.h"
#import "ADLStoreController.h"
#import "ADLCouponCell.h"
#import "ADLTitleView.h"
#import "ADLBlankView.h"

@interface ADLCouponController ()<UITableViewDelegate,UITableViewDataSource,ADLCouponCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLTitleView *titleView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *countArr;
@end

@implementation ADLCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"优惠券"];
    [self addRightButtonWithTitle:@"领券" action:@selector(clickLingQuanBtn)];
    
    self.index = 0;
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"未使用",@"已使用",@"已过期"]];
    titleView.divisionView.hidden = YES;
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.index = index;
        [weakSelf getDataWithIndex:index loading:YES];
    };
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = COLOR_F2F2F2;
    self.footerView = footerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, BOTTOM_H, 0);
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.estimatedRowHeight = 0;
    tableView.rowHeight = 92;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    ADLRefreshHeader *header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getAllCouponCount];
        [weakSelf getDataWithIndex:weakSelf.index loading:NO];
    }];
    header.ignoredScrollViewContentInsetTop = 10;
    tableView.mj_header = header;
    
    [self getAllCouponCount];
    [self getDataWithIndex:self.index loading:YES];
}

#pragma mark ------ 领券 ------
- (void)clickLingQuanBtn {
    ADLDrawCouponController *drawVC = [[ADLDrawCouponController alloc] init];
    drawVC.finishBlock = ^{
        [self getAllCouponCount];
        [self getDataWithIndex:self.index loading:NO];
    };
    [self.navigationController pushViewController:drawVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLCouponCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.section];
    if ([dict[@"status"] intValue] == 0) {
        cell.bgImgView.image = [UIImage imageNamed:@"coupon_bg_ksy"];
    } else {
        cell.bgImgView.image = [UIImage imageNamed:@"coupon_bg_bksy"];
    }
    if ([dict[@"userType"] intValue] == 2) {
        cell.xrzxImgView.hidden = NO;
    } else {
        cell.xrzxImgView.hidden = YES;
    }
    cell.moneyLab.text = [NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]];
    cell.fullMoneyLab.text = [NSString stringWithFormat:@"满%@元可用",dict[@"orderAmount"]];
    if (self.index == 0) {
        cell.lingquBtn.layer.borderColor = COLOR_0083FD.CGColor;
        [cell.lingquBtn setTitle:@"去使用" forState:UIControlStateNormal];
        [cell.lingquBtn setTitleColor:COLOR_0083FD forState:UIControlStateNormal];
    } else if (self.index == 1) {
        cell.lingquBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
        [cell.lingquBtn setTitle:@"已使用" forState:UIControlStateNormal];
        [cell.lingquBtn setTitleColor:COLOR_D3D3D3 forState:UIControlStateNormal];
    } else {
        cell.lingquBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
        [cell.lingquBtn setTitle:@"已过期" forState:UIControlStateNormal];
        [cell.lingquBtn setTitleColor:COLOR_D3D3D3 forState:UIControlStateNormal];
    }
    cell.titLab.text = dict[@"name"];
    NSString *begStr = [dict[@"beginTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endStr = [dict[@"endTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    cell.dateLab.text = [NSString stringWithFormat:@"%@-%@",begStr,endStr];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteCoupon:indexPath];
    }];
    NSArray *arr = @[deleteAC];
    return arr;
}

#pragma mark ------ ADLCouponCellDelegate ------
- (void)didClickLingQuBtn:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"去使用"]) {
        ADLStoreController *storeVC = [[ADLStoreController alloc] init];
        storeVC.push = YES;
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}

#pragma mark ------ 获取所有状态优惠券数量 ------
- (void)getAllCouponCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_coupon_count parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSString *unuseStr = [NSString stringWithFormat:@"未使用(%@)",responseDict[@"data"][@"normal"]];
            NSString *useStr = [NSString stringWithFormat:@"已使用(%@)",responseDict[@"data"][@"used"]];
            NSString *expireStr = [NSString stringWithFormat:@"已过期(%@)",responseDict[@"data"][@"expire"]];
            [self.titleView updateTitleWithArray:@[unuseStr,useStr,expireStr]];
            self.countArr = [[NSMutableArray alloc] initWithObjects:responseDict[@"data"][@"normal"],responseDict[@"data"][@"used"],responseDict[@"data"][@"expire"], nil];
        }
    } failure:nil];
}

#pragma mark ------ 获取数据 ------
- (void)getDataWithIndex:(NSInteger)index loading:(BOOL)loading {
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:[NSString stringWithFormat:@"%ld",index] forKey:@"status"];
    [ADLNetWorkManager postWithPath:k_query_coupon parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
                self.tableView.tableFooterView = [UIView new];
            } else {
                self.tableView.tableFooterView = self.blankView;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ 删除优惠券 ------
- (void)deleteCoupon:(NSIndexPath *)indexPath {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.dataArr[indexPath.section][@"id"] forKey:@"id"];
    [ADLNetWorkManager postWithPath:k_delete_coupon parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
            [ADLToast showMessage:@"删除成功"];
            NSString *titleStr = @"未使用";
            if (self.index == 1) titleStr = @"已使用";
            if (self.index == 2) titleStr = @"已过期";
            NSInteger count = [self.countArr[self.index] integerValue]-1;
            [self.countArr replaceObjectAtIndex:self.index withObject:@(count)];
            [self.titleView updateTitle:[NSString stringWithFormat:@"%@(%ld)",titleStr,count] index:self.index];
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无优惠券" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
