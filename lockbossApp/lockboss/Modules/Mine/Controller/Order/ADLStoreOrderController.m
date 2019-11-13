//
//  ADLStoreOrderController.m
//  lockboss
//
//  Created by Adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLStoreOrderController.h"
#import "ADLSearchOrderController.h"
#import "ADLOrderPayController.h"
#import "ADLOrderDetailController.h"
#import "ADLGoodsEvaluateController.h"
#import "ADLServiceEvaluateController.h"

#import "ADLTitleView.h"
#import "ADLSearchFakeView.h"
#import "ADLOrderListCell.h"
#import "ADLBlankView.h"

@interface ADLStoreOrderController ()<UITableViewDelegate,UITableViewDataSource,ADLOrderListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ADLStoreOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"商城订单"];
    
    self.index = 0;
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"全部",@"待支付",@"待发货",@"待收货",@"待服务",@"已完成",@"已取消"]];
    [self.view addSubview:titleView];
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.offset = 0;
        weakSelf.index = index;
        [weakSelf getDataWithIndex:index showLoading:YES];
    };
    
    ADLSearchFakeView *fakeView = [ADLSearchFakeView searchFakeViewWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT, SCREEN_WIDTH, 50) placeholder:@"搜索订单商品"];
    [self.view addSubview:fakeView];
    fakeView.clickSearch = ^{
        ADLSearchOrderController *searchVC = [[ADLSearchOrderController alloc] init];
        [weakSelf customPushViewController:searchVC];
    };
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT+50, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-50) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.rowHeight = 129;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getDataWithIndex:weakSelf.index showLoading:NO];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithIndex:weakSelf.index showLoading:NO];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getDataWithIndex:0 showLoading:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderStatus) name:REFRESH_ORDER_LIST object:nil];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    headView.backgroundColor = COLOR_F2F2F2;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLOrderListCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSInteger status = [dict[@"orderStatus"] integerValue];
    BOOL serviceType = [dict[@"orderType"] boolValue];
    NSArray *goodsImgs = dict[@"goodsImgs"];
    if (status == 0) {
        cell.statusBtn.hidden = NO;
        [cell.statusBtn setTitle:@"去支付" forState:UIControlStateNormal];
        cell.statusLab.text = @"待支付";
    } else if (status == 1) {
        cell.statusBtn.hidden = NO;
        [cell.statusBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        cell.statusLab.text = @"待发货";
    } else if (status == 2) {
        cell.statusLab.text = @"已取消";
        cell.statusBtn.hidden = YES;
    } else if (status == 3) {
        cell.statusBtn.hidden = NO;
        cell.statusLab.text = @"待收货";
        [cell.statusBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    } else if (status == 4) {
        cell.statusBtn.hidden = NO;
        cell.statusLab.text = @"待服务";
        [cell.statusBtn setTitle:@"服务完成" forState:UIControlStateNormal];
    } else {
        if ([dict[@"evStatus"] integerValue] == 0 && goodsImgs.count == 1) {
            cell.statusBtn.hidden = NO;
            [cell.statusBtn setTitle:@"去评价" forState:UIControlStateNormal];
        } else {
            cell.statusBtn.hidden = YES;
        }
        cell.statusLab.text = @"已完成";
    }
    
    if (serviceType) {
        cell.nameLab.hidden = YES;
        cell.attributeLab.hidden = YES;
        NSArray *serImgs = dict[@"serviceImgs"];
        if (serImgs.count == 1) {
            cell.serviceLab.hidden = NO;
            cell.serviceLab.text = dict[@"serviceName"];
        } else {
            cell.serviceLab.hidden = YES;
        }
        cell.countLab.text = dict[@"countString"];
        [cell updateImageViewWithUrlArr:serImgs];
        
    } else {
        cell.serviceLab.hidden = YES;
        if (goodsImgs.count == 1) {
            cell.nameLab.hidden = NO;
            cell.attributeLab.hidden = NO;
            cell.nameLab.text = dict[@"goodsName"];
            cell.attributeLab.text = dict[@"attribute"];
        } else {
            cell.nameLab.hidden = YES;
            cell.attributeLab.hidden = YES;
        }
        cell.countLab.text = dict[@"countString"];
        [cell updateImageViewWithUrlArr:goodsImgs];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLOrderDetailController *detailVC = [[ADLOrderDetailController alloc] init];
    NSDictionary *dict = self.dataArr[indexPath.section];
    detailVC.orderId = dict[@"id"];
    detailVC.suborderId = dict[@"suborderId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 刷新订单通知 ------
- (void)refreshOrderStatus {
    self.offset = 0;
    [self getDataWithIndex:self.index showLoading:NO];
}

#pragma mark ------ ADLOrderListCellDelegate ------
- (void)didClickScrollView:(UIButton *)sender {
    ADLOrderListCell *cell = (ADLOrderListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLOrderDetailController *detailVC = [[ADLOrderDetailController alloc] init];
    NSDictionary *dict = self.dataArr[indexPath.section];
    detailVC.orderId = dict[@"id"];
    detailVC.suborderId = dict[@"suborderId"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didClickStatusBtn:(UIButton *)sender {
    ADLOrderListCell *cell = (ADLOrderListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"去支付"]) {
        ADLOrderPayController *payVC = [[ADLOrderPayController alloc] init];
        payVC.money = [dict[@"payAmount"] doubleValue];
        payVC.orderId = dict[@"id"];
        payVC.serviceOrder = [dict[@"orderType"] boolValue];
        [self.navigationController pushViewController:payVC animated:YES];
    } else if ([title isEqualToString:@"提醒发货"]) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:dict[@"id"] forKey:@"orderId"];
        [ADLNetWorkManager postWithPath:k_remind_shipment parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"已提醒卖家尽快发货"];
            }
        } failure:nil];
        
    } else if ([title isEqualToString:@"确认收货"]) {
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:dict[@"id"] forKey:@"orderId"];
        [params setValue:dict[@"suborderId"] forKey:@"subOrderId"];
        [ADLNetWorkManager postWithPath:k_order_confirm_receipt parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"确认收货成功"];
                if (self.index == 0) {
                    self.offset = 0;
                    [self getDataWithIndex:self.index showLoading:NO];
                } else {
                    [self.dataArr removeObjectAtIndex:indexPath.section];
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    if (self.dataArr.count == 0) {
                        self.offset = 0;
                        [self getDataWithIndex:self.index showLoading:NO];
                    }
                }
            }
        } failure:nil];
        
    } else if ([title isEqualToString:@"服务完成"]) {
        [ADLAlertView showWithTitle:@"提示" message:@"确认服务已完成？" confirmTitle:nil confirmAction:^{
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:dict[@"id"] forKey:@"orderId"];
            [params setValue:dict[@"suborderId"] forKey:@"subOrderId"];
            [ADLNetWorkManager postWithPath:k_service_confirm_finish parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    [ADLToast showMessage:@"确认成功"];
                    if (self.index == 0) {
                        self.offset = 0;
                        [self getDataWithIndex:self.index showLoading:NO];
                    } else {
                        [self.dataArr removeObjectAtIndex:indexPath.section];
                        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                        if (self.dataArr.count == 0) {
                            self.offset = 0;
                            [self getDataWithIndex:self.index showLoading:NO];
                        }
                    }
                }
            } failure:nil];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
        
    } else {
        if ([dict[@"orderType"] boolValue]) {
            ADLServiceEvaluateController *serEvaVC = [[ADLServiceEvaluateController alloc] init];
            serEvaVC.orderId = dict[@"serviceOrderId"];
            serEvaVC.personId = dict[@"serviceUserId"];
            serEvaVC.evaluateFinish = ^{
                self.offset = 0;
                [self getDataWithIndex:self.index showLoading:NO];
            };
            [self.navigationController pushViewController:serEvaVC animated:YES];
        } else {
            ADLGoodsEvaluateController *evaVC = [[ADLGoodsEvaluateController alloc] init];
            evaVC.orderId = dict[@"suborderId"];
            evaVC.imgUrl = [dict[@"goodsImgs"] firstObject];
            evaVC.skuId = dict[@"skuId"];
            evaVC.goodsName = dict[@"goodsName"];
            evaVC.goodsId = dict[@"goodsId"];
            evaVC.evaluateFinish = ^{
                self.offset = 0;
                [self getDataWithIndex:self.index showLoading:NO];
            };
            [self.navigationController pushViewController:evaVC animated:YES];
        }
    }
}

#pragma mark ------ 获取数据 ------
- (void)getDataWithIndex:(NSInteger)index showLoading:(BOOL)showLoading {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:[self dealwithOrderTypeWithIndex:index] forKey:@"status"];
    if (showLoading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_query_my_order parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([ADLToast isShowLoading]) [ADLToast hide];
            if (self.offset == 0) [self.dataArr removeAllObjects];
            
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    NSDictionary *suborderDict = [dict[@"suborderList"] firstObject];
                    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
                    [muDict setValue:dict[@"id"] forKey:@"id"];
                    [muDict setValue:dict[@"orderType"] forKey:@"orderType"];
                    [muDict setValue:dict[@"status"] forKey:@"orderStatus"];
                    [muDict setValue:dict[@"payAmount"] forKey:@"payAmount"];
                    [muDict setValue:suborderDict[@"id"] forKey:@"suborderId"];
                    
                    if ([dict[@"orderType"] boolValue]) {
                        [muDict setValue:suborderDict[@"serviceEvStatus"] forKey:@"evStatus"];
                        NSArray *serArr = suborderDict[@"serviceInfoList"];
                        [muDict setValue:serArr.firstObject[@"status"] forKey:@"subStatus"];
                        [muDict setValue:serArr.firstObject[@"serviceUserId"] forKey:@"serviceUserId"];
                        [muDict setValue:serArr.firstObject[@"serviceOrderId"] forKey:@"serviceOrderId"];
                        if (serArr.count == 1) {
                            NSDictionary *serDcit1 = serArr.firstObject;
                            [muDict setValue:[NSString stringWithFormat:@"共%@次服务",serDcit1[@"num"]] forKey:@"countString"];
                            NSString *serImgStr1 = serDcit1[@"serviceImg"] ? serDcit1[@"serviceImg"] : @"";
                            [muDict setValue:@[serImgStr1] forKey:@"serviceImgs"];
                            [muDict setValue:serDcit1[@"serviceName"] forKey:@"serviceName"];
                            [muDict setValue:@[@""] forKey:@"goodsImgs"];
                        } else {
                            NSMutableArray *serImgArr = [[NSMutableArray alloc] init];
                            NSInteger serCount = 0;
                            for (NSDictionary *serDcit in serArr) {
                                serCount = serCount+[serDcit[@"num"] integerValue];
                                NSString *serImgStr = serDcit[@"serviceImg"] ? serDcit[@"serviceImg"] : @"";
                                [serImgArr addObject:serImgStr];
                            }
                            [muDict setValue:serImgArr forKey:@"serviceImgs"];
                            [muDict setValue:[NSString stringWithFormat:@"共%lu次服务",serCount] forKey:@"countString"];
                            [muDict setValue:@[@""] forKey:@"goodsImgs"];
                        }
                    } else {
                        [muDict setValue:suborderDict[@"evStatus"] forKey:@"evStatus"];
                        NSArray *goodsArr = suborderDict[@"orderGoodsList"];
                        NSArray *serArr = suborderDict[@"serviceInfoList"];
                        [muDict setValue:serArr.firstObject[@"status"] forKey:@"subStatus"];
                        NSInteger count = 0;
                        for (NSDictionary *sDict in serArr) {
                            if (sDict[@"id"]) {
                                count = count+[sDict[@"num"] integerValue];
                            }
                        }
                        if (goodsArr.count == 1) {
                            NSDictionary *goodsDict1 = goodsArr.firstObject;
                            if (count > 0) {
                                [muDict setValue:[NSString stringWithFormat:@"共%@件商品, %ld次服务",goodsDict1[@"goodsNum"],count] forKey:@"countString"];
                            } else {
                                [muDict setValue:[NSString stringWithFormat:@"共%@件商品",goodsDict1[@"goodsNum"]] forKey:@"countString"];
                            }
                            NSString *goodsImgStr1 = goodsDict1[@"goodsImg"] ? goodsDict1[@"goodsImg"] : @"";
                            [muDict setValue:@[goodsImgStr1] forKey:@"goodsImgs"];
                            [muDict setValue:goodsDict1[@"goodsName"] forKey:@"goodsName"];
                            NSArray *attrArr = [NSJSONSerialization JSONObjectWithData:[goodsDict1[@"goodsProperty"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                            NSMutableString *attrStr = [[NSMutableString alloc] initWithString:@"规格："];
                            for (NSDictionary *attrDict in attrArr) {
                                [attrStr appendString:attrDict[@"propertyValue"]];
                                [attrStr appendString:@", "];
                            }
                            [muDict setValue:[attrStr substringToIndex:attrStr.length-2] forKey:@"attribute"];
                            [muDict setValue:goodsDict1[@"skuId"] forKey:@"skuId"];
                            [muDict setValue:goodsDict1[@"goodsId"] forKey:@"goodsId"];
                        } else {
                            NSMutableArray *goodsImgArr = [[NSMutableArray alloc] init];
                            NSInteger goodsCount = 0;
                            for (NSDictionary *goodsDict in goodsArr) {
                                goodsCount = goodsCount+[goodsDict[@"goodsNum"] integerValue];
                                NSString *goodsImgStr = goodsDict[@"goodsImg"] ? goodsDict[@"goodsImg"] : @"";
                                [goodsImgArr addObject:goodsImgStr];
                            }
                            [muDict setValue:goodsImgArr forKey:@"goodsImgs"];
                            
                            if (count > 0) {
                                [muDict setValue:[NSString stringWithFormat:@"共%lu件商品, %ld次服务",goodsCount,count] forKey:@"countString"];
                            } else {
                                [muDict setValue:[NSString stringWithFormat:@"共%lu件商品",goodsCount] forKey:@"countString"];
                            }
                        }
                    }
                    [self.dataArr addObject:muDict];
                }
            }
            
            [self dealwithTableViewFooterWithCount:resArr.count];
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 处理订单类型Index ------
- (NSNumber *)dealwithOrderTypeWithIndex:(NSInteger)index {
    if (index == 0) {
        return nil;
    } else if (index == 1) {
        return @(0);
    } else if (index == 2) {
        return @(1);
    } else if (index == 3) {
        return @(3);
    } else if (index == 4) {
        return @(4);
    } else if (index == 5) {
        return @(5);
    } else {
        return @(2);
    }
}

#pragma mark ------ 处理订单类型空视图 ------
- (void)dealwithTableViewFooterWithCount:(NSInteger)count {
    if (count < self.pageSize) {
        self.tableView.mj_footer.hidden = YES;
    } else {
        self.tableView.mj_footer.hidden = NO;
    }
    if (self.dataArr.count == 0) {
        switch (self.index) {
            case 0:
                self.blankView.promptLab.text = @"暂无订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_all"];
                break;
            case 1:
                self.blankView.promptLab.text = @"暂无待支付订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dzf"];
                break;
            case 2:
                self.blankView.promptLab.text = @"暂无待发货订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dfh"];
                break;
            case 3:
                self.blankView.promptLab.text = @"暂无待收货订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dfh"];
                break;
            case 4:
                self.blankView.promptLab.text = @"暂无待服务订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_order_dfw"];
                break;
            case 5:
                self.blankView.promptLab.text = @"暂无已完成订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"blank_ywc"];
                break;
            case 6:
                self.blankView.promptLab.text = @"暂无已取消订单";
                self.blankView.imageView.image = [UIImage imageNamed:@"data_blank"];
                break;
        }
        self.tableView.tableFooterView = self.blankView;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无订单" backgroundColor:COLOR_F2F2F2];
        _blankView.imageView.image = [UIImage imageNamed:@"blank_order_all"];
    }
    return _blankView;
}

@end
