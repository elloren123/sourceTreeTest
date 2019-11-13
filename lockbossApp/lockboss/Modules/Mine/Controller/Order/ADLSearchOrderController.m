//
//  ADLSearchOrderController.m
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchOrderController.h"
#import "ADLOrderPayController.h"
#import "ADLOrderDetailController.h"
#import "ADLGoodsEvaluateController.h"
#import "ADLServiceEvaluateController.h"

#import "ADLOrderListCell.h"
#import "ADLSearchView.h"
#import "ADLBlankView.h"

@interface ADLSearchOrderController ()<UITableViewDelegate,UITableViewDataSource,ADLSearchViewDelegate,ADLOrderListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) NSString *goodsName;
@end

@implementation ADLSearchOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADLSearchView *searchView = [[ADLSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) placeholder:@"请输入要搜索的商品名称" instant:NO];
    searchView.delegate = self;
    [self.view addSubview:searchView];
    
    __weak typeof(self)weakSelf = self;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.rowHeight = 129;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithLoading:NO];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
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
        if ([dict[@"subStatus"] integerValue] == 7) {
            cell.statusBtn.hidden = NO;
            [cell.statusBtn setTitle:@"服务完成" forState:UIControlStateNormal];
        } else {
            cell.statusBtn.hidden = YES;
        }
        cell.statusLab.text = @"待服务";
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
    detailVC.orderId = self.dataArr[indexPath.section][@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ ADLOrderListCellDelegate ------
- (void)didClickScrollView:(UIButton *)sender {
    ADLOrderListCell *cell = (ADLOrderListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLOrderDetailController *detailVC = [[ADLOrderDetailController alloc] init];
    detailVC.orderId = self.dataArr[indexPath.section][@"id"];
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
        [ADLNetWorkManager postWithPath:k_order_confirm_receipt parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"确认收货成功"];
                self.offset = 0;
                [self getDataWithLoading:YES];
            }
        } failure:nil];
        
    } else if ([title isEqualToString:@"服务完成"]) {
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:dict[@"id"] forKey:@"orderId"];
        [ADLNetWorkManager postWithPath:k_service_confirm_finish parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"确认成功"];
                self.offset = 0;
                [self getDataWithLoading:YES];
            }
        } failure:nil];
        
    } else {
        if ([dict[@"orderType"] boolValue]) {
            ADLServiceEvaluateController *serEvaVC = [[ADLServiceEvaluateController alloc] init];
            serEvaVC.orderId = dict[@"serviceOrderId"];
            serEvaVC.personId = dict[@"serviceUserId"];
            serEvaVC.evaluateFinish = ^{
                self.offset = 0;
                [self getDataWithLoading:YES];
            };
            [self.navigationController pushViewController:serEvaVC animated:YES];
        } else {
            ADLGoodsEvaluateController *evaVC = [[ADLGoodsEvaluateController alloc] init];
            evaVC.orderId = dict[@"id"];
            evaVC.imgUrl = [dict[@"goodsImgs"] firstObject];
            evaVC.skuId = dict[@"skuId"];
            evaVC.goodsName = dict[@"goodsName"];
            evaVC.goodsId = dict[@"goodsId"];
            evaVC.evaluateFinish = ^{
                self.offset = 0;
                [self getDataWithLoading:YES];
            };
            [self.navigationController pushViewController:evaVC animated:YES];
        }
    }
}

#pragma mark ------ 取消 ------
- (void)didClickCancleButton {
    [self customPopViewController];
}

#pragma mark ------ 搜索 ------
- (void)didClickSearchButton:(UITextField *)textField {
    if (textField.text.length == 0) {
        [ADLToast showMessage:@"请输入商品名称"];
    } else {
        [textField resignFirstResponder];
        self.goodsName = textField.text;
        self.offset = 0;
        [self getDataWithLoading:YES];
    }
}

#pragma mark ------ 获取数据 ------
- (void)getDataWithLoading:(BOOL)loading {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:self.goodsName forKey:@"goodsName"];
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_query_my_order parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([ADLToast isShowLoading]) {
                [ADLToast hide];
            }
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                for (NSDictionary *dict in resArr) {
                    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
                    [muDict setValue:dict[@"id"] forKey:@"id"];
                    [muDict setValue:dict[@"orderType"] forKey:@"orderType"];
                    [muDict setValue:dict[@"status"] forKey:@"orderStatus"];
                    [muDict setValue:dict[@"payAmount"] forKey:@"payAmount"];
                    if ([dict[@"orderType"] boolValue]) {
                        [muDict setValue:[dict[@"suborderList"] lastObject][@"serviceEvStatus"] forKey:@"evStatus"];
                        NSArray *serArr = [dict[@"suborderList"] lastObject][@"serviceInfoList"];
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
                            [muDict setValue:[NSString stringWithFormat:@"共%ld次服务",serCount] forKey:@"countString"];
                            [muDict setValue:@[@""] forKey:@"goodsImgs"];
                        }
                    } else {
                        [muDict setValue:[dict[@"suborderList"] lastObject][@"evStatus"] forKey:@"evStatus"];
                        NSArray *goodsArr = [dict[@"suborderList"] lastObject][@"orderGoodsList"];
                        NSArray *serArr = [dict[@"suborderList"] lastObject][@"serviceInfoList"];
                        [muDict setValue:serArr.firstObject[@"status"] forKey:@"subStatus"];
                        if (goodsArr.count == 1) {
                            NSDictionary *goodsDict1 = goodsArr.firstObject;
                            [muDict setValue:[NSString stringWithFormat:@"共%@件商品",goodsDict1[@"goodsNum"]] forKey:@"countString"];
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
                            [muDict setValue:[NSString stringWithFormat:@"共%lu件商品",goodsCount] forKey:@"countString"];
                        }
                    }
                    [self.dataArr addObject:muDict];
                }
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (self.dataArr.count == 0 && self.goodsName) {
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
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"搜索结果为空，换个关键词试试吧！" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
