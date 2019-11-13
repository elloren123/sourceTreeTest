//
//  ADLSubmitOrderController.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSubmitOrderController.h"
#import "ADLSelectCouponController.h"
#import "ADLGoodsDetailController.h"
#import "ADLShipAddressController.h"
#import "ADLInvoiceInfController.h"
#import "ADLAddShipController.h"
#import "ADLOrderPayController.h"

#import "ADLOrderAddressView.h"
#import "ADLSubmitOrderCell.h"
#import "ADLSettingViewCell.h"
#import "ADLMoneyTextCell.h"
#import "ADLTextFieldCell.h"
#import "ADLImagePreView.h"
#import "ADLServiceView.h"
#import "ADLGoodsAttriView.h"
#import "ADLKeyboardMonitor.h"

#import <Masonry.h>

@interface ADLSubmitOrderController ()<UITableViewDelegate,UITableViewDataSource,ADLSubmitOrderCellDelegate,ADLTextFieldCellDelegate>
@property (nonatomic, strong) ADLOrderAddressView *addressView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *serviceArr;
@property (nonatomic, strong) UILabel *moneyLab;

@property (nonatomic, strong) NSDictionary *addressDict;
@property (nonatomic, strong) NSDictionary *expressDict;
@property (nonatomic, strong) NSDictionary *couponDict;
@property (nonatomic, strong) NSMutableArray *moneyArr;

@property (nonatomic, strong) NSString *remarkStr;
@property (nonatomic, strong) NSString *invoiceStr;
@property (nonatomic, strong) NSString *invoiceId;

@property (nonatomic, assign) double payMoney;
@property (nonatomic, assign) double totalMoney;
@property (nonatomic, assign) double serviceMoney;
@property (nonatomic, assign) double expressMoney;

@end

@implementation ADLSubmitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView:@"填写订单"];
    self.invoiceStr = @"请选择发票";
    
    self.totalMoney = 0;
    self.serviceMoney = 0;
    self.expressMoney = 0;
    self.moneyArr = [[NSMutableArray alloc] init];
    self.couponDict = @{@"name":@"请选择优惠券",@"amount":@"0"};
    self.dataArr = [ADLUtils realDeepCopyWithObject:self.goodsArr];
    
    ADLOrderAddressView *addressView = [[NSBundle mainBundle] loadNibNamed:@"ADLOrderAddressView" owner:nil options:nil].lastObject;
    addressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    self.addressView = addressView;
    
    __weak typeof(self)weakSelf = self;
    addressView.clickAddress = ^(BOOL addAddress) {
        if (addAddress) {
            ADLAddShipController *addressVC = [[ADLAddShipController alloc] init];
            addressVC.provinceArr = weakSelf.provinceArr;
            addressVC.finish = ^(NSDictionary *addressDict) {
                if (addressDict) {
                    weakSelf.addressDict = addressDict;
                    weakSelf.addressView.nameLab.hidden = NO;
                    weakSelf.addressView.addressLab.hidden = NO;
                    [weakSelf.addressView.addBtn setTitle:@" " forState:UIControlStateNormal];
                    weakSelf.addressView.nameLab.text = [NSString stringWithFormat:@"%@  %@",addressDict[@"consignee"],addressDict[@"phone"]];
                    weakSelf.addressView.addressLab.text = [[addressDict[@"areaStr"] stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [weakSelf getLockServiceData:addressDict[@"cityId"]];
                    [weakSelf getGoodsFee];
                }
            };
            [weakSelf.navigationController pushViewController:addressVC animated:YES];
        } else {
            ADLShipAddressController *shipVC = [[ADLShipAddressController alloc] init];
            shipVC.clickAddress = ^(NSDictionary *addressDict) {
                if (addressDict) {
                    if (![weakSelf.addressDict[@"cityId"] isEqualToString:addressDict[@"cityId"]]) {
                        [weakSelf removeGoodsService];
                        [weakSelf getLockServiceData:addressDict[@"cityId"]];
                        [weakSelf getGoodsFee];
                    }
                    weakSelf.addressDict = addressDict;
                    weakSelf.addressView.nameLab.text = [NSString stringWithFormat:@"%@  %@",addressDict[@"consignee"],addressDict[@"phone"]];
                    weakSelf.addressView.addressLab.text = [[addressDict[@"areaStr"] stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
            };
            [weakSelf.navigationController pushViewController:shipVC animated:YES];
        }
    };
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 18)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-ROW_HEIGHT-BOTTOM_H) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = footerView;
    tableView.tableHeaderView = addressView;
    tableView.estimatedRowHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-BOTTOM_H);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(ROW_HEIGHT));
    }];
    
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-132, ROW_HEIGHT)];
    moneyLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    moneyLab.textColor = COLOR_333333;
    moneyLab.text = @"应付金额：";
    [bottomView addSubview:moneyLab];
    self.moneyLab = moneyLab;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(SCREEN_WIDTH-120, 0, 120, ROW_HEIGHT);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = APP_COLOR;
    [bottomView addSubview:submitBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = SEPARATOR_COLOR;
    [bottomView addSubview:line];
    
    [[ADLKeyboardMonitor monitor] setEnable:YES];
    
    [self getExpressCompany];
    [self calculateTotalMoney];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.dataArr[indexPath.row][@"service"]) {
            return 140;
        } else {
            return 114;
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 25;
        }
    } else {
        return ROW_HEIGHT;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count;
    } else if (section == 3)  {
        return self.moneyArr.count;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return 8;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    headerView.backgroundColor = COLOR_F2F2F2;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ADLSubmitOrderCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"SubmitOrderCell"];
        if (goodsCell == nil) {
            goodsCell = [[NSBundle mainBundle] loadNibNamed:@"ADLSubmitOrderCell" owner:nil options:nil].lastObject;
            goodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodsCell.delegate = self;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        [goodsCell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        goodsCell.attributeLab.text = [NSString stringWithFormat:@" %@",dict[@"attribute"]];
        goodsCell.nameLab.text = dict[@"goodsName"];
        goodsCell.countLab.text = [dict[@"num"] stringValue];
        
        if ([dict[@"activityGoods"][@"activityPrice"] doubleValue] > 0) {
            goodsCell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"activityGoods"][@"activityPrice"] doubleValue]];
        } else {
            goodsCell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"newPrice"] doubleValue]];
        }
        
        if (dict[@"service"]) {
            goodsCell.serviceLab.text = dict[@"service"];
            [goodsCell.serviceBtn setTitle:@"修改服务" forState:UIControlStateNormal];
            goodsCell.serviceMoneyLab.text = [NSString stringWithFormat:@"¥ %.2f x%ld",[dict[@"startingPrice"] doubleValue],[dict[@"num"] integerValue]];
        } else {
            [goodsCell.serviceBtn setTitle:@"选择服务" forState:UIControlStateNormal];
            goodsCell.serviceMoneyLab.text = @"";
            goodsCell.serviceLab.text = @"";
        }
        NSInteger limitCount = [dict[@"activityGoods"][@"userBuyNum"] integerValue];
        //        NSInteger inventoryCount = [dict[@"nowNum"] integerValue];
        NSInteger inventoryCount = NSIntegerMax;
        NSInteger currentCount = [dict[@"num"] integerValue];
        if (limitCount > 0) {
            if (limitCount < inventoryCount) {
                inventoryCount = limitCount;
            }
        }
        if (currentCount == inventoryCount) {
            [goodsCell.addBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        } else {
            [goodsCell.addBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        
        if (currentCount == 1) {
            [goodsCell.reduceBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        } else {
            [goodsCell.reduceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        return goodsCell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ADLMoneyTextCell *doubleCell = [tableView dequeueReusableCellWithIdentifier:@"doubleCell"];
            if (doubleCell == nil) {
                doubleCell = [[ADLMoneyTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"doubleCell"];
                doubleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                doubleCell.titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
                doubleCell.descLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            }
            doubleCell.spView.hidden = NO;
            doubleCell.titLab.text = @"配送";
            doubleCell.descLab.text = self.expressDict[@"name"];
            return doubleCell;
        } else {
            ADLTextFieldCell *tfCell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            if (tfCell == nil) {
                tfCell = [[NSBundle mainBundle] loadNibNamed:@"ADLTextFieldCell" owner:nil options:nil].lastObject;
                tfCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tfCell.textField.placeholder = @"选填,请填写备注信息";
                tfCell.titLab.text = @"买家留言";
                tfCell.spView.hidden = YES;
                tfCell.delegate = self;
            }
            tfCell.textField.text = self.remarkStr;
            return tfCell;
        }
        
    } else if (indexPath.section == 2) {
        ADLSettingViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
        if (settingCell == nil) {
            settingCell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
        }
        if (indexPath.row == 0) {
            settingCell.spView.hidden = NO;
            settingCell.firstLab.text = @"发票";
            settingCell.secondLab.text = self.invoiceStr;
            if ([self.invoiceStr containsString:@"请"]) {
                settingCell.secondLab.textColor = PLACEHOLDER_COLOR;
            } else {
                settingCell.secondLab.textColor = COLOR_333333;
            }
        } else {
            settingCell.spView.hidden = YES;
            settingCell.firstLab.text = @"优惠券";
            settingCell.secondLab.text = self.couponDict[@"name"];
            if ([self.couponDict[@"name"] containsString:@"请"]) {
                settingCell.secondLab.textColor = PLACEHOLDER_COLOR;
            } else {
                settingCell.secondLab.textColor = COLOR_333333;
            }
        }
        return settingCell;
        
    } else {
        ADLMoneyTextCell *doubleCell = [tableView dequeueReusableCellWithIdentifier:@"double"];
        if (doubleCell == nil) {
            doubleCell = [[ADLMoneyTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"double"];
            doubleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            doubleCell.spView.hidden = YES;
        }
        NSDictionary *dict = self.moneyArr[indexPath.row];
        doubleCell.titLab.text = dict[@"name"];
        doubleCell.descLab.text = dict[@"money"];
        if (indexPath.row == 0) {
            doubleCell.top = NO;
        } else {
            doubleCell.top = YES;
        }
        return doubleCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
        detailVC.goodsId = self.dataArr[indexPath.row][@"goodsId"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            ADLInvoiceInfController *infVC = [[ADLInvoiceInfController alloc] init];
            infVC.finish = ^(NSString *invoiceId, NSString *invoiceStr) {
                self.invoiceStr = [invoiceStr componentsSeparatedByString:@","].firstObject;
                self.invoiceId = invoiceId;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:infVC animated:YES];
            
        } else {
            NSMutableString *skuStr = [[NSMutableString alloc] init];
            for (NSDictionary *dict in self.dataArr) {
                [skuStr appendString:[NSString stringWithFormat:@"%@:%@,",dict[@"skuId"],dict[@"num"]]];
            }
            ADLSelectCouponController *couponVC = [[ADLSelectCouponController alloc] init];
            couponVC.servicePrice = self.serviceMoney;
            couponVC.orderType = 1;
            couponVC.money = self.totalMoney;
            couponVC.skuIdsStr = [skuStr substringToIndex:skuStr.length-1];
            couponVC.clickCoupon = ^(NSDictionary *couponDict) {
                self.couponDict = couponDict;
                [self calculateTotalMoney];
            };
            [self.navigationController pushViewController:couponVC animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark ------ 点击商品图片 ------
- (void)didClickImgView:(UIImageView *)imgView {
    ADLSubmitOrderCell *cell = (ADLSubmitOrderCell *)imgView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"imgUrl"] stringValue].length > 2) {
        [ADLImagePreView showWithImageViews:@[imgView] urlArray:@[dict[@"imgUrl"]] currentIndex:0];
    }
}

#pragma mark ------ 点击属性 ------
- (void)didClickAttributeBtn:(UIButton *)sender {
    ADLSubmitOrderCell *cell = (ADLSubmitOrderCell *)sender.superview.superview;
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
                    if (![dict[@"skuId"] isEqualToString:selectDict[@"id"]] || [dict[@"num"] intValue] != [selectDict[@"count"] intValue]) {
                        [dict setValue:selectDict[@"count"] forKey:@"num"];
                        if (![selectDict[@"id"] isEqualToString:dict[@"skuId"]]) {
                            [dict setValue:selectDict[@"id"] forKey:@"skuId"];
                            [dict setValue:selectDict[@"select"] forKey:@"attribute"];
                            [dict setValue:selectDict[@"nowPrice"] forKey:@"newPrice"];
                            if ([dict[@"activityGoods"][@"activityPrice"] doubleValue] > 0) {
                                [dict setValue:dict[@"activityGoods"] forKey:@"activityGoods"];
                            }
                        }
                        [self calculateTotalMoney];
                    }
                }
            }];
        }
    } failure:nil];
}

#pragma mark ------ 点击服务 ------
- (void)didClickServiceBtn:(UIButton *)sender {
    if (self.addressDict) {
        if (self.serviceArr.count != 0) {
            ADLSubmitOrderCell *cell = (ADLSubmitOrderCell *)sender.superview.superview;
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
                    if (selectDict == nil) {
                        [dict setValue:@[] forKey:@"services"];
                        [dict setValue:nil forKey:@"service"];
                        [dict setValue:nil forKey:@"startingPrice"];
                    } else {
                        [dict setValue:@[selectDict] forKey:@"services"];
                        [dict setValue:[NSString stringWithFormat:@"服务    %@",selectDict[@"name"]] forKey:@"service"];
                        [dict setValue:selectDict[@"startingPrice"] forKey:@"startingPrice"];
                    }
                    [self calculateTotalMoney];
                }
            }];
        } else {
            [ADLToast showMessage:@"所选地区暂无服务"];
        }
    } else {
        [ADLToast showMessage:@"请添加收货地址"];
    }
}

#pragma mark ------ 点击加 ------
- (void)didClickAddBtn:(UIButton *)sender {
    ADLSubmitOrderCell *cell = (ADLSubmitOrderCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    NSInteger count = [dict[@"num"] integerValue]+1;
    NSInteger limitCount = [dict[@"activityGoods"][@"userBuyNum"] integerValue];
    //    NSInteger inventoryCount = [dict[@"nowNum"] integerValue];
    NSInteger inventoryCount = NSIntegerMax;
    if (limitCount > 0) {
        if (limitCount < inventoryCount) {
            inventoryCount = limitCount;
        }
    }
    if (count <= inventoryCount) {
        [dict setValue:@(count) forKey:@"num"];
        cell.countLab.text = [NSString stringWithFormat:@"%lu",count];
        [self calculateTotalMoney];
    }
}

#pragma mark ------ 点击减 ------
- (void)didClickReduceBtn:(UIButton *)sender {
    ADLSubmitOrderCell *cell = (ADLSubmitOrderCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    NSInteger count = [dict[@"num"] integerValue]-1;
    if (count > 0) {
        [dict setValue:@(count) forKey:@"num"];
        cell.countLab.text = [NSString stringWithFormat:@"%lu",count];
        [self calculateTotalMoney];
    }
}

#pragma mark ------ 开始编辑 ------
- (void)textFieldDidBeginEdit:(UITextField *)textField {
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat bottomH = [ADLUtils convertRectWithView:textField];
    __weak typeof(self)weakSelf = self;
    [ADLKeyboardMonitor monitor].keyboardHeightChanged = ^(CGFloat keyboardH) {
        if (keyboardH == 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        } else {
            if (bottomH < keyboardH) {
                [UIView animateWithDuration:0.45 animations:^{
                    weakSelf.tableView.contentOffset = CGPointMake(0, offsetY+keyboardH-bottomH);
                }];
            }
        }
    };
}

#pragma mark ------ 备注 ------
- (void)textFieldDidEndEdit:(UITextField *)textField {
    if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
        self.remarkStr = textField.text;
    }
}

#pragma mark ------ 计算总额 ------
- (void)calculateTotalMoney {
    double totalMoney = 0;
    double serviceMoney = 0;
    double couponMoney = [self.couponDict[@"amount"] doubleValue];
    for (NSDictionary *dict in self.dataArr) {
        if ([dict[@"activityGoods"][@"activityPrice"] doubleValue] > 0) {
            totalMoney = totalMoney+[dict[@"activityGoods"][@"activityPrice"] doubleValue]*[dict[@"num"] integerValue];
        } else {
            totalMoney = totalMoney+[dict[@"newPrice"] doubleValue]*[dict[@"num"] integerValue];
        }
        NSArray *serArr = dict[@"services"];
        if (serArr.count > 0) {
            serviceMoney = serviceMoney+[serArr.lastObject[@"startingPrice"] doubleValue]*[dict[@"num"] integerValue];
        }
    }
    
    if (totalMoney < [self.couponDict[@"orderAmount"] doubleValue]) {
        couponMoney = 0;
        self.couponDict = @{@"name":@"请选择优惠券",@"amount":@"0"};
    }
    
    double payMoney = totalMoney+self.expressMoney+serviceMoney-couponMoney;
    if (payMoney < 0) payMoney = 0;
    
    self.totalMoney = totalMoney;
    self.serviceMoney = serviceMoney;
    self.payMoney = payMoney;
    
    [self.moneyArr removeAllObjects];
    [self.moneyArr addObject:@{@"name":@"商品金额",@"money":[NSString stringWithFormat:@"¥ %.2f",totalMoney]}];
    if (serviceMoney > 0) {
        [self.moneyArr addObject:@{@"name":@"服务费用",@"money":[NSString stringWithFormat:@"¥ %.2f",serviceMoney]}];
    }
    if (couponMoney > 0) {
        [self.moneyArr addObject:@{@"name":@"优惠券抵扣",@"money":[NSString stringWithFormat:@"-¥ %.2f",couponMoney]}];
    }
    [self.moneyArr addObject:@{@"name":@"运费",@"money":[NSString stringWithFormat:@"¥ %.2f",self.expressMoney]}];
    
    [self.tableView reloadData];
    NSString *moneyStr = [NSString stringWithFormat:@"应付金额：¥ %.2f",payMoney];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(5, moneyStr.length-5)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(5, 1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(moneyStr.length-3, 3)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(7, moneyStr.length-10)];
    self.moneyLab.attributedText = attributeStr;
}

#pragma mark ------ 提交订单 ------
- (void)clickSubmitBtn {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *orderDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfDict = [[NSMutableDictionary alloc] init];
    [orderInfDict setValue:[NSString stringWithFormat:@"%.2f",self.totalMoney] forKey:@"goodsAmount"];
    [orderInfDict setValue:[NSString stringWithFormat:@"%.2f",self.payMoney] forKey:@"payAmount"];
    [orderInfDict setValue:self.remarkStr forKey:@"userMsg"];
    [orderInfDict setValue:self.invoiceId forKey:@"receiptId"];
    [orderInfDict setValue:self.addressDict[@"id"] forKey:@"addrId"];
    [orderInfDict setValue:self.couponDict[@"id"] forKey:@"couponId"];
    [orderInfDict setValue:[NSString stringWithFormat:@"%.2f",self.expressMoney] forKey:@"freight"];
    [orderInfDict setValue:self.expressDict[@"id"] forKey:@"expressCompanyId"];
    [orderDict setValue:orderInfDict forKey:@"orderInfo"];
    
    NSMutableArray *skusArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.dataArr) {
        NSMutableDictionary *skusDict = [[NSMutableDictionary alloc] init];
        [skusDict setValue:dict[@"skuId"] forKey:@"id"];
        [skusDict setValue:dict[@"num"] forKey:@"num"];
        [skusDict setValue:dict[@"serviceOrderId"] forKey:@"serviceOrderId"];
        NSArray *serArr = dict[@"services"];
        if (serArr.count > 0) {
            NSDictionary *serDict = serArr.lastObject;
            NSMutableDictionary *serMuDict = [[NSMutableDictionary alloc] init];
            [serMuDict setValue:serDict[@"id"] forKey:@"id"];
            [serMuDict setValue:dict[@"num"] forKey:@"num"];
            [serMuDict setValue:serDict[@"startingPrice"] forKey:@"price"];
            [skusDict setValue:@[serMuDict] forKey:@"service"];
        }
        [skusArr addObject:skusDict];
    }
    [orderDict setValue:skusArr forKey:@"skus"];
    if (self.shoppingCar) {
        NSMutableArray *carsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.dataArr) {
            [carsArr addObject:dict[@"id"]];
        }
        [orderDict setValue:carsArr forKey:@"cars"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderDict options:kNilOptions error:nil];
    [ADLNetWorkManager postStringPath:k_submit_order stringData:jsonData autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"refresh" userInfo:nil];
            [ADLToast hide];
            
            ADLOrderPayController *payVC = [[ADLOrderPayController alloc] init];
            payVC.orderId = responseDict[@"data"][@"orderId"];
            payVC.money = self.payMoney;
            payVC.serviceOrder = NO;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    } failure:nil];
}

#pragma mark ------ 获取物流公司 ------
- (void)getExpressCompany {
    [ADLNetWorkManager postWithPath:k_order_express_company parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.expressDict = responseDict[@"data"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self getAddressData];
        }
    } failure:nil];
}

#pragma mark ------ 获取收货地址 ------
- (void)getAddressData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_address_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *adrsArr = responseDict[@"data"];
            if (adrsArr.count > 0) {
                for (NSMutableDictionary *dict in adrsArr) {
                    if ([dict[@"isDefault"] intValue] == 0) {
                        self.addressDict = dict;
                        break;
                    }
                }
                if (self.addressDict == nil) {
                    self.addressDict = adrsArr.firstObject;
                }
                
                AddressInfo info = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[self.addressDict[@"areaId"] stringValue]];
                NSString *areaStr = [NSString stringWithFormat:@"%@%@",info.address,self.addressDict[@"address"]];
                [self.addressDict setValue:info.cityId forKey:@"cityId"];
                [self.addressDict setValue:areaStr forKey:@"areaStr"];
                self.addressView.nameLab.hidden = NO;
                self.addressView.addressLab.hidden = NO;
                [self.addressView.addBtn setTitle:@" " forState:UIControlStateNormal];
                self.addressView.nameLab.text = [NSString stringWithFormat:@"%@  %@",self.addressDict[@"consignee"],self.addressDict[@"phone"]];
                self.addressView.addressLab.text = [areaStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                [self getLockServiceData:info.cityId];
                [self getGoodsFee];
            } else {
                [self removeGoodsService];
                [self calculateTotalMoney];
            }
        }
    } failure:nil];
}

#pragma mark ------ 获取服务信息 ------
- (void)getLockServiceData:(NSString *)cityId {
    self.serviceArr = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:cityId forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_install_lock_cost parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *serviceArr = responseDict[@"data"];
            self.serviceArr = serviceArr;
            BOOL hasService = NO;
            for (NSMutableDictionary *dict in self.dataArr) {
                NSArray *serArr = dict[@"services"];
                NSString *serId = serArr.lastObject[@"id"];
                BOOL contain = NO;
                for (NSDictionary *serDict in serviceArr) {
                    if ([serDict[@"id"] isEqualToString:serId]) {
                        contain = YES;
                        break;
                    }
                }
                if (contain == NO) {
                    if (serArr.count > 0) hasService = YES;
                    [dict setValue:nil forKey:@"service"];
                    [dict setValue:nil forKey:@"startingPrice"];
                    [dict setValue:@[] forKey:@"services"];
                }
            }
            if (hasService) {
                [ADLToast showMessage:@"所选服务已失效，请重新选择！"];
            }
        } else {
            [self removeGoodsService];
        }
        [self calculateTotalMoney];
    } failure:^(NSError *error) {
        [self removeGoodsService];
        [self calculateTotalMoney];
    }];
}

#pragma mark ------ 移除服务 ------
- (void)removeGoodsService {
    BOOL hasService = NO;
    for (NSMutableDictionary *dict in self.dataArr) {
        NSArray *serArr = dict[@"services"];
        if (serArr.count > 0) {
            [dict setValue:@[] forKey:@"services"];
            [dict setValue:nil forKey:@"service"];
            [dict setValue:nil forKey:@"startingPrice"];
            hasService = YES;
        }
    }
    if (hasService) {
        [ADLToast showMessage:@"所选服务已失效，请重新选择！"];
    }
}

#pragma mark ------ 获取商品运费 ------
- (void)getGoodsFee {
    self.expressMoney = 0;
    NSMutableString *skuStr = [[NSMutableString alloc] init];
    for (NSDictionary *dict in self.dataArr) {
        [skuStr appendString:[NSString stringWithFormat:@"%@:%@,",dict[@"skuId"],dict[@"num"]]];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.addressDict[@"id"] forKey:@"addressId"];
    [params setValue:self.expressDict[@"id"] forKey:@"companyId"];
    [params setValue:[skuStr substringToIndex:skuStr.length-1] forKey:@"skuIds"];
    
    [ADLNetWorkManager postWithPath:k_order_express_fee parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.expressMoney = [responseDict[@"data"] doubleValue];
            [self calculateTotalMoney];
        }
    } failure:nil];
}

- (void)dealloc {
    [[ADLKeyboardMonitor monitor] setEnable:NO];
}

@end
