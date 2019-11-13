//
//  ADLDrawCouponController.m
//  lockboss
//
//  Created by adel on 2019/5/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDrawCouponController.h"
#import "ADLCouponCell.h"
#import "ADLBlankView.h"

@interface ADLDrawCouponController ()<UITableViewDelegate,UITableViewDataSource,ADLCouponCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation ADLDrawCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"领券中心"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = COLOR_F2F2F2;
    self.footerView = footerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, BOTTOM_H, 0);
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.rowHeight = 92;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self getAllCoupon];
    
    __weak typeof(self)weakSelf = self;
    ADLRefreshHeader *header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getAllCoupon];
    }];
    header.ignoredScrollViewContentInsetTop = 10;
    tableView.mj_header = header;
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
    if ([dict[@"status"] intValue] == 1) {
        cell.lingquBtn.layer.borderColor = COLOR_0083FD.CGColor;
        [cell.lingquBtn setTitle:@"领取" forState:UIControlStateNormal];
        [cell.lingquBtn setTitleColor:COLOR_0083FD forState:UIControlStateNormal];
    } else {
        cell.lingquBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
        [cell.lingquBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [cell.lingquBtn setTitleColor:COLOR_D3D3D3 forState:UIControlStateNormal];
    }
    if ([dict[@"userType"] intValue] == 2) {
        cell.xrzxImgView.hidden = NO;
    } else {
        cell.xrzxImgView.hidden = YES;
    }
    cell.titLab.text = dict[@"name"];
    cell.fullMoneyLab.text = [NSString stringWithFormat:@"满%@元可用",dict[@"orderAmount"]];
    cell.moneyLab.text = [NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]];
    NSString *begStr = [dict[@"beginTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endStr = [dict[@"endTime"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    cell.dateLab.text = [NSString stringWithFormat:@"%@-%@",begStr,endStr];
    return cell;
}

#pragma mark ------ ADLCouponCellDelegate ------
- (void)didClickLingQuBtn:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"领取"]) {
        ADLCouponCell *cell = (ADLCouponCell *)sender.superview.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:self.dataArr[indexPath.section][@"id"] forKey:@"couponId"];
        
        [ADLNetWorkManager postWithPath:k_draw_coupon parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"领取成功"];
                [self getAllCoupon];
            }
        } failure:nil];
    }
}

- (void)getAllCoupon {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_coupon_center parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                self.tableView.tableFooterView = [UIView new];
                [self.dataArr addObjectsFromArray:resArr];
            } else {
                self.tableView.tableFooterView = self.blankView;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无优惠券" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

- (void)dealloc {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
