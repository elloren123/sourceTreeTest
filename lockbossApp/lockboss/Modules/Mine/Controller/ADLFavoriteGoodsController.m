//
//  ADLFavoriteGoodsController.m
//  lockboss
//
//  Created by Han on 2019/5/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFavoriteGoodsController.h"
#import "ADLGoodsDetailController.h"
#import "ADLFavoriteGoodsCell.h"
#import "ADLGoodsAttriView.h"
#import "ADLSelectView.h"
#import "ADLBlankView.h"

@interface ADLFavoriteGoodsController ()<UITableViewDelegate,UITableViewDataSource,ADLFavoriteGoodsCellDelegate,ADLSelectViewDelegate>
@property (nonatomic, strong) ADLSelectView *selectView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, assign) NSInteger checkNum;
@end

@implementation ADLFavoriteGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"喜欢的商品"];
    self.manageBtn = [self addRightButtonWithTitle:@"管理" action:@selector(clickManagerBtn:)];
    [self.manageBtn setTitle:@"完成" forState:UIControlStateSelected];
    self.manageBtn.hidden = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 114;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getFavoriteData];
    }];
    
    ADLSelectView *selectView = [[ADLSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-ROW_HEIGHT-BOTTOM_H, SCREEN_WIDTH, ROW_HEIGHT+BOTTOM_H) title:@"删除" buttonH:ROW_HEIGHT];
    selectView.delegate = self;
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    self.selectView = selectView;
    self.checkNum = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getFavoriteData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLFavoriteGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteGoodsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLFavoriteGoodsCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"goodsImgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.collectLab.text = [NSString stringWithFormat:@"%@人收藏",dict[@"collectionCount"]];
    cell.checkBtn.selected = [dict[@"check"] boolValue];
    cell.titleLab.text = dict[@"goodsName"];
    if ([dict[@"isShelves"] integerValue] == 1) {
        cell.moneyLab.text = dict[@"priceRange"];
        cell.moneyLab.textColor = APP_COLOR;
        cell.carBtn.backgroundColor = APP_COLOR;
        cell.carBtn.selected = NO;
    } else {
        cell.moneyLab.text = @"已失效";
        cell.moneyLab.textColor = COLOR_999999;
        cell.carBtn.backgroundColor = SEPARATOR_COLOR;
        cell.carBtn.selected = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLFavoriteGoodsCell *goodsCell = (ADLFavoriteGoodsCell *)cell;
    if (self.manageBtn.selected) {
        goodsCell.labRight.constant = 29;
        goodsCell.carBtn.hidden = YES;
        goodsCell.conView.transform = CGAffineTransformMakeTranslation(29, 0);
    } else {
        goodsCell.labRight.constant = 0;
        goodsCell.carBtn.hidden = NO;
        goodsCell.conView.transform = CGAffineTransformIdentity;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.manageBtn.selected) {
        ADLFavoriteGoodsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.checkBtn.selected = !cell.checkBtn.selected;
        [self setSelectedBtn:cell.checkBtn];
    } else {
        NSDictionary *dict = self.dataArr[indexPath.row];
        if ([dict[@"isShelves"] integerValue] == 1) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.goodsId = dict[@"goodsId"];
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            [ADLAlertView showWithTitle:@"提示" message:@"该商品已失效，是否删除？" confirmTitle:nil confirmAction:^{
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
                [params setValue:dict[@"goodsId"] forKey:@"goodsId"];
                [params setValue:@(1) forKey:@"isCollect"];
                [ADLToast showLoadingMessage:ADLString(@"loading")];
                [ADLNetWorkManager postWithPath:k_collect_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                    if ([responseDict[@"code"] integerValue] == 10000) {
                        [ADLToast showMessage:@"删除成功"];
                        [self.dataArr removeObjectAtIndex:indexPath.row];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        if (self.dataArr.count == 0) {
                            self.tableView.tableFooterView = self.blankView;
                        }
                    }
                } failure:nil];
                
            } cancleTitle:nil cancleAction:nil showCancle:YES];
        }
    }
}

#pragma mark ------ 选中 ------
- (void)didClickCheckBtn:(UIButton *)sender {
    [self setSelectedBtn:sender];
}

#pragma mark ------ 计算选中数量 ------
- (void)setSelectedBtn:(UIButton *)sender {
    ADLFavoriteGoodsCell *cell = (ADLFavoriteGoodsCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    [dict setValue:@(sender.selected) forKey:@"check"];
    if (sender.selected) {
        self.checkNum++;
    } else {
        self.checkNum--;
    }
    if (self.checkNum == self.dataArr.count) {
        self.selectView.selectBtn.selected = YES;
    } else {
        self.selectView.selectBtn.selected = NO;
    }
}

#pragma mark ------ 管理 ------
- (void)clickManagerBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSArray *visibleArr = self.tableView.visibleCells;
    if (sender.selected) {
        self.selectView.hidden = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom+ROW_HEIGHT, 0);
        for (int i = 0; i < self.dataArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ADLFavoriteGoodsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.carBtn.userInteractionEnabled = NO;
            if ([visibleArr containsObject:cell]) {
                cell.conView.transform = CGAffineTransformMakeTranslation(29, 0);
                cell.labRight.constant = 29;
                cell.carBtn.hidden = YES;
            }
        }
    } else {
        self.checkNum = 0;
        self.selectView.hidden = YES;
        self.selectView.selectBtn.selected = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom-ROW_HEIGHT, 0);
        for (int i = 0; i < self.dataArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ADLFavoriteGoodsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.carBtn.userInteractionEnabled = YES;
            NSMutableDictionary *dict = self.dataArr[i];
            [dict setValue:@(0) forKey:@"check"];
            if ([visibleArr containsObject:cell]) {
                cell.conView.transform = CGAffineTransformIdentity;
                cell.checkBtn.selected = NO;
                cell.labRight.constant = 0;
                cell.carBtn.hidden = NO;
            }
        }
    }
}

#pragma mark ------ 全选 ------
- (void)didClickSelectAllBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.checkNum = self.dataArr.count;
    } else {
        self.checkNum = 0;
    }
    for (int i = 0; i < self.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ADLFavoriteGoodsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.checkBtn.selected = sender.selected;
        NSMutableDictionary *dict = self.dataArr[i];
        [dict setValue:@(sender.selected) forKey:@"check"];
    }
}

#pragma mark ------ 删除 ------
- (void)didClickTitleBtn:(UIButton *)sender {
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    NSMutableArray *deleteArr = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        NSMutableDictionary *dict = self.dataArr[i];
        if ([dict[@"check"] boolValue]) {
            [deleteArr addObject:dict];
            [muArr addObject:dict[@"goodsId"]];
            [indexPathArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    if (muArr.count == 0) {
        [ADLToast showMessage:@"请选择要删除的商品"];
        return;
    }
    
    NSString *paraStr = [muArr componentsJoinedByString:@","];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:paraStr forKey:@"goodsId"];
    [params setValue:@(1) forKey:@"isCollect"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_collect_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.selectView.selectBtn.selected = NO;
            self.checkNum = 0;
            [ADLToast showMessage:@"删除成功"];
            [self.dataArr removeObjectsInArray:deleteArr];
            [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
            if (self.dataArr.count == 0) {
                self.selectView.hidden = YES;
                self.manageBtn.selected = NO;
                self.manageBtn.hidden = YES;
                self.tableView.tableFooterView = self.blankView;
            }
        }
    } failure:nil];
}

#pragma mark ------ 加入购物车 ------
- (void)didClickShoppingCarBtn:(UIButton *)sender {
    if (!sender.selected) {
        ADLFavoriteGoodsCell *cell = (ADLFavoriteGoodsCell *)sender.superview.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:self.dataArr[indexPath.row][@"goodsId"] forKey:@"goodsId"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                NSArray *skuArr = responseDict[@"data"][@"skuList"];
                [dict setValue:skuArr forKey:@"skuList"];
                [dict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
                [dict setValue:self.dataArr[indexPath.row][@"goodsImgUrl"] forKey:@"imageUrl"];
                [ADLToast hide];
                [ADLGoodsAttriView goodsAttributeViewWith:dict confirmAction:nil];
            }
        } failure:nil];
    }
}

#pragma mark ------ 获取数据 ------
- (void)getFavoriteData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_goods_collection parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    NSArray *priceArr = [dict[@"priceRange"] componentsSeparatedByString:@"-"];
                    if (priceArr.count == 2) {
                        if ([priceArr[0] isEqualToString:priceArr[1]]) {
                            [dict setValue:[NSString stringWithFormat:@"%.2f",[priceArr[0] doubleValue]] forKey:@"priceRange"];
                        } else {
                            [dict setValue:[NSString stringWithFormat:@"%.2f - %.2f",[priceArr[0] doubleValue],[priceArr[1] doubleValue]] forKey:@"priceRange"];
                        }
                    }
                    [dict setValue:@(0) forKey:@"check"];
                    [self.dataArr addObject:dict];
                }
            }
            
            if (self.dataArr.count == 0) {
                self.tableView.tableFooterView = self.blankView;
                self.manageBtn.hidden = YES;
            } else {
                self.tableView.tableFooterView = [UIView new];
                self.manageBtn.hidden = NO;
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
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) imageName:nil prompt:@"暂无喜欢的商品" backgroundColor:nil];
    }
    return _blankView;
}

@end
