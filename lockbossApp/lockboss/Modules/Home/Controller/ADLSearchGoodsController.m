//
//  ADLSearchGoodsController.m
//  lockboss
//
//  Created by adel on 2019/3/29.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSearchGoodsController.h"
#import "ADLGoodsDetailController.h"
#import "ADLSearchGoodsCell.h"
#import "ADLSearchView.h"

@interface ADLSearchGoodsController ()<ADLSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (nonatomic, strong) ADLSearchView *searchView;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *rowHArr;
@end

@implementation ADLSearchGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADLSearchView *searchView = [[ADLSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H) placeholder:@"请输入您要的商品名称" instant:YES];
    searchView.done = NO;
    searchView.delegate = self;
    searchView.divisionView.hidden = YES;
    [self.view addSubview:searchView];
    self.searchView = searchView;
    
    self.rowHArr = [[NSMutableArray alloc] init];
    NSArray *hisArr = [NSArray arrayWithContentsOfFile:[ADLUtils filePathWithName:GOODS_SEARCH_HISTORY permanent:NO]];
    if (hisArr == nil) {
        self.historyArr = [[NSMutableArray alloc] init];
    } else {
        self.historyArr = [[NSMutableArray alloc] initWithArray:hisArr];
        [self.dataArr addObjectsFromArray:hisArr];
        for (int i = 0; i < hisArr.count; i++) {
            [self.rowHArr addObject:@(ROW_HEIGHT)];
        }
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+8, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-8)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_F2F2F2;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (self.historyArr.count > 0) {
        tableView.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.dataArr.count != 0) {
        tableView.tableHeaderView = self.headView;
        tableView.tableFooterView = self.footView;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark ------ UITableViewDelegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowHArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLSearchGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
    if (cell == nil) {
        cell = [[ADLSearchGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
    }
    if (tableView.tableHeaderView == nil) {
        cell.titLab.text = self.dataArr[indexPath.row][@"goodsName"];
    } else {
        cell.titLab.text = self.dataArr[indexPath.row];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tableHeaderView == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.historyArr removeObjectAtIndex:indexPath.row];
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [ADLUtils saveObject:self.historyArr fileName:GOODS_SEARCH_HISTORY permanent:NO];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.dataArr.count == 0) {
            tableView.tableHeaderView = nil;
            tableView.tableFooterView = [UIView new];
            tableView.backgroundColor = COLOR_F2F2F2;
        }
        [tableView reloadData];
    }];
    delete.backgroundColor = [UIColor redColor];
    NSArray *arr = @[delete];
    return arr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tableHeaderView != nil) {
        [self.view endEditing:YES];
        [self.rowHArr removeAllObjects];
        [self.dataArr removeAllObjects];
        
        ADLSearchGoodsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.searchView.textField.text = cell.titLab.text;
        self.text = cell.titLab.text;
        
        [self.historyArr removeObject:cell.titLab.text];
        [self.historyArr insertObject:cell.titLab.text atIndex:0];
        [ADLUtils saveObject:self.historyArr fileName:GOODS_SEARCH_HISTORY permanent:NO];
        
        tableView.tableHeaderView = nil;
        tableView.tableFooterView = [UIView new];
        [tableView reloadData];
        
        self.offset = 0;
        [self loadData];
    } else {
        ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
        detailVC.goodsId = self.dataArr[indexPath.row][@"id"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ------ 手势代理 ------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark ------ 清除历史记录 ------
- (void)clickClearHistory {
    [ADLAlertView showWithTitle:@"提示" message:@"确定要清空搜索记录吗？" confirmTitle:nil confirmAction:^{
        [ADLUtils removeObjectWithFileName:GOODS_SEARCH_HISTORY permanent:NO];
        [self.historyArr removeAllObjects];
        [self.rowHArr removeAllObjects];
        [self.dataArr removeAllObjects];
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = COLOR_F2F2F2;
        [self.tableView reloadData];
    } cancleTitle:nil cancleAction:nil showCancle:YES];
}

#pragma mark ------ ADLSearchViewDelegate ------
- (void)didClickCancleButton {
    [self customPopViewController];
}

- (void)didClickSearchButton:(UITextField *)textField {
    NSString *text = textField.text;
    if ([text isEqualToString:@""]) {
        [ADLToast showMessage:@"请输入您要的商品名称"];
        return;
    }
    if ([ADLUtils hasEmoji:text]) {
        [ADLToast showMessage:@"请不要输入表情和特殊符号"];
        return;
    }
    
    if ([self.historyArr containsObject:text]) {
        [self.historyArr removeObject:text];
    }
    [self.historyArr insertObject:text atIndex:0];
    [ADLUtils saveObject:self.historyArr fileName:GOODS_SEARCH_HISTORY permanent:NO];
    
    if (self.tableView.tableHeaderView != nil) {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = [UIView new];
    }
    
    [textField resignFirstResponder];
    self.offset = 0;
    self.text = text;
    [self loadData];
}

- (void)textFieldTextDidChanged:(NSString *)text {
    if ([text isEqualToString:@""] && self.historyArr.count > 0) {
        [self.dataArr removeAllObjects];
        [self.rowHArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.historyArr];
        for (int i = 0; i < self.historyArr.count; i++) {
            [self.rowHArr addObject:@(ROW_HEIGHT)];
        }
        self.tableView.tableHeaderView = self.headView;
        self.tableView.tableFooterView = self.footView;
        self.tableView.mj_footer.hidden = YES;
        if (self.dataArr.count == 0) {
            self.tableView.backgroundColor = COLOR_F2F2F2;
        } else {
            self.tableView.backgroundColor = [UIColor whiteColor];
        }
        [self.tableView reloadData];
    }
}

#pragma mark ------ 搜索数据 ------
- (void)loadData {
    if (self.offset == 0) {
        [self.dataArr removeAllObjects];
        [self.rowHArr removeAllObjects];
        [ADLToast showLoadingMessage:@"搜索中..."];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:self.text forKey:@"goodsName"];
    [params setValue:@"false" forKey:@"needCondition"];
    
    [ADLNetWorkManager postWithPath:k_search_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"][@"pageInfo"][@"rows"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
                for (NSDictionary *dict in resArr) {
                    NSString *str = [dict[@"goodsName"] stringValue];
                    CGFloat strH = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size.height+20;
                    if (strH < ROW_HEIGHT) {
                        strH = ROW_HEIGHT;
                    }
                    [self.rowHArr addObject:@(strH)];
                }
                [self.tableView.mj_footer endRefreshing];
                if (resArr.count < self.pageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [ADLToast hide];
            } else {
                if (self.offset == 0) {
                    [ADLToast showMessage:@"没有搜索到商品"];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            self.offset = self.dataArr.count;
            if (self.dataArr.count >= self.pageSize) {
                self.tableView.mj_footer.hidden = NO;
            } else {
                self.tableView.mj_footer.hidden = YES;
            }
        }
        if (self.dataArr.count > 0) {
            self.tableView.backgroundColor = [UIColor whiteColor];
        } else {
            self.tableView.backgroundColor = COLOR_F2F2F2;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 退出键盘 ------
- (void)exitKeyboard {
    [self.view endEditing:YES];
}

#pragma mark ------ 懒加载 ------
- (UIView *)headView {
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, VIEW_HEIGHT)];
        label.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        label.textColor = COLOR_333333;
        label.text = @"历史搜索";
        [_headView addSubview:label];
    }
    return _headView;
}

- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, ROW_HEIGHT*2)];
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-FONT_SIZE*11)/2, 28, FONT_SIZE*11, ROW_HEIGHT)];
        clearBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
        clearBtn.layer.borderWidth = 0.5;
        clearBtn.layer.cornerRadius = CORNER_RADIUS;
        clearBtn.titleLabel.font= [UIFont systemFontOfSize:FONT_SIZE];
        [clearBtn setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
        [clearBtn setTitle:@"  清空历史搜索" forState:UIControlStateNormal];
        [clearBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clickClearHistory) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:clearBtn];
    }
    return _footView;
}

@end
