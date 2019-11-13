//
//  ADLGoodsClassController.m
//  lockboss
//
//  Created by adel on 2019/5/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsClassController.h"
#import "ADLGoodsDetailController.h"
#import "ADLSchemeDetailController.h"

#import "ADLGoodsClassifyCell.h"
#import "ADLSystemGoodsCell.h"
#import "ADLClassifyPullView.h"
#import "ADLImagePreView.h"
#import "ADLSortView.h"
#import "ADLBlankView.h"

@interface ADLGoodsClassController ()<ADLSortViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ADLClassifyPullView *pullView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) ADLSortView *sortView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *classifyId;
@property (nonatomic, strong) NSString *proValueId;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL ascending;
@end

@implementation ADLGoodsClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView:self.className];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    if (self.systemLock) {
        tableView.rowHeight = 100;
    } else {
        tableView.rowHeight = 109;
    }
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        [weakSelf getDataWithIndex:weakSelf.index ascending:weakSelf.ascending brandId:weakSelf.brandId classifyId:weakSelf.classifyId proValueId:weakSelf.proValueId loading:NO];
    }];
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithIndex:weakSelf.index ascending:weakSelf.ascending brandId:weakSelf.brandId classifyId:weakSelf.classifyId proValueId:weakSelf.proValueId loading:NO];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getDataWithIndex:0 ascending:NO brandId:nil classifyId:nil proValueId:nil loading:YES];
}

#pragma mark ------ ADLSortViewDelegate ------
- (void)didClickTitle:(NSInteger)index ascending:(BOOL)ascending {
    self.offset = 0;
    [self getDataWithIndex:index ascending:ascending brandId:self.brandId classifyId:self.classifyId proValueId:self.proValueId loading:YES];
}

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.systemLock) {
        ADLSystemGoodsCell *systemCell = [tableView dequeueReusableCellWithIdentifier:@"SystemGoodsCell"];
        if (systemCell == nil) {
            systemCell = [[NSBundle mainBundle] loadNibNamed:@"ADLSystemGoodsCell" owner:nil options:nil].lastObject;
            systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        [systemCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"thumbnailUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        systemCell.imgUrl = [dict[@"thumbnailUrl"] stringValue];
        systemCell.nameLab.text = dict[@"goodsName"];
        
        NSString *moneyStr = [NSString stringWithFormat:@"¥%.2f",[dict[@"nowPrice"] floatValue]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(moneyStr.length-3, 3)];
        systemCell.moneyLab.attributedText = attributeStr;
        return systemCell;
        
    } else {
        ADLGoodsClassifyCell *classifyCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsClassifyCell"];
        if (classifyCell == nil) {
            classifyCell = [[NSBundle mainBundle] loadNibNamed:@"ADLGoodsClassifyCell" owner:nil options:nil].lastObject;
            classifyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        [classifyCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"thumbnailUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        classifyCell.imgUrl = [dict[@"thumbnailUrl"] stringValue];
        classifyCell.nameLab.text = dict[@"goodsName"];
        
        NSString *moneyStr = [NSString stringWithFormat:@"¥%.2f",[dict[@"nowPrice"] floatValue]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(moneyStr.length-3, 3)];
        classifyCell.moneyLab.attributedText = attributeStr;
        
        classifyCell.detailLab.text = [NSString stringWithFormat:@"%@条评价  %.0f%%好评",dict[@"evaluateCount"],[dict[@"score"] floatValue]*100];
        return classifyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.systemLock) {
        ADLSchemeDetailController *schemeVC = [[ADLSchemeDetailController alloc] init];
        schemeVC.goodsId = self.dataArr[indexPath.row][@"id"];
        [self.navigationController pushViewController:schemeVC animated:YES];
    } else {
        ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
        detailVC.goodsId = self.dataArr[indexPath.row][@"id"];
        detailVC.orderId = self.orderId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark ------ 获取数据 ------
- (void)getDataWithIndex:(NSInteger)index
               ascending:(BOOL)ascending
                 brandId:(NSString *)brandId
              classifyId:(NSString *)classifyId
              proValueId:(NSString *)proValueId
                 loading:(BOOL)loading {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:@"true" forKey:@"needCondition"];
    
    if (brandId) {
        [params setValue:brandId forKey:@"brandId"];
    }
    
    if (classifyId) {
        [params setValue:classifyId forKey:@"classId"];
    } else {
        [params setValue:[NSString stringWithFormat:@"[\"%@\"]",self.classId] forKey:@"classId"];
    }
    
    if (proValueId) {
        [params setValue:proValueId forKey:@"proValueId"];
    }
    
    if (index == 1) {
        [params setValue:@"salenum" forKey:@"orderBy"];
        [params setValue:@"desc" forKey:@"sequence"];
    } else if (index == 2) {
        NSString *orderStr = ascending == YES ? @"asc" : @"desc";
        [params setValue:@"nowPrice" forKey:@"orderBy"];
        [params setValue:orderStr forKey:@"sequence"];
    } else if (index == 3) {
        if (ascending) {
            [params setValue:@"salenum" forKey:@"orderBy"];
            [params setValue:@"asc" forKey:@"sequence"];
        }
    }
    
    if (loading) [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_search_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            if (self.offset == 0) [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"][@"pageInfo"][@"rows"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
            if (resArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
            } else {
                self.tableView.tableFooterView = [UIView new];
            }
            self.offset = self.dataArr.count;
            [self.tableView reloadData];
            
            if (self.sortView != nil) {
                self.index = index;
                self.ascending = ascending;
                [self.sortView updateTitleWithIndex:index ascending:ascending];
            }
            
            if (responseDict[@"data"] && self.pullView == nil) {
                NSMutableArray *itemArr = [[NSMutableArray alloc] init];
                NSArray *brandArr = responseDict[@"data"][@"brandList"];
                if (brandArr.count > 0) {
                    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
                    [dict1 setValue:@"品牌" forKey:@"name"];
                    [dict1 setValue:@"name" forKey:@"key"];
                    [dict1 setValue:brandArr forKey:@"data"];
                    [itemArr addObject:dict1];
                }
                
                NSArray *classArr = responseDict[@"data"][@"classList"];
                if (classArr.count > 0) {
                    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
                    if ([self.classId isEqualToString:@"1"]) {
                        [dict2 setValue:@"配件类型" forKey:@"name"];
                    } else {
                        [dict2 setValue:@"门锁类型" forKey:@"name"];
                    }
                    [dict2 setValue:classArr forKey:@"data"];
                    [dict2 setValue:@"className" forKey:@"key"];
                    [itemArr addObject:dict2];
                }
                
                NSArray *propertyArr = responseDict[@"data"][@"propertyList"];
                if (propertyArr.count > 0) {
                    for (NSDictionary *dict in propertyArr) {
                        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
                        [dict3 setValue:dict[@"propertyName"] forKey:@"name"];
                        [dict3 setValue:dict[@"values"] forKey:@"data"];
                        [dict3 setValue:@"propertyValue" forKey:@"key"];
                        [itemArr addObject:dict3];
                    }
                }
                
                if (itemArr.count > 0) {
                    CGRect frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
                    if (!self.systemLock) {
                        ADLSortView *sortView = [ADLSortView sortViewWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, VIEW_HEIGHT) titles:@[@"综合",@"销量",@"价格",@"评论"]];
                        sortView.delegate = self;
                        sortView.sortArr = @[@(2),@(3)];
                        [self.view addSubview:sortView];
                        self.sortView = sortView;
                        frame.origin.y = NAVIGATION_H+VIEW_HEIGHT;
                        frame.size.height = SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT;
                    }
                    frame.origin.y = frame.origin.y+50.5;
                    frame.size.height = frame.size.height-50.5;
                    self.tableView.frame = frame;
                    
                    __weak typeof(self)weakSelf = self;
                    CGFloat Y = self.systemLock ? (NAVIGATION_H) : (NAVIGATION_H+VIEW_HEIGHT);
                    ADLClassifyPullView *pullView = [ADLClassifyPullView pullViewWithFrameY:Y dataArr:itemArr confirmAction:^(NSString *brandId, NSString *classifyId, NSString *proValueId) {
                        weakSelf.offset = 0;
                        weakSelf.brandId = brandId;
                        weakSelf.classifyId = classifyId;
                        weakSelf.proValueId = proValueId;
                        [weakSelf getDataWithIndex:weakSelf.index ascending:weakSelf.ascending brandId:brandId classifyId:classifyId proValueId:proValueId loading:YES];
                    }];
                    [self.view addSubview:pullView];
                    self.pullView = pullView;
                }
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ blankView ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        NSString *promptStr = [self.classId isEqualToString:@"1"] ? @"暂无配件" : @"暂无商品";
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:promptStr backgroundColor:nil];
    }
    return _blankView;
}

@end
