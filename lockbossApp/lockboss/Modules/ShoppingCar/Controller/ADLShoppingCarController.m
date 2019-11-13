//
//  ADLShoppingCarController.m
//  lockboss
//
//  Created by adel on 2019/3/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLShoppingCarController.h"
#import "ADLGoodsDetailController.h"
#import "ADLSubmitOrderController.h"
#import "ADLAddShipController.h"
#import "ADLTabBarController.h"
#import "ADLStoreController.h"

#import "ADLShoppingCarCell.h"
#import "ADLGoodsAttriView.h"
#import "ADLSelectView.h"
#import "ADLServiceView.h"
#import "ADLBlankView.h"

#import <Masonry.h>

@interface ADLShoppingCarController ()<UITableViewDelegate,UITableViewDataSource,ADLSelectViewDelegate,ADLShoppingCarCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) ADLSelectView *selectView;
@property (nonatomic, strong) ADLBlankView *blankView;
@property (nonatomic, assign) NSInteger addressCount;
@property (nonatomic, strong) NSArray *serviceArr;
@property (nonatomic, assign) NSInteger checkNum;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ADLShoppingCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"购物车"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectArr = [[NSMutableArray alloc] init];
    
    self.addressCount = 0;
    self.checkNum = 0;
    CGFloat bottomOS = -BOTTOM_H;
    if (self.pushString == nil) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.backBtn.hidden = YES;
        bottomOS = 0;
    }
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    __weak typeof(self)weakSelf = self;
    tableView.mj_footer = [ADLRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getShoppingCarList];
    }];
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.offset = 0;
        if ([ADLUserModel sharedModel].login) {
            [weakSelf getShoppingCarList];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
    tableView.mj_footer.hidden = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    ADLSelectView *selectView = [[ADLSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HEIGHT) title:@"结算" buttonH:ROW_HEIGHT];
    selectView.delegate = self;
    selectView.money = @"合计：¥ 0.00";
    selectView.alpha = 0;
    [self.view addSubview:selectView];
    self.selectView = selectView;
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(ROW_HEIGHT));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(bottomOS);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAVIGATION_H);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(selectView.mas_top);
    }];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCarData:) name:REFRESH_SHOPPING_CAR object:nil];
    
    if ([ADLUserModel sharedModel].login) {
        [self getShoppingCarList];
        [self getAddressData];
    } else {
        tableView.tableFooterView = self.blankView;
    }
}

#pragma mark ------ UITableView Delegate && dataSorce ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr[indexPath.row][@"service"]) {
        return 140;
    } else {
        return 114;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCarCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLShoppingCarCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.checkBtn.selected = [dict[@"check"] boolValue];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"imgUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    cell.nameLab.text = dict[@"goodsName"];
    cell.attributeLab.text = [NSString stringWithFormat:@" %@",dict[@"attribute"]];
    if ([dict[@"activityGoods"][@"activityPrice"] doubleValue] > 0) {
        cell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"activityGoods"][@"activityPrice"] doubleValue]];
    } else {
        cell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"newPrice"] doubleValue]];
    }
    
    if (dict[@"service"]) {
        cell.serviceLab.text = dict[@"service"];
        [cell.serviceBtn setTitle:@"修改服务" forState:UIControlStateNormal];
        cell.serviceMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f x%ld",[dict[@"startingPrice"] doubleValue],[dict[@"num"] integerValue]];
    } else {
        [cell.serviceBtn setTitle:@"选择服务" forState:UIControlStateNormal];
        cell.serviceMoneyLab.text = @"";
        cell.serviceLab.text = @"";
    }
    cell.numLab.text = [dict[@"num"] stringValue];
    
    NSInteger limitCount = [dict[@"activityGoods"][@"userBuyNum"] integerValue];
    //    NSInteger inventoryCount = [dict[@"nowNum"] integerValue];
    NSInteger inventoryCount = NSIntegerMax;
    NSInteger currentCount = [dict[@"num"] integerValue];
    if (limitCount > 0) {
        if (limitCount < inventoryCount) {
            inventoryCount = limitCount;
        }
    }
    if (currentCount == inventoryCount) {
        [cell.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    } else {
        [cell.addBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    }
    
    if (currentCount == 1) {
        [cell.reduceBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    } else {
        [cell.reduceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    }
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteShoppingCar:self.dataArr[indexPath.row][@"id"] indexPath:indexPath];
    }];
    deleteAC.backgroundColor = [UIColor redColor];
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *titStr = [dict[@"isCollection"] integerValue] == 1 ? @"移入\n收藏" : @"移出\n收藏";
    UITableViewRowAction *collectAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([titStr hasPrefix:@"移入"]) {
            [self collectionGoods:0 indexPath:indexPath];
        } else {
            [self collectionGoods:1 indexPath:indexPath];
        }
    }];
    collectAC.backgroundColor = COLOR_D3D3D3;
    return @[deleteAC,collectAC];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
    detailVC.goodsId = self.dataArr[indexPath.row][@"goodsId"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 点击属性 ------
- (void)didClickAttributeBtn:(UIButton *)sender {
    ADLShoppingCarCell *cell = (ADLShoppingCarCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:dict[@"goodsId"] forKey:@"goodsId"];
    
    [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
            NSArray *skuArr = responseDict[@"data"][@"skuList"];
            [paramDict setValue:skuArr forKey:@"skuList"];
            [paramDict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
            [paramDict setValue:dict[@"attribute"] forKey:@"select"];
            [paramDict setValue:dict[@"imgUrl"] forKey:@"imageUrl"];
            [paramDict setValue:dict[@"num"] forKey:@"count"];
            [paramDict setValue:@(YES) forKey:@"confirm"];
            [ADLToast hide];
            [ADLGoodsAttriView goodsAttributeViewWith:paramDict confirmAction:^(NSMutableDictionary *selectDict) {
                if (selectDict != nil) {
                    [self updateAttribute:selectDict indexPath:indexPath];
                }
            }];
        }
    } failure:nil];
}

#pragma mark ------ 修改属性 ------
- (void)updateAttribute:(NSDictionary *)selectDict indexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    if (![dict[@"skuId"] isEqualToString:selectDict[@"id"]] || [dict[@"num"] intValue] != [selectDict[@"count"] intValue]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:selectDict[@"id"] forKey:@"newSkuId"];
        [params setValue:selectDict[@"count"] forKey:@"num"];
        [params setValue:dict[@"id"] forKey:@"id"];
        NSArray *serArr = dict[@"services"];
        if (serArr.count > 0) {
            [params setValue:serArr.lastObject[@"id"] forKey:@"services"];
        } else {
            [params setValue:@"" forKey:@"services"];
        }
        [self updateShoppingCar:params finishBlock:^{
            if ([dict[@"check"] boolValue]) {
                [self.selectArr removeObject:dict[@"skuId"]];
                [self.selectArr addObject:selectDict[@"id"]];
            }
            self.offset = 0;
            [self getShoppingCarList];
        }];
    }
}

#pragma mark ------ 点击服务 ------
- (void)didClickServiceBtn:(UIButton *)sender {
    if (self.addressCount == 0) {
        [ADLAlertView showWithTitle:@"提示" message:@"你还没有添加收货地址，是否前去添加？" confirmTitle:nil confirmAction:^{
            ADLAddShipController *shipVC = [[ADLAddShipController alloc] init];
            shipVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shipVC animated:YES];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    } else {
        if (self.serviceArr.count != 0) {
            ADLShoppingCarCell *cell = (ADLShoppingCarCell *)sender.superview.superview;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSMutableDictionary *dict = self.dataArr[indexPath.row];
            NSString *sreviceStr = dict[@"service"];
            if ([sreviceStr hasPrefix:@"选择"]) {
                sreviceStr = nil;
            } else {
                sreviceStr = [sreviceStr substringFromIndex:6];
            }
            [ADLServiceView serviceViewWithServiceArr:self.serviceArr selectStr:sreviceStr confirmAction:^(NSMutableDictionary *selectDict) {
                if (![[dict[@"services"] lastObject][@"id"] isEqualToString:selectDict[@"id"]]) {
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    [params setValue:dict[@"id"] forKey:@"id"];
                    if (selectDict) {
                        [params setValue:dict[@"num"] forKey:@"num"];
                        [params setValue:selectDict[@"id"] forKey:@"services"];
                    } else {
                        [params setValue:@(0) forKey:@"num"];
                        [params setValue:@"" forKey:@"services"];
                    }
                    [self updateShoppingCar:params finishBlock:^{
                        self.offset = 0;
                        [self getShoppingCarList];
                    }];
                }
            }];
        } else {
            [ADLToast showMessage:@"默认收货地区暂无服务"];
        }
    }
}

#pragma mark ------ 点击 加 ------
- (void)didClickAddBtn:(UIButton *)sender count:(NSInteger)count {
    ADLShoppingCarCell *cell = (ADLShoppingCarCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    NSInteger limitCount = [dict[@"activityGoods"][@"userBuyNum"] integerValue];
    //    NSInteger inventoryCount = [dict[@"nowNum"] integerValue];
    NSInteger inventoryCount = NSIntegerMax;
    if (limitCount > 0) {
        if (limitCount < inventoryCount) {
            inventoryCount = limitCount;
        }
    }
    if (count <= inventoryCount) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@(count) forKey:@"num"];
        [params setValue:dict[@"id"] forKey:@"id"];
        
        NSArray *serArr = dict[@"services"];
        if (serArr.count > 0) {
            [params setValue:serArr.lastObject[@"id"] forKey:@"services"];
        } else {
            [params setValue:@"" forKey:@"services"];
        }
        
        [self updateShoppingCar:params finishBlock:^{
            [dict setValue:@(count) forKey:@"num"];
            cell.numLab.text = [NSString stringWithFormat:@"%lu",count];
            [self calculateTotalMoney];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

#pragma mark ------ 点击 减 ------
- (void)didClickReduceBtn:(UIButton *)sender count:(NSInteger)count {
    ADLShoppingCarCell *cell = (ADLShoppingCarCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    if (count > 0) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@(count) forKey:@"num"];
        [params setValue:dict[@"id"] forKey:@"id"];
        
        NSArray *serArr = dict[@"services"];
        if (serArr.count > 0) {
            [params setValue:serArr.lastObject[@"id"] forKey:@"services"];
        } else {
            [params setValue:@"" forKey:@"services"];
        }
        
        [self updateShoppingCar:params finishBlock:^{
            [dict setValue:@(count) forKey:@"num"];
            cell.numLab.text = [NSString stringWithFormat:@"%lu",count];
            [self calculateTotalMoney];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

#pragma mark ------ 修改购物车 ------
- (void)updateShoppingCar:(NSDictionary *)params finishBlock:(void(^)(void))finishBlock {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_modify_car parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            if (finishBlock) {
                finishBlock();
            }
        }
    } failure:nil];
}

#pragma mark ------ 选择 ------
- (void)didClickCheckBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    ADLShoppingCarCell *cell = (ADLShoppingCarCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    [dict setValue:@(sender.selected) forKey:@"check"];
    if (sender.selected) {
        self.checkNum++;
        [self.selectArr addObject:dict[@"skuId"]];
    } else {
        self.checkNum--;
        [self.selectArr removeObject:dict[@"skuId"]];
    }
    if (self.checkNum == self.dataArr.count) {
        self.selectView.selectBtn.selected = YES;
    } else {
        self.selectView.selectBtn.selected = NO;
    }
    [self calculateTotalMoney];
}

#pragma mark ------ 全选 ------
- (void)didClickSelectAllBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.checkNum = self.dataArr.count;
    } else {
        self.checkNum = 0;
    }
    [self.selectArr removeAllObjects];
    for (int i = 0; i < self.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ADLShoppingCarCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.checkBtn.selected = sender.selected;
        NSMutableDictionary *dict = self.dataArr[i];
        [dict setValue:@(sender.selected) forKey:@"check"];
        if (sender.selected) {
            [self.selectArr addObject:dict[@"skuId"]];
        }
    }
    [self calculateTotalMoney];
}

#pragma mark ------ 计算总额 ------
- (void)calculateTotalMoney {
    double money = 0;
    for (NSDictionary *dict in self.dataArr) {
        if ([dict[@"check"] boolValue]) {
            if ([dict[@"activityGoods"][@"activityPrice"] doubleValue] > 0) {
                money = money+[dict[@"activityGoods"][@"activityPrice"] doubleValue]*[dict[@"num"] integerValue];
            } else {
                money = money+[dict[@"newPrice"] doubleValue]*[dict[@"num"] integerValue];
            }
            NSArray *serArr = dict[@"services"];
            if (serArr.count > 0) {
                money = money+[serArr.lastObject[@"startingPrice"] doubleValue]*[dict[@"num"] integerValue];
            }
        }
    }
    self.selectView.money = [NSString stringWithFormat:@"合计：¥ %.2f",money];
}

#pragma mark ------ 结算 ------
- (void)didClickTitleBtn:(UIButton *)sender {
    if (self.checkNum == 0) {
        [ADLToast showMessage:@"请选择要购买的商品"];
    } else {
        NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.dataArr) {
            if ([dict[@"check"] boolValue]) {
                [goodsArr addObject:dict];
            }
        }
        ADLSubmitOrderController *submitVC = [[ADLSubmitOrderController alloc] init];
        submitVC.provinceArr = self.provinceArr;
        submitVC.goodsArr = goodsArr;
        submitVC.shoppingCar = YES;
        if (self.pushString == nil) submitVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:submitVC animated:YES];
    }
}

#pragma mark ------ 刷新购物车通知 ------
- (void)refreshShoppingCarData:(NSNotification *)notification {
    self.offset = 0;
    if ([notification.object isEqualToString:@"login"]) {
        [self getShoppingCarList];
        [self getAddressData];
    } else if ([notification.object isEqualToString:@"address"]) {
        [self getAddressData];
    } else if ([notification.object isEqualToString:@"refresh"]) {
        [self getShoppingCarList];
    } else {
        [self.selectArr removeAllObjects];
        [self.dataArr removeAllObjects];
        self.tableView.tableFooterView = self.blankView;
        [self.tableView reloadData];
        self.selectView.selectBtn.selected = NO;
        self.selectView.money = @"合计：¥ 0.00";
        self.selectView.alpha = 0;
        
        self.count = 0;
        [self updateGoodsCount];
    }
}

#pragma mark ------ 收藏/取消收藏 ------
- (void)collectionGoods:(NSInteger)collect indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.dataArr[indexPath.row][@"goodsId"] forKey:@"goodsId"];
    [params setValue:@(collect) forKey:@"isCollect"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_collect_goods parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:responseDict[@"msg"]];
            NSMutableDictionary *dict = self.dataArr[indexPath.row];
            [dict setValue:@(collect) forKey:@"isCollection"];
        }
    } failure:nil];
}

#pragma mark ------ 删除购物车 ------
- (void)deleteShoppingCar:(NSString *)ids indexPath:(NSIndexPath *)indexPath {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:ids forKey:@"ids"];
    [ADLNetWorkManager postWithPath:k_delete_car parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([self.dataArr[indexPath.row][@"check"] integerValue] == 1) {
                self.checkNum--;
                [self.selectArr removeObject:self.dataArr[indexPath.row][@"skuId"]];
            }
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [ADLToast showMessage:@"删除成功"];
            if (self.dataArr.count == 0) {
                self.offset = 0;
                [self getShoppingCarList];
            } else {
                if (self.checkNum == self.dataArr.count) {
                    self.selectView.selectBtn.selected = YES;
                } else {
                    self.selectView.selectBtn.selected = NO;
                }
                [self calculateTotalMoney];
            }
            
            self.count--;
            [self updateGoodsCount];
        }
    } failure:nil];
}

#pragma mark ------ 获取购物车数据 ------
- (void)getShoppingCarList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.offset) forKey:@"offset"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    
    [ADLNetWorkManager postWithPath:k_query_car_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if (self.offset == 0) {
            self.checkNum = 0;
            [self.dataArr removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *listArr = responseDict[@"data"][@"rows"];
            if (listArr.count == 0) {
                if (self.offset == 0) {
                    self.selectView.alpha = 0;
                    [self.selectArr removeAllObjects];
                    self.selectView.money = @"合计：¥ 0.00";
                    self.selectView.selectBtn.selected = NO;
                }
            } else {
                for (NSMutableDictionary *dict in listArr) {
                    if ([self.selectArr containsObject:dict[@"skuId"]]) {
                        [dict setValue:@(1) forKey:@"check"];
                        self.checkNum++;
                    } else {
                        [dict setValue:@(0) forKey:@"check"];
                    }
                    
                    NSMutableString *proStr = [NSMutableString string];
                    NSArray *proArr = dict[@"propertyValues"];
                    for (NSDictionary *proDict in proArr) {
                        [proStr appendString:@", "];
                        [proStr appendString:proDict[@"propertyValue"]];
                    }
                    if (proStr.length > 2) {
                        [dict setValue:[proStr substringFromIndex:2] forKey:@"attribute"];
                    }
                    
                    NSArray *serviceArr = dict[@"services"];
                    if (serviceArr.count > 0) {
                        [dict setValue:[NSString stringWithFormat:@"服务    %@",serviceArr.lastObject[@"name"]] forKey:@"service"];
                        [dict setValue:serviceArr.lastObject[@"startingPrice"] forKey:@"startingPrice"];
                    }
                    [self.dataArr addObject:dict];
                }
            }
            
            if (listArr.count < self.pageSize) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        
        if (self.dataArr.count == 0) {
            self.tableView.tableFooterView = self.blankView;
        } else {
            if (self.offset == 0) {
                self.selectView.alpha = 1;
                self.tableView.tableFooterView = [UIView new];
            }
        }
        
        if (self.checkNum == self.dataArr.count) {
            self.selectView.selectBtn.selected = YES;
        } else {
            self.selectView.selectBtn.selected = NO;
        }
        
        self.offset = self.dataArr.count;
        [self calculateTotalMoney];
        [self.tableView reloadData];
        
        self.count = [responseDict[@"data"][@"total"] integerValue];
        [self updateGoodsCount];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ------ 收货地址 ------
- (void)getAddressData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_address_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *addressArr = responseDict[@"data"];
            if (addressArr.count > 0) {
                NSString *areaId = nil;
                for (NSDictionary *dict in addressArr) {
                    if ([dict[@"isDefault"] integerValue] == 0) {
                        areaId = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[dict[@"areaId"] stringValue]].cityId;
                        break;
                    }
                }
                if (areaId.length < 2) {
                    areaId = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[addressArr.firstObject[@"areaId"] stringValue]].cityId;
                }
                
                self.addressCount = addressArr.count;
                if (![areaId isEqualToString:self.areaId]) {
                    self.serviceArr = nil;
                    self.areaId = areaId;
                    [self getLockServiceData:areaId];
                }
            } else {
                self.addressCount = 0;
                self.serviceArr = nil;
            }
        } else {
            self.addressCount = 1;
            self.serviceArr = nil;
        }
    } failure:^(NSError *error) {
        self.addressCount = 1;
        self.serviceArr = nil;
    }];
}

#pragma mark ------ 获取服务信息 ------
- (void)getLockServiceData:(NSString *)areaId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:areaId forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_install_lock_cost parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseDict[@"code"] integerValue] == 10000) {
                self.serviceArr = responseDict[@"data"];
            }
        });
    } failure:nil];
}

#pragma mark ------ 更新商品数量 ------
- (void)updateGoodsCount {
    ADLTabBarController *tabbarVC = (ADLTabBarController *)self.navigationController.tabBarController;
    tabbarVC.num = self.count;
}

#pragma mark ------ 购物车为空视图 ------
- (ADLBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [ADLBlankView blankViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360) imageName:@"shopping_car" prompt:@"购物车还是空空如也" backgroundColor:nil];
        _blankView.actionBtn.hidden = NO;
        [_blankView.actionBtn setTitle:@"去逛逛吧" forState:UIControlStateNormal];
        __weak typeof(self)weakSelf = self;
        _blankView.clickActionBtn = ^{
            if (weakSelf.pushString == nil) {
                [weakSelf.tabBarController setSelectedIndex:1];
            } else {
                ADLStoreController *storeVC = [[ADLStoreController alloc] init];
                storeVC.push = YES;
                [weakSelf.navigationController pushViewController:storeVC animated:YES];
            }
        };
    }
    return _blankView;
}

@end
