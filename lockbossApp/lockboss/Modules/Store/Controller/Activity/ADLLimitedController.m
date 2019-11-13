//
//  ADLLimitedController.m
//  lockboss
//
//  Created by adel on 2019/4/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLimitedController.h"
#import "ADLGoodsDetailController.h"
#import "ADLWebViewController.h"
#import "ADLGoodsAttriView.h"
#import "ADLPanicViewCell.h"
#import "ADLBannerView.h"
#import "ADLBlankView.h"

@interface ADLLimitedController ()<UITableViewDelegate,UITableViewDataSource,ADLPanicViewCellDelegate>
@property (nonatomic, strong) ADLBannerView *bannerView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *willBtn;
@property (nonatomic, strong) UIButton *nowBtn;
@end

@implementation ADLLimitedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"限时抢购"];
    
    UIButton *nowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH/2, VIEW_HEIGHT)];
    [nowBtn addTarget:self action:@selector(clickNowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nowBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [nowBtn setTitle:@"正在抢购" forState:UIControlStateNormal];
    nowBtn.backgroundColor = APP_COLOR;
    [self.view addSubview:nowBtn];
    nowBtn.selected = YES;
    self.nowBtn = nowBtn;
    
    UIButton *willBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, NAVIGATION_H, SCREEN_WIDTH/2, VIEW_HEIGHT)];
    [willBtn addTarget:self action:@selector(clickWillBtn:) forControlEvents:UIControlEventTouchUpInside];
    [willBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    willBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [willBtn setTitle:@"即将开始" forState:UIControlStateNormal];
    willBtn.backgroundColor = COLOR_999999;
    [self.view addSubview:willBtn];
    self.willBtn = willBtn;
    
    self.bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.4) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    
    __weak typeof(self)weakSelf = self;
    self.bannerView.clickBanner = ^(NSString *str) {
        if (str.length > 0) {
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
        }
    };
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = self.bannerView;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.nowBtn.selected) {
            [weakSelf getData:0 loading:NO];
        } else {
            [weakSelf getData:1 loading:NO];
        }
    }];
    if (SCREEN_WIDTH == 320) {
        tableView.rowHeight = 132;
    } else {
        tableView.rowHeight = 155;
    }
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getData:0 loading:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLPanicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"panic"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLPanicViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.goodsLab.text = dict[@"goodsName"];
    cell.nowMoneyLab.attributedText = dict[@"attrPrice"];
    cell.moneyLab.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"price"] floatValue]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"thumbnailUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.progressView.progress = [dict[@"progress"] floatValue];
    cell.progressLab.text = dict[@"percent"];
    if (self.nowBtn.selected) {
        cell.dateLab.text = [ADLUtils getDateFromTimestamp:[dict[@"activity"][@"endTime"] doubleValue] format:@"MM月dd日"];
        cell.endLab.text = @"结束";
        if ([dict[@"progress"] floatValue] >= 1) {
            cell.panicBtn.selected = YES;
            cell.panicBtn.backgroundColor = COLOR_F2F2F2;
            [cell.panicBtn setTitle:@"已抢光" forState:UIControlStateNormal];
        } else {
            cell.panicBtn.selected = NO;
            cell.panicBtn.backgroundColor = APP_COLOR;
            [cell.panicBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        }
    } else {
        cell.endLab.text = @"开始";
        cell.dateLab.text = [ADLUtils getDateFromTimestamp:[dict[@"activity"][@"beginTime"] doubleValue] format:@"MM月dd日"];
        cell.panicBtn.selected = YES;
        cell.panicBtn.backgroundColor = COLOR_F2F2F2;
        [cell.panicBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
    detailVC.goodsId = self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 正在抢购 ------
- (void)clickNowBtn:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    self.willBtn.selected = NO;
    sender.backgroundColor = APP_COLOR;
    self.willBtn.backgroundColor = COLOR_999999;
    [self getData:0 loading:YES];
}

#pragma mark ------ 即将开始 ------
- (void)clickWillBtn:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    self.nowBtn.selected = NO;
    sender.backgroundColor = APP_COLOR;
    self.nowBtn.backgroundColor = COLOR_999999;
    [self getData:1 loading:YES];
}

#pragma mark ------ 立即抢购 ------
- (void)clickPanicPurchaseBtn:(UIButton *)sender cell:(ADLPanicViewCell *)cell {
    if ([ADLUserModel sharedModel].login) {
        if (sender.selected) return;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *dict = self.dataArr[indexPath.row];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:dict[@"id"] forKey:@"goodsId"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSMutableDictionary *attrDict = [[NSMutableDictionary alloc] init];
                NSArray *skuArr = responseDict[@"data"][@"skuList"];
                [attrDict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
                [attrDict setValue:dict[@"thumbnailUrl"] forKey:@"imageUrl"];
                [attrDict setValue:skuArr forKey:@"skuList"];
                [ADLToast hide];
                [ADLGoodsAttriView goodsAttributeViewWith:attrDict confirmAction:nil];
            }
        } failure:nil];
    } else {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"您未登录，请先登录？" confirmTitle:nil confirmAction:^{
            [self pushLoginViewControllerHideTabbar:NO success:nil];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 获取数据 ------
- (void)getData:(NSInteger)type loading:(BOOL)loading {
    NSMutableDictionary *params = nil;
    if (type == 1) {
        params = [[NSMutableDictionary alloc] init];
        [params setValue:@(1) forKey:@"notStart"];
    }
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_panic_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            [self.dataArr removeAllObjects];
            NSArray *bannerArr = responseDict[@"data"][@"bannerList"];
            [self.bannerView updateBanner:bannerArr imgKey:nil urlKey:nil];
            
            NSArray *goodsArr = responseDict[@"data"][@"goodsList"];
            if (goodsArr.count > 0) {
                for (NSMutableDictionary *dict in goodsArr) {
                    NSString *activityPrice = [NSString stringWithFormat:@"¥%.2f",[dict[@"activityGoods"][@"activityPrice"] doubleValue]];
                    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:activityPrice];
                    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
                    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(activityPrice.length-3, 3)];
                    [dict setValue:attributeStr forKey:@"attrPrice"];
                    
                    NSInteger activityNum = [dict[@"activityGoods"][@"activityNum"] integerValue];
                    float percent = 1;
                    if (activityNum > 0) {
                        percent = [dict[@"activityGoods"][@"salenum"] floatValue]/activityNum;
                    }
                    [dict setValue:@(percent) forKey:@"progress"];
                    [dict setValue:[NSString stringWithFormat:@"已售%.0f%%",percent*100] forKey:@"percent"];
                }
                [self.dataArr addObjectsFromArray:goodsArr];
            }
            
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无商品" backgroundColor:COLOR_F2F2F2];
        _blankView.topMargin = 90;
    }
    return _blankView;
}

@end
