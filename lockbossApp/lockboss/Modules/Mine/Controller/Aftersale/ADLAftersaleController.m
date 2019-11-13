//
//  ADLAftersaleController.m
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAftersaleController.h"
#import "ADLSelAfterTypeController.h"
#import "ADLAftersaleDetailController.h"
#import "ADLGoodsDetailController.h"

#import "ADLSearchAnimateView.h"
#import "ADLAfterSaleListCell.h"
#import "ADLAfterRecordCell.h"
#import "ADLTitleView.h"
#import "ADLBlankView.h"

@interface ADLAftersaleController ()<ADLSearchAnimateViewDelegate,ADLAfterSaleListCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLSearchAnimateView *searchView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ADLAftersaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"我的售后服务"];
    self.index = 0;
    
    __weak typeof(self)weakSelf = self;
    ADLTitleView *titleView = [ADLTitleView titleViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"申请售后",@"处理中",@"申请记录"]];
    [self.view addSubview:titleView];
    titleView.clickTitle = ^(NSInteger index) {
        weakSelf.index = index;
        weakSelf.offset = 0;
        weakSelf.goodsName = nil;
        [weakSelf.searchView cancleSearch];
        [weakSelf getDataWithIndex:index goodsName:weakSelf.goodsName loading:YES];
    };
    
    ADLSearchAnimateView *searchView = [ADLSearchAnimateView searchAnimateViewWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT, SCREEN_WIDTH, 50) placeholder:@"搜索商品" verticalMargin:8 instant:NO];
    searchView.delegate = self;
    searchView.hideBottomView = YES;
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT+50, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-50)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getDataWithIndex:weakSelf.index goodsName:weakSelf.goodsName loading:NO];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithIndex:weakSelf.index goodsName:weakSelf.goodsName loading:NO];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getDataWithIndex:0 goodsName:nil loading:YES];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0) {
        return 120;
    } else {
        return 144;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0) {
        ADLAfterSaleListCell *saleCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSaleListCell"];
        if (saleCell == nil) {
            saleCell = [[NSBundle mainBundle] loadNibNamed:@"ADLAfterSaleListCell" owner:nil options:nil].lastObject;
            saleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            saleCell.delegate = self;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        [saleCell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        saleCell.imgUrl = dict[@"goodsImg"];
        saleCell.nameLab.text = dict[@"goodsName"];
        saleCell.numLab.text = [NSString stringWithFormat:@"数量：%@",dict[@"goodsNum"]];
        return saleCell;
    } else {
        ADLAfterRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:@"AfterRecordCell"];
        if (recordCell == nil) {
            recordCell = [[NSBundle mainBundle] loadNibNamed:@"ADLAfterRecordCell" owner:nil options:nil].lastObject;
            recordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        recordCell.identifyLab.text = [NSString stringWithFormat:@"售后订单：%@",dict[@"customerId"]];
        if (self.index == 1) {
            recordCell.statusLab.text = dict[@"statusStr"];
        } else {
            recordCell.statusLab.text = @"";
        }
        if ([dict[@"orderType"] boolValue]) {
            recordCell.imgUrl = dict[@"imgUrl"];
            [recordCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"imgUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            recordCell.nameLab.text = dict[@"name"];
            recordCell.numLab.text = [NSString stringWithFormat:@"数量：%@",dict[@"num"]];
        } else {
            recordCell.imgUrl = dict[@"goodsImg"];
            [recordCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"goodsImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            recordCell.nameLab.text = dict[@"goodsName"];
            recordCell.numLab.text = [NSString stringWithFormat:@"数量：%@",dict[@"goodsNum"]];
        }
        return recordCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    if (self.index == 0) {
        if (dict[@"goodsId"]) {
            ADLGoodsDetailController *goodsVC = [[ADLGoodsDetailController alloc] init];
            goodsVC.goodsId = dict[@"goodsId"];
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
    } else {
        ADLAftersaleDetailController *detailVC = [[ADLAftersaleDetailController alloc] init];
        detailVC.aftersaleId = dict[@"customerId"];
        detailVC.clickConfirmBtn = ^{
            [self getDataWithIndex:self.index goodsName:nil loading:NO];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark ------ 取消搜索 ------
- (void)didClickCancleButton {
    if (self.goodsName) {
        self.offset = 0;
        self.goodsName = nil;
        [self getDataWithIndex:self.index goodsName:nil loading:NO];
    }
}

#pragma mark ------ 点击搜索 ------
- (void)didClickSearchDoneButton:(UITextField *)textField {
    if (textField.text.length == 0) {
        [ADLToast showMessage:@"请输入商品名称"];
    } else {
        self.offset = 0;
        [textField resignFirstResponder];
        self.goodsName = textField.text;
        [self getDataWithIndex:self.index goodsName:textField.text loading:YES];
    }
}

#pragma mark ------ 申请售后 ------
- (void)didClickApplyAfterSaleBtn:(UIButton *)sender {
    ADLAfterSaleListCell *cell = (ADLAfterSaleListCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    
    NSInteger startRange = 1;
    double timestamp = [dict[@"finishTime"] doubleValue];
    if (timestamp > 10000) {
        NSInteger second = [ADLUtils getSecondFromStartTimestamp:timestamp endTimestamp:0];
        if (second > 604800) startRange = 2;
        if (second > 1296000) startRange = 3;
    }
    
    ADLSelAfterTypeController *typeVC = [[ADLSelAfterTypeController alloc] init];
    typeVC.startRange = startRange;
    typeVC.dataDict = dict;
    typeVC.orderVC = NO;
    typeVC.finishBlock = ^{
        self.offset = 0;
        [self getDataWithIndex:0 goodsName:nil loading:NO];
    };
    [self.navigationController pushViewController:typeVC animated:YES];
}

#pragma mark ------ 获取数据 ------
- (void)getDataWithIndex:(NSInteger)index goodsName:(NSString *)goodsName loading:(BOOL)loading {
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:@(index) forKey:@"status"];
    [params setValue:goodsName forKey:@"goodsName"];
    [ADLNetWorkManager postWithPath:k_query_after_sale_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.offset == 0) {
            [self.dataArr removeAllObjects];
        }
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            NSArray *resArr = responseDict[@"data"][@"rows"];
            if (resArr.count > 0) {
                if (self.index == 0) {
                    for (NSDictionary *dict in resArr) {
                        NSArray *subArr = dict[@"orderGoodsList"];
                        if (subArr.count > 0) {
                            for (NSMutableDictionary *subDict in subArr) {
                                [subDict setValue:dict[@"finishTime"] forKey:@"finishTime"];
                                [self.dataArr addObject:subDict];
                            }
                        }
                    }
                } else {
                    for (NSMutableDictionary *dict in resArr) {
                        NSArray *goodsArr = dict[@"orderGoodsList"];
                        if (goodsArr.count > 0) {
                            for (NSMutableDictionary *muDcit in goodsArr) {
                                [muDcit setValue:dict[@"customerId"] forKey:@"customerId"];
                                [muDcit setValue:dict[@"status"] forKey:@"status"];
                                [muDcit setValue:@(0) forKey:@"orderType"];
                                if (self.index == 1) {
                                    [muDcit setValue:[self dealwithAfterSaleStatus:[dict[@"status"] integerValue]] forKey:@"statusStr"];
                                }
                            }
                            [self.dataArr addObjectsFromArray:goodsArr];
                        } else {
                            NSArray *serArr = dict[@"serviceChargeVOList"];
                            for (NSMutableDictionary *serDcit in serArr) {
                                [serDcit setValue:dict[@"customerId"] forKey:@"customerId"];
                                [serDcit setValue:dict[@"status"] forKey:@"status"];
                                [serDcit setValue:@(1) forKey:@"orderType"];
                                if (self.index == 1) {
                                    [serDcit setValue:[self dealwithAfterSaleStatus:[dict[@"status"] integerValue]] forKey:@"statusStr"];
                                }
                            }
                            [self.dataArr addObjectsFromArray:serArr];
                        }
                    }
                }
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (self.dataArr.count == 0) {
                if (goodsName) {
                    self.blankView.promptLab.text = @"搜索结果为空，换个关键词试试吧！";
                } else {
                    if (self.index == 0) {
                        self.blankView.promptLab.text = @"暂无可申请售后的商品";
                    } else if (self.index == 1) {
                        self.blankView.promptLab.text = @"暂无处理中的商品";
                    } else {
                        self.blankView.promptLab.text = @"暂无申请记录";
                    }
                }
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            self.offset = [responseDict[@"data"][@"offset"] integerValue]+resArr.count;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 处理售后状态 ------
- (NSString *)dealwithAfterSaleStatus:(NSInteger)status {
    NSString *statusStr;
    if (status == 6) {
        statusStr = @"退款处理中";
    } else if (status == 7) {
        statusStr = @"换货处理中";
    } else if (status == 8) {
        statusStr = @"维修处理中";
    } else if (status == 9) {
        statusStr = @"退款已完成";
    } else if (status == 10) {
        statusStr = @"换货已完成";
    } else if (status == 11) {
        statusStr = @"维修已完成";
    } else if (status == 12) {
        statusStr = @"退货已完成";
    } else if (status == 13) {
        statusStr = @"退货处理中";
    } else {
        statusStr = @"";
    }
    return statusStr;
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:@"" prompt:@"暂无可申请售后的商品" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
