//
//  ADLActGoodsController.m
//  lockboss
//
//  Created by adel on 2019/5/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLActGoodsController.h"
#import "ADLGoodsDetailController.h"
#import "ADLWebViewController.h"
#import "ADLActivityGoodsCell.h"
#import "ADLGoodsAttriView.h"
#import "ADLActTimerView.h"
#import "ADLBannerView.h"
#import "ADLBlankView.h"
#import "ADLSortView.h"

@interface ADLActGoodsController ()<UITableViewDelegate,UITableViewDataSource,ADLActivityGoodsCellDelegate,ADLSortViewDelegate>
@property (nonatomic, strong) ADLActTimerView *timerView;
@property (nonatomic, strong) ADLBannerView *bannerView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) ADLSortView *sortView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat headerH;
@end

@implementation ADLActGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timestamp = 0;
    self.headerH = 0;
    [self addNavigationView:@"活动商品"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.4+97)];
    ADLBannerView *bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.4) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    self.bannerView = bannerView;
    
    __weak typeof(self)weakSelf = self;
    bannerView.clickBanner = ^(NSString *str) {
        if ([ADLUtils isPureInt:str]) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.goodsId = str;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        } else {
            if ([str hasPrefix:@"http"]) {
                ADLWebViewController *webVC = [[ADLWebViewController alloc] init];
                webVC.urlString = str;
                [weakSelf.navigationController pushViewController:webVC animated:YES];
            }
        }
    };
    
    ADLActTimerView *timerView = [[NSBundle mainBundle] loadNibNamed:@"ADLActTimerView" owner:nil options:nil].lastObject;
    timerView.frame = CGRectMake(0, SCREEN_WIDTH*0.4, SCREEN_WIDTH, 97);
    self.timerView = timerView;
    [headerView addSubview:bannerView];
    [headerView addSubview:timerView];
    
    ADLSortView *sortView = [ADLSortView sortViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"销量优先",@"价格排序"]];
    sortView.sortArr = @[@(1)];
    sortView.delegate = self;
    self.sortView = sortView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 114;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getDataWithIndex:weakSelf.index ascending:weakSelf.ascending loading:NO];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithIndex:weakSelf.index ascending:weakSelf.ascending loading:NO];
    }];
    tableView.mj_footer.hidden = YES;
    self.tableView = tableView;
    self.index = 0;
    self.ascending = NO;
    
    [self getBannerData];
    [self getDataWithIndex:0 ascending:NO loading:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.timestamp != 0) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)didClickTitle:(NSInteger)index ascending:(BOOL)ascending {
    self.offset = 0;
    self.index = index;
    self.ascending = ascending;
    [self getDataWithIndex:index ascending:ascending loading:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sortView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLActivityGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityGoodsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLActivityGoodsCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.titLab.text = dict[@"goodsName"];
    cell.descLab.text = dict[@"goodsTitle"];
    cell.fullMoneyLab.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"price"] floatValue]];
    NSString *moneyStr = [NSString stringWithFormat:@"¥%.2f",[dict[@"nowPrice"] floatValue]];
    CGFloat fonSize = 11;
    if (SCREEN_WIDTH == 320) fonSize = 10;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fonSize] range:NSMakeRange(0, 1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fonSize] range:NSMakeRange(moneyStr.length-3, 3)];
    cell.moneyLab.attributedText = attributeStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
    detailVC.goodsId = self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 加入购物车 ------
- (void)didClickShoppingCarBtn:(UIButton *)sender {
    if ([ADLUserModel sharedModel].login) {
        ADLActivityGoodsCell *cell = (ADLActivityGoodsCell *)sender.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"goodsId"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSArray *skuArr = responseDict[@"data"][@"skuList"];
                [dict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
                [dict setValue:self.dataArr[indexPath.row][@"imgUrl"] forKey:@"imageUrl"];
                [dict setValue:skuArr forKey:@"skuList"];
                [ADLToast hide];
                [ADLGoodsAttriView goodsAttributeViewWith:dict confirmAction:nil];
            }
        } failure:nil];
    } else {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"您未登录，请先登录？" confirmTitle:nil confirmAction:^{
            [self pushLoginViewControllerHideTabbar:NO success:nil];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 获取Banner ------
- (void)getBannerData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(6) forKey:@"type"];
    [ADLNetWorkManager postWithPath:k_query_banner parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            [self.bannerView updateBanner:resArr imgKey:nil urlKey:nil];
        }
    } failure:nil];
}

#pragma mark ------ 获取数据 ------
- (void)getDataWithIndex:(NSInteger)index ascending:(BOOL)ascending loading:(BOOL)loading {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.activityId forKey:@"activityId"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    
    NSString *typeStr = index == 1 ? @"nowPrice" : @"salenum";
    NSString *orderStr = ascending == YES ? @"asc" : @"desc";
    [params setValue:typeStr forKey:@"orderBy"];
    [params setValue:orderStr forKey:@"sequence"];
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_query_activity_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.timestamp = [responseDict[@"data"][@"activityInfo"][@"endTime"] doubleValue];
            [self.sortView updateTitleWithIndex:index ascending:ascending];
            
            [self updateTime];
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
            NSArray *resArr = responseDict[@"data"][@"pageInfo"][@"rows"];
            if (self.offset == 0) {
                [self.dataArr removeAllObjects];
            }
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.dataArr.count == 0) {
                self.headerH = 0;
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.headerH = VIEW_HEIGHT;
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
        [ADLToast hide];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 更新时间 ------
- (void)updateTime {
    [ADLUtils calculateDateInterval:self.timestamp includeDay:YES finish:^(NSString *day, NSString *hour, NSString *minute, NSString *second) {
        self.timerView.dayLab.text = day;
        self.timerView.hourLab.text = hour;
        self.timerView.minLab.text = minute;
        self.timerView.secLab.text = second;
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无活动商品" backgroundColor:COLOR_F2F2F2];
        _blankView.topMargin = 90;
    }
    return _blankView;
}

@end
