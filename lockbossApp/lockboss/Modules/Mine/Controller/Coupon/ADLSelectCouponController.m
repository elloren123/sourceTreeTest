//
//  ADLSelectCouponController.m
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectCouponController.h"
#import "ADLDrawCouponController.h"
#import "ADLCouponCell.h"
#import "ADLBlankView.h"

@interface ADLSelectCouponController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) ADLBlankView *blankView;
@end

@implementation ADLSelectCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"选择优惠券"];
    [self addRightButtonWithTitle:@"领券" action:@selector(clickLingQuanBtn)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = COLOR_F2F2F2;
    self.footerView = footerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, BOTTOM_H, 0);
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.estimatedRowHeight = 0;
    tableView.rowHeight = 92;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getUseableCouponData];
}

#pragma mark ------ 领券 ------
- (void)clickLingQuanBtn {
    ADLDrawCouponController *drawVC = [[ADLDrawCouponController alloc] init];
    drawVC.finishBlock = ^{
        [self getUseableCouponData];
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
    }
    NSDictionary *dict = self.dataArr[indexPath.section];
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
    [cell.lingquBtn setTitle:@"使用" forState:UIControlStateNormal];
    cell.lingquBtn.layer.borderColor = COLOR_0083FD.CGColor;
    cell.lingquBtn.enabled = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickCoupon) {
        self.clickCoupon(self.dataArr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 获取可用优惠券 ------
- (void)getUseableCouponData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.skuIdsStr forKey:@"skuIdsStr"];
    [params setValue:@(self.orderType) forKey:@"orderType"];
    [params setValue:@(self.servicePrice) forKey:@"servicePrice"];
    
    [ADLNetWorkManager postWithPath:k_order_coupon parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    if ([dict[@"orderAmount"] doubleValue] <= self.money) {
                        [self.dataArr addObject:dict];
                    }
                }
            }
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无可用优惠券" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
