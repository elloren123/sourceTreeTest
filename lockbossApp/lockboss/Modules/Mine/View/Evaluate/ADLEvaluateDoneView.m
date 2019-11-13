//
//  ADLEvaluateDoneView.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEvaluateDoneView.h"
#import "ADLEvaluateGoodsCell.h"
#import "ADLRefreshHeader.h"
#import "ADLRefreshFooter.h"
#import "ADLBlankView.h"

#import "ADLNetWorkManager.h"
#import "ADLGlobalDefine.h"
#import "ADLUserModel.h"
#import "ADLApiDefine.h"

#import <UIImageView+WebCache.h>

@interface ADLEvaluateDoneView ()<UITableViewDelegate,UITableViewDataSource,ADLEvaluateGoodsCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NSMutableArray *serviceArr;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation ADLEvaluateDoneView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initView {
    self.offset = 0;
    self.dataArr = [[NSMutableArray alloc] init];
    self.goodsArr = [[NSMutableArray alloc] init];
    self.serviceArr = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 114;
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf loadData];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self addSubview:tableView];
    self.tableView = tableView;
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLEvaluateGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateGoodsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLEvaluateGoodsCell" owner:nil options:nil].lastObject;
        [cell.evaluateBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [cell.evaluateBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        cell.evaluateBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    if (dict[@"goodsId"]) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        cell.nameLab.text = dict[@"goodsName"];
        
    } else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"serviceImgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        cell.nameLab.text = dict[@"serviceName"];
    }
    cell.countLab.text = [NSString stringWithFormat:@"%@人评价",dict[@"evaluateNum"]];
    return cell;
}

#pragma mark ------ 评价 ------
- (void)didClickEvaluateBtn:(UIButton *)sender {
    ADLEvaluateGoodsCell *cell = (ADLEvaluateGoodsCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (self.clickLookEvaluate) {
        self.clickLookEvaluate(self.dataArr[indexPath.row]);
    }
}

#pragma mark ------ 更新列表 ------
- (void)updateList {
    self.offset = 0;
    [self loadData];
}

#pragma mark ------ 加载数据 ------
- (void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(10) forKey:@"pageSize"];
    [params setValue:@(1) forKey:@"status"];
    [ADLNetWorkManager postWithPath:k_goods_my_evaluate_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *goodsArr = responseDict[@"data"][@"rows"][@"evaluateListVOS"];
            NSArray *serArr = responseDict[@"data"][@"rows"][@"serviceEvaluateListVOS"];
            if (self.offset == 0) {
                [self.goodsArr removeAllObjects];
                [self.serviceArr removeAllObjects];
                [self.dataArr removeAllObjects];
            }
            if (goodsArr.count > 0) {
                [self.goodsArr addObjectsFromArray:goodsArr];
                [self.dataArr addObjectsFromArray:goodsArr];
            }
            if (serArr.count > 0) {
                [self.serviceArr addObjectsFromArray:serArr];
                [self.dataArr addObjectsFromArray:serArr];
            }
            
            if (goodsArr.count < 10 && serArr.count < 10) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            self.offset = self.goodsArr.count > self.serviceArr.count ? self.goodsArr.count : self.serviceArr.count;
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
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT) imageName:nil prompt:@"暂无已评价商品或服务" backgroundColor:COLOR_F2F2F2];
    }
    return _blankView;
}

@end
