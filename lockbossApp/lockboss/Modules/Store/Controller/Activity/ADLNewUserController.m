//
//  ADLNewUserController.m
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNewUserController.h"
#import "ADLGoodsDetailController.h"
#import "ADLWebViewController.h"
#import "ADLNewUserGoodsCell.h"
#import "ADLGoodsAttriView.h"
#import "ADLNewUserView.h"
#import "ADLBannerView.h"
#import "ADLBlankView.h"
#import "ADLSortView.h"

@interface ADLNewUserController ()<ADLSortViewDelegate,ADLNewUserGoodsCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLBannerView *bannerView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ADLSortView *sortView;
@property (nonatomic, assign) BOOL oldUser;
@end

@implementation ADLNewUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"新用户专享"];
    
    self.oldUser = YES;
    ADLBannerView *bannerView = [[ADLBannerView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_WIDTH*0.4) position:ADLPagePositionCenetr style:ADLPageStyleRound];
    [self.view addSubview:bannerView];
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
    
    ADLSortView *sortView = [ADLSortView sortViewWithFrame:CGRectMake(0, NAVIGATION_H+SCREEN_WIDTH*0.4, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"销量优先",@"价格排序"]];
    sortView.sortArr = @[@(1)];
    sortView.delegate = self;
    [self.view addSubview:sortView];
    self.sortView = sortView;
    sortView.hidden = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+SCREEN_WIDTH*0.4+VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-SCREEN_WIDTH*0.4-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 114;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getDataWithIndex:0 ascending:NO];
    if ([ADLUserModel sharedModel].login) {
        [self getNewUserCoupon];
    }
}

#pragma mark ------ 排序 ------
- (void)didClickTitle:(NSInteger)index ascending:(BOOL)ascending {
    [self getDataWithIndex:index ascending:ascending];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLNewUserGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newUserGoodsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLNewUserGoodsCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.nameLab.text = dict[@"goodsName"];
    cell.monLab.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"price"] floatValue]];
    NSString *moneyStr = [NSString stringWithFormat:@"¥%.2f",[dict[@"nowPrice"] floatValue]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(moneyStr.length-3, 3)];
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
        if (self.oldUser) {
            [ADLAlertView showWithTitle:nil message:@"该商品为新用户专享优惠商品，您已经是老朋友啦！返回首页，看看其他优惠吧！" confirmTitle:nil confirmAction:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        } else {
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            ADLNewUserGoodsCell *cell = (ADLNewUserGoodsCell *)sender.superview.superview;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSDictionary *dict = self.dataArr[indexPath.row];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
            [params setValue:self.dataArr[indexPath.row][@"id"] forKey:@"goodsId"];
            [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc] init];
                    NSArray *skuArr = responseDict[@"data"][@"skuList"];
                    [attrDict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
                    [attrDict setValue:dict[@"imgUrl"] forKey:@"imageUrl"];
                    [attrDict setValue:skuArr forKey:@"skuList"];
                    [ADLToast hide];
                    [ADLGoodsAttriView goodsAttributeViewWith:attrDict confirmAction:nil];
                }
            } failure:nil];
        }
    } else {
        [ADLAlertView showWithTitle:ADLString(@"friendly_tips") message:@"您未登录，请先登录？" confirmTitle:nil confirmAction:^{
            [self pushLoginViewControllerHideTabbar:NO success:^{
                [self getNewUserCoupon];
            }];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 获取新人专享优惠券 ------
- (void)getNewUserCoupon {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_new_user_coupon parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                NSMutableArray *dataArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in resArr) {
                    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    [muDict setValue:@(1) forKey:@"enable"];
                    [dataArr addObject:muDict];
                }
                [ADLNewUserView nerUserViewWithArr:dataArr];
            }
        }
    } failure:nil];
}

#pragma mark ------ getData ------
- (void)getDataWithIndex:(NSInteger)index ascending:(BOOL)ascending {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:@(2) forKey:@"type"];
    NSString *typeStr = index == 1 ? @"nowPrice" : @"salenum";
    NSString *orderStr = ascending == YES ? @"asc" : @"desc";
    [params setValue:typeStr forKey:@"orderBy"];
    [params setValue:orderStr forKey:@"sequence"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_query_activity_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            [ADLToast hide];
            self.oldUser = [[responseDict[@"data"][@"activityInfo"] firstObject][@"newUser"] boolValue];
            NSArray *banArr = responseDict[@"data"][@"bannerList"];
            [self.bannerView updateBanner:banArr imgKey:nil urlKey:nil];
            
            NSArray *goodsArr = responseDict[@"data"][@"goodsList"];
            if (goodsArr.count > 0) {
                [self.dataArr addObjectsFromArray:goodsArr];
            }
            if (self.dataArr.count == 0) {
                self.sortView.hidden = YES;
                self.tableView.frame = CGRectMake(0, NAVIGATION_H+SCREEN_WIDTH*0.4, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-SCREEN_WIDTH*0.4);
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.sortView.hidden = NO;
                self.tableView.tableFooterView = [UIView new];
            }
            [self.tableView reloadData];
            [self.sortView updateTitleWithIndex:index ascending:ascending];
        }
    } failure:nil];
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
