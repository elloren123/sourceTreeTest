//
//  ADLOrderDetailController.m
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderDetailController.h"
#import "ADLLookLogisticsController.h"
#import "ADLSelAfterTypeController.h"
#import "ADLGoodsDetailController.h"
#import "ADLGoodsClassController.h"
#import "ADLInvoiceInfController.h"
#import "ADLLockerPathController.h"
#import "ADLInsuranceController.h"
#import "ADLOrderPayController.h"
#import "ADLSessionController.h"
#import "ADLRefundController.h"

#import "ADLOrderDetailHeader.h"
#import "ADLOrderDetailCell.h"
#import "ADLGoodsAttriView.h"
#import "ADLSingleTextCell.h"
#import "ADLMoneyTextCell.h"
#import "ADLSettingViewCell.h"

#import <Masonry.h>

@interface ADLOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,ADLOrderDetailHeaderDelegate,ADLOrderDetailCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSDictionary *lockerDict;
@property (nonatomic, strong) NSDictionary *expDict;
@property (nonatomic, strong) NSArray *serviceArr;
@property (nonatomic, strong) NSString *invoiceId;
@property (nonatomic, strong) NSMutableArray *orderInfArr;
@property (nonatomic, strong) NSMutableArray *invoiceInfArr;
@property (nonatomic, strong) NSMutableArray *insuranceArr;
@property (nonatomic, strong) NSMutableDictionary *updateDict;
@property (nonatomic, strong) NSMutableArray *moneyArr;
@property (nonatomic, strong) UILabel *payMoneyLab;
@property (nonatomic, strong) NSDictionary *couponDict;
@property (nonatomic, assign) BOOL serviceOrder;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) double freight;
@property (nonatomic, assign) double payMoney;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *expressId;
@end

@implementation ADLOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"订单详情"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.orderInfArr = [[NSMutableArray alloc] init];
    self.invoiceInfArr = [[NSMutableArray alloc] init];
    self.insuranceArr = [[NSMutableArray alloc] init];
    self.moneyArr = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.hidden = YES;
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [firstBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [firstBtn addTarget:self action:@selector(clickFirstBtn) forControlEvents:UIControlEventTouchUpInside];
    firstBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstBtn];
    self.firstBtn = firstBtn;
    firstBtn.hidden = YES;
    
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-BOTTOM_H);
        make.width.equalTo(@(SCREEN_WIDTH/2));
        make.height.equalTo(@(VIEW_HEIGHT));
    }];
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [secondBtn addTarget:self action:@selector(clickSecondBtn) forControlEvents:UIControlEventTouchUpInside];
    secondBtn.backgroundColor = APP_COLOR;
    [self.view addSubview:secondBtn];
    self.secondBtn = secondBtn;
    secondBtn.hidden = YES;
    
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SCREEN_WIDTH/2);
        make.bottom.equalTo(self.view).offset(-BOTTOM_H);
        make.width.equalTo(@(SCREEN_WIDTH/2));
        make.height.equalTo(@(VIEW_HEIGHT));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = SEPARATOR_COLOR;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.hidden = YES;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-BOTTOM_H-VIEW_HEIGHT);
        make.height.equalTo(@(0.5));
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAVIGATION_H);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-BOTTOM_H-VIEW_HEIGHT);
    }];
    
    [self getOrderData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count;
    } else if (section == 1) {
        return self.orderInfArr.count;
    } else if (section == 2) {
        return self.invoiceInfArr.count;
    } else if (section == 3) {
        if (self.insuranceArr.count > 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return self.moneyArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        if (self.serviceOrder) {
            return VIEW_HEIGHT+8;
        } else {
            return VIEW_HEIGHT*2+12;
        }
    } else if (section == 2) {
        return VIEW_HEIGHT+8;
    } else if (section == 3) {
        if (self.insuranceArr.count > 0) {
            return 8;
        } else {
            return 0;
        }
    } else {
        return 8;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = COLOR_F2F2F2;
    if (section == 1) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:bgView];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, VIEW_HEIGHT)];
        lab1.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        lab1.textColor = COLOR_333333;
        lab1.text = @"订单基本信息";
        [bgView addSubview:lab1];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
        line1.backgroundColor = SEPARATOR_COLOR;
        [bgView addSubview:line1];
        
        if (!self.serviceOrder) {
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT*2+12);
            UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            contactBtn.frame = CGRectMake(0, 4, SCREEN_WIDTH, VIEW_HEIGHT);
            [contactBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            contactBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
            [contactBtn setTitle:@"  联系客服" forState:UIControlStateNormal];
            [contactBtn setImage:[UIImage imageNamed:@"customer_service"] forState:UIControlStateNormal];
            [contactBtn addTarget:self action:@selector(clickContactBtn) forControlEvents:UIControlEventTouchUpInside];
            contactBtn.backgroundColor = [UIColor whiteColor];
            [footerView addSubview:contactBtn];
            
            bgView.frame = CGRectMake(0, VIEW_HEIGHT+12, SCREEN_WIDTH, VIEW_HEIGHT);
            
        } else {
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT+8);
            bgView.frame = CGRectMake(0, 8, SCREEN_WIDTH, VIEW_HEIGHT);
        }
        
    } else if (section == 2) {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT+8);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, VIEW_HEIGHT)];
        bgView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:bgView];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 200, VIEW_HEIGHT)];
        lab2.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        lab2.textColor = COLOR_333333;
        [footerView addSubview:lab2];
        
        if (self.invoiceInfArr.count == 0) {
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"发票信息：不开发票"];
            [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_SIZE] range:NSMakeRange(5, 4)];
            lab2.attributedText = attributeStr;
            if (self.status != 2) {
                UIButton *invoiceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                invoiceBtn.frame = CGRectMake(SCREEN_WIDTH-92, 15, 80, VIEW_HEIGHT-14);
                [invoiceBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                invoiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [invoiceBtn setTitle:@"申请开票" forState:UIControlStateNormal];
                [invoiceBtn addTarget:self action:@selector(clickApplyInvoiceBtn) forControlEvents:UIControlEventTouchUpInside];
                invoiceBtn.layer.borderWidth = 0.5;
                invoiceBtn.layer.borderColor = COLOR_D3D3D3.CGColor;
                invoiceBtn.layer.cornerRadius = CORNER_RADIUS;
                [footerView addSubview:invoiceBtn];
            }
        } else {
            lab2.text = @"发票信息";
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT+7.5, SCREEN_WIDTH, 0.5)];
            line2.backgroundColor = SEPARATOR_COLOR;
            [footerView addSubview:line2];
        }
        
    } else {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 8);
    }
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.dataArr[indexPath.row][@"service"]) {
            return 146;
        } else {
            return 116;
        }
    } else if (indexPath.section == 3) {
        return VIEW_HEIGHT;
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 25;
        }
    } else {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return 32;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ADLOrderDetailCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
        if (goodsCell == nil) {
            goodsCell = [[NSBundle mainBundle] loadNibNamed:@"ADLOrderDetailCell" owner:nil options:nil].lastObject;
            goodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodsCell.delegate = self;
        }
        NSDictionary *dict = self.dataArr[indexPath.row];
        if (self.serviceOrder) {
            [goodsCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"serviceImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            goodsCell.nameLab.text = dict[@"serviceName"];
            goodsCell.descLab.text = [NSString stringWithFormat:@"数量：%@",dict[@"num"]];
            goodsCell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"price"] doubleValue]];
        } else {
            [goodsCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"goodsImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            goodsCell.nameLab.text = dict[@"goodsName"];
            goodsCell.descLab.text = dict[@"attribute"];
            goodsCell.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[dict[@"price"] doubleValue]];
            goodsCell.serNameLab.text = dict[@"serviceStr"];
            goodsCell.serMoneyLab.text = dict[@"startingPrice"];
        }
        
        if (self.status == 0) {
            if (self.serviceOrder) {
                goodsCell.actionBtn.hidden = YES;
            } else {
                [goodsCell.actionBtn setTitle:@"修改" forState:UIControlStateNormal];
            }
        } else if (self.status == 5) {
            if ([dict[@"customerStatus"] integerValue] == 0) {
                goodsCell.actionBtn.hidden = YES;
            } else {
                if (self.serviceOrder) {
                    goodsCell.actionBtn.hidden = YES;
                } else {
                    [goodsCell.actionBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                    goodsCell.actionBtn.layer.borderWidth = 0.5;
                    goodsCell.actionBtn.backgroundColor = [UIColor whiteColor];
                    [goodsCell.actionBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
                }
            }
        } else if (self.status == 3) {
            if ([dict[@"customerStatus"] integerValue] == 0) {
                goodsCell.actionBtn.hidden = YES;
            } else {
                [goodsCell.actionBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                goodsCell.actionBtn.layer.borderWidth = 0.5;
                goodsCell.actionBtn.backgroundColor = [UIColor whiteColor];
                [goodsCell.actionBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
            }
        } else {
            goodsCell.actionBtn.hidden = YES;
        }
        return goodsCell;
        
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        ADLSingleTextCell *singleCell = [tableView dequeueReusableCellWithIdentifier:@"single"];
        if (singleCell == nil) {
            singleCell = [[ADLSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"single"];
            singleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            singleCell.spView.hidden = YES;
            singleCell.leftMargin = 12;
        }
        if (indexPath.section == 1) {
            singleCell.titLab.text = self.orderInfArr[indexPath.row];
        } else {
            singleCell.titLab.text = self.invoiceInfArr[indexPath.row];
        }
        if (indexPath.row == 0) {
            singleCell.top = NO;
        } else {
            singleCell.top = YES;
        }
        return singleCell;
    } else if (indexPath.section == 3) {
        ADLSettingViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
        if (settingCell == nil) {
            settingCell = [[NSBundle mainBundle] loadNibNamed:@"ADLSettingViewCell" owner:nil options:nil].lastObject;
            settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            settingCell.spView.hidden = YES;
        }
        settingCell.firstLab.text = @"保险单信息";
        return settingCell;
    } else {
        ADLMoneyTextCell *doubleCell = [tableView dequeueReusableCellWithIdentifier:@"double"];
        if (doubleCell == nil) {
            doubleCell = [[ADLMoneyTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"double"];
            doubleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            doubleCell.spView.hidden = YES;
        }
        if (indexPath.row == 0) {
            doubleCell.top = NO;
        } else {
            doubleCell.top = YES;
        }
        NSDictionary *dict = self.moneyArr[indexPath.row];
        doubleCell.titLab.text = dict[@"name"];
        doubleCell.descLab.text = dict[@"money"];
        return doubleCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dict = self.dataArr[indexPath.row];
        if (dict[@"goodsId"]) {
            ADLGoodsDetailController *detailVC = [[ADLGoodsDetailController alloc] init];
            detailVC.goodsId = dict[@"goodsId"];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    if (indexPath.section == 3) {
        ADLInsuranceController *insuranceVC = [[ADLInsuranceController alloc] init];
        insuranceVC.insuranceArr = self.insuranceArr;
        [self.navigationController pushViewController:insuranceVC animated:YES];
    }
}

#pragma mark ------ 申请开票 ------
- (void)clickApplyInvoiceBtn {
    ADLInvoiceInfController *invoiceVC = [[ADLInvoiceInfController alloc] init];
    invoiceVC.finish = ^(NSString *invoiceId, NSString *invoiceStr) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:invoiceId forKey:@"receiptId"];
        [params setValue:self.orderId forKey:@"orderId"];
        [params setValue:self.suborderId forKey:@"subOrderId"];
        [ADLNetWorkManager postWithPath:k_update_order_invoice parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                self.invoiceId = invoiceId;
                NSArray *invoArr = [invoiceStr componentsSeparatedByString:@","];
                [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票类型：%@",invoArr.firstObject]];
                [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票抬头：%@",invoArr[1]]];
                [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票内容：%@",invoArr.lastObject]];
                [self.tableView reloadData];
            }
        } failure:nil];
    };
    [self.navigationController pushViewController:invoiceVC animated:YES];
}

#pragma mark ------ 查看物流 ------
- (void)didClickLookLogisticsInformationBtn {
    ADLLookLogisticsController *logisticsVC = [[ADLLookLogisticsController alloc] init];
    logisticsVC.logisticsDict = self.expDict;
    [self.navigationController pushViewController:logisticsVC animated:YES];
}

#pragma mark ------ 查看锁匠行程 ------
- (void)didClickLookLockerPathBtn {
    ADLLockerPathController *pathVC = [[ADLLockerPathController alloc] init];
    pathVC.lockerDict = self.lockerDict;
    [self.navigationController pushViewController:pathVC animated:YES];
}

#pragma mark ------ 联系客服 ------
- (void)clickContactBtn {
    ADLSessionController *sessionVC = [[ADLSessionController alloc] init];
    sessionVC.goodsId = self.dataArr.firstObject[@"goodsId"];
    [self.navigationController pushViewController:sessionVC animated:YES];
}

#pragma mark ------ ADLOrderDetailCellDelegate ------
- (void)didClickActionBtn:(UIButton *)sender {
    ADLOrderDetailCell *cell = (ADLOrderDetailCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"修改"]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
        [params setValue:dict[@"goodsId"] forKey:@"goodsId"];
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        [ADLNetWorkManager postWithPath:k_goods_information parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                NSMutableDictionary *attrDict = [[NSMutableDictionary alloc] init];
                NSArray *skuArr = responseDict[@"data"][@"skuList"];
                [attrDict setValue:skuArr forKey:@"skuList"];
                [attrDict setValue:[ADLUtils skuArrToAttributeArr:skuArr] forKey:@"propertyVOList"];
                [attrDict setValue:dict[@"goodsImg"] forKey:@"imageUrl"];
                [attrDict setValue:@(YES) forKey:@"confirm"];
                [attrDict setValue:dict[@"goodsNum"] forKey:@"count"];
                NSString *attribute = dict[@"attribute"];
                NSInteger location = [attribute rangeOfString:@"规格："].location;
                attribute = [attribute substringWithRange:NSMakeRange(location+3, attribute.length-location-3)];
                [attrDict setValue:attribute forKey:@"select"];
                if (self.serviceArr.count > 0) {
                    [attrDict setValue:self.serviceArr forKey:@"serviceList"];
                }
                if (dict[@"service"]) {
                    NSMutableDictionary *serDict = [[NSMutableDictionary alloc] init];
                    [serDict setValue:dict[@"service"][@"serviceId"] forKey:@"id"];
                    [serDict setValue:dict[@"service"][@"serviceName"] forKey:@"name"];
                    [serDict setValue:dict[@"service"][@"price"] forKey:@"startingPrice"];
                    [attrDict setValue:serDict forKey:@"service"];
                }
                [ADLToast hide];
                [ADLGoodsAttriView goodsAttributeViewWith:attrDict confirmAction:^(NSMutableDictionary *selectDict) {
                    if (selectDict != nil) {
                        [selectDict setValue:@(indexPath.row) forKey:@"row"];
                        self.updateDict = selectDict;
                        [self getUseableCouponData];
                    }
                }];
            }
        } failure:nil];
    } else {
        NSInteger startRange = 1;
        double timestamp = [dict[@"finishTime"] doubleValue];
        if (timestamp > 10000) {
            NSInteger second = [ADLUtils getSecondFromStartTimestamp:timestamp endTimestamp:0];
            if (second > 604800) startRange = 2;
            if (second > 1296000) startRange = 3;
        }
        ADLSelAfterTypeController *typeVC = [[ADLSelAfterTypeController alloc] init];
        typeVC.dataDict = dict;
        typeVC.startRange = startRange;
        typeVC.orderVC = YES;
        [self.navigationController pushViewController:typeVC animated:YES];
    }
}

#pragma mark ------ 点击第一个按钮 ------
- (void)clickFirstBtn {
    NSString *title = self.firstBtn.titleLabel.text;
    if ([title isEqualToString:@"取消订单"]) {
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.orderId forKey:@"orderId"];
        [params setValue:self.suborderId forKey:@"subOrderId"];
        [ADLNetWorkManager postWithPath:k_order_cancle parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"取消成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER_LIST object:nil userInfo:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:nil];
    } else if ([title isEqualToString:@"申请退款"]) {
        ADLRefundController *refundVC = [[ADLRefundController alloc] init];
        refundVC.refundArr = self.dataArr;
        refundVC.service = self.serviceOrder;
        refundVC.suborderId = self.suborderId;
        [self.navigationController pushViewController:refundVC animated:YES];
    } else {
        ADLGoodsClassController *classVC = [[ADLGoodsClassController alloc] init];
        classVC.className = @"选择配件";
        classVC.systemLock = NO;
        classVC.classId = @"1";
        classVC.orderId = self.orderId;
        [self.navigationController pushViewController:classVC animated:YES];
    }
}

#pragma mark ------ 点击第二个按钮 ------
- (void)clickSecondBtn {
    NSString *title = self.secondBtn.titleLabel.text;
    if ([title isEqualToString:@"去付款"]) {
        ADLOrderPayController *payVC = [[ADLOrderPayController alloc] init];
        payVC.money = self.payMoney;
        payVC.orderId = self.orderId;
        payVC.serviceOrder = self.serviceOrder;
        [self.navigationController pushViewController:payVC animated:YES];
        
    } else if ([title isEqualToString:@"提醒发货"]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.orderId forKey:@"orderId"];
        [params setValue:self.suborderId forKey:@"subOrderId"];
        [ADLNetWorkManager postWithPath:k_remind_shipment parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"已提醒卖家尽快发货"];
            }
        } failure:nil];
        
    } else if ([title isEqualToString:@"再次购买"]) {
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        dispatch_group_t group = dispatch_group_create();
        
        for (NSDictionary *dict in self.dataArr) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:@(1) forKey:@"num"];
            [params setValue:dict[@"skuId"] forKey:@"skuId"];
            [params setValue:@"" forKey:@"services"];
            dispatch_group_enter(group);
            [ADLNetWorkManager postWithPath:k_add_car parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [ADLToast showMessage:@"商品已添加到购物车"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPPING_CAR object:@"refresh" userInfo:nil];
        });
        
    } else if ([title isEqualToString:@"确认收货"]) {
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.orderId forKey:@"orderId"];
        [params setValue:self.suborderId forKey:@"subOrderId"];
        [ADLNetWorkManager postWithPath:k_order_confirm_receipt parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"确认收货成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER_LIST object:nil userInfo:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:nil];
    } else if ([title isEqualToString:@"申请退款"]) {
        ADLRefundController *refundVC = [[ADLRefundController alloc] init];
        refundVC.refundArr = self.dataArr;
        refundVC.service = self.serviceOrder;
        refundVC.suborderId = self.suborderId;
        [self.navigationController pushViewController:refundVC animated:YES];
    } else {
        [ADLAlertView showWithTitle:@"提示" message:@"确认服务已完成？" confirmTitle:nil confirmAction:^{
            [ADLToast showLoadingMessage:ADLString(@"loading")];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:self.orderId forKey:@"orderId"];
            [params setValue:self.suborderId forKey:@"subOrderId"];
            [ADLNetWorkManager postWithPath:k_service_confirm_finish parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
                if ([responseDict[@"code"] integerValue] == 10000) {
                    [ADLToast showMessage:@"确认成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER_LIST object:nil userInfo:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            } failure:nil];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }
}

#pragma mark ------ 计算总额 ------
- (void)calculateTotalMoney {
    [self.moneyArr removeAllObjects];
    double couponMoney = [self.couponDict[@"amount"] doubleValue];
    double payMoney = 0;
    if (self.serviceOrder) {
        double serviceMoney = 0;
        for (NSDictionary *dict in self.dataArr) {
            serviceMoney = serviceMoney+[dict[@"price"] doubleValue]*[dict[@"num"] integerValue];
        }
        payMoney = serviceMoney-couponMoney;
        [self.moneyArr addObject:@{@"name":@"服务费用",@"money":[NSString stringWithFormat:@"¥ %.2f",serviceMoney]}];
    } else {
        double goodsMoney = 0;
        double serMoney = 0;
        for (NSDictionary *dict in self.dataArr) {
            goodsMoney = goodsMoney+[dict[@"price"] doubleValue]*[dict[@"goodsNum"] integerValue];
            if (dict[@"service"]) {
                serMoney = serMoney+[dict[@"service"][@"price"] doubleValue]*[dict[@"goodsNum"] integerValue];
            }
        }
        payMoney = goodsMoney+serMoney+self.freight-couponMoney;
        [self.moneyArr addObject:@{@"name":@"商品金额",@"money":[NSString stringWithFormat:@"¥ %.2f",goodsMoney]}];
        [self.moneyArr addObject:@{@"name":@"服务费用",@"money":[NSString stringWithFormat:@"¥ %.2f",serMoney]}];
    }
    if (couponMoney > 0) {
        [self.moneyArr addObject:@{@"name":@"优惠券抵扣",@"money":[NSString stringWithFormat:@"-¥ %.2f",couponMoney]}];
    }
    if (self.freight > 0) {
        [self.moneyArr addObject:@{@"name":@"运费",@"money":[NSString stringWithFormat:@"¥ %.2f",self.freight]}];
    }
    if (payMoney < 0) payMoney = 0;
    
    self.payMoney = payMoney;
    if (self.status == 2) {
        NSString *monStr = [NSString stringWithFormat:@"订单金额：¥ %.2f",payMoney];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:monStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(5, monStr.length-5)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_SIZE] range:NSMakeRange(5, monStr.length-5)];
        self.payMoneyLab.attributedText = attrStr;
    } else {
        NSString *moneyStr = [NSString stringWithFormat:@"实付款：¥ %.2f",payMoney];
        if (self.status == 0) {
            moneyStr = [NSString stringWithFormat:@"需付款：¥ %.2f",payMoney];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(4, moneyStr.length-4)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_SIZE] range:NSMakeRange(4, moneyStr.length-4)];
        self.payMoneyLab.attributedText = attributeStr;
    }
    [self.tableView reloadData];
}

#pragma mark ------ 获取可用优惠券 ------
- (void)getUseableCouponData {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    int index = [self.updateDict[@"row"] intValue];
    double goodsMoney = 0;
    double serviceMoney = 0;
    double totalMoney = 0;
    for (int i = 0; i < self.dataArr.count; i++) {
        if (i == index) {
            if (self.updateDict[@"activityInfo"]) {
                goodsMoney = goodsMoney+[self.updateDict[@"activityInfo"][@"activityPrice"] doubleValue]*[self.updateDict[@"count"] integerValue];
            } else {
                goodsMoney = goodsMoney+[self.updateDict[@"nowPrice"] doubleValue]*[self.updateDict[@"count"] integerValue];
            }
            if (self.updateDict[@"service"]) {
                serviceMoney = serviceMoney+[self.updateDict[@"service"][@"startingPrice"] doubleValue]*[self.updateDict[@"count"] integerValue];
            }
        } else {
            NSDictionary *dict = self.dataArr[i];
            goodsMoney = goodsMoney+[dict[@"price"] doubleValue]*[dict[@"goodsNum"] integerValue];
            if (dict[@"service"]) {
                serviceMoney = serviceMoney+[dict[@"service"][@"price"] doubleValue]*[dict[@"goodsNum"] integerValue];
            }
        }
    }
    totalMoney = goodsMoney+serviceMoney+self.freight;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:@(serviceMoney) forKey:@"servicePrice"];
    [params setValue:@(1) forKey:@"orderType"];
    NSMutableString *skuStr = [[NSMutableString alloc] init];
    NSMutableArray *skusArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        
        if (i == index) {
            [skuStr appendString:[NSString stringWithFormat:@"%@:%@,",self.updateDict[@"id"],self.updateDict[@"count"]]];
            NSMutableDictionary *skusDict = [[NSMutableDictionary alloc] init];
            [skusDict setValue:self.updateDict[@"id"] forKey:@"id"];
            [skusDict setValue:self.updateDict[@"count"] forKey:@"num"];
            
            NSDictionary *serDict = self.updateDict[@"service"];
            if (serDict) {
                NSMutableDictionary *serMuDict = [[NSMutableDictionary alloc] init];
                [serMuDict setValue:serDict[@"id"] forKey:@"id"];
                [serMuDict setValue:self.updateDict[@"count"] forKey:@"num"];
                [serMuDict setValue:serDict[@"startingPrice"] forKey:@"price"];
                [skusDict setValue:@[serMuDict] forKey:@"service"];
            }
            [skusArr addObject:skusDict];
            
        } else {
            NSDictionary *dict = self.dataArr[i];
            [skuStr appendString:[NSString stringWithFormat:@"%@:%@,",dict[@"skuId"],dict[@"goodsNum"]]];
            
            NSMutableDictionary *skusDict = [[NSMutableDictionary alloc] init];
            [skusDict setValue:dict[@"skuId"] forKey:@"id"];
            [skusDict setValue:dict[@"goodsNum"] forKey:@"num"];
            
            NSDictionary *serDict = dict[@"service"];
            if (serDict) {
                NSMutableDictionary *serMuDict = [[NSMutableDictionary alloc] init];
                [serMuDict setValue:serDict[@"id"] forKey:@"id"];
                [serMuDict setValue:dict[@"goodsNum"] forKey:@"num"];
                [serMuDict setValue:serDict[@"startingPrice"] forKey:@"price"];
                [skusDict setValue:@[serMuDict] forKey:@"service"];
            }
            [skusArr addObject:skusDict];
        }
    }
    [params setValue:[skuStr substringToIndex:skuStr.length-1] forKey:@"skuIdsStr"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"goodsAmount"];
    [param setValue:self.expressId forKey:@"expressCompanyId"];
    [param setValue:self.invoiceId forKey:@"receiptId"];
    [param setValue:self.addressId forKey:@"addrId"];
    [param setValue:self.orderId forKey:@"id"];
    
    
    __block NSDictionary *couponDict = nil;
    [ADLNetWorkManager postWithPath:k_order_coupon parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSDictionary *couDict in resArr) {
                    if ([couDict[@"orderAmount"] doubleValue] <= totalMoney) {
                        if ([couponDict[@"amount"] doubleValue] < [couDict[@"amount"] doubleValue]) {
                            couponDict = couDict;
                        }
                    }
                }
            }
        }
        
        double couponMoney = 0;
        if (couponDict == nil) {
            if (self.couponDict != nil) {
                if ([self.couponDict[@"orderAmount"] doubleValue] <= totalMoney) {
                    [param setValue:self.couponDict[@"id"] forKey:@"couponId"];
                    couponMoney = [self.couponDict[@"amount"] doubleValue];
                }
            }
        } else {
            [param setValue:couponDict[@"id"] forKey:@"couponId"];
            couponMoney = [couponDict[@"amount"] doubleValue];
            
            if (self.couponDict && [self.couponDict[@"orderAmount"] doubleValue] <= totalMoney && [self.couponDict[@"amount"] doubleValue] > [couponDict[@"amount"] doubleValue]) {
                [param setValue:self.couponDict[@"id"] forKey:@"couponId"];
                couponMoney = [self.couponDict[@"amount"] doubleValue];
            }
        }
        
        if (totalMoney-couponMoney < 0) {
            [param setValue:@(0) forKey:@"payAmount"];
        } else {
            [param setValue:[NSString stringWithFormat:@"%.2f",totalMoney-couponMoney] forKey:@"payAmount"];
        }
        [self updateOrderWithDict:param skuArr:skusArr];
    } failure:^(NSError *error) {
        double couMoney = 0;
        if (self.couponDict != nil) {
            if ([self.couponDict[@"orderAmount"] doubleValue] <= totalMoney) {
                [param setValue:self.couponDict[@"id"] forKey:@"couponId"];
                couMoney = [self.couponDict[@"amount"] doubleValue];
            }
        }
        if (totalMoney-couMoney < 0) {
            [param setValue:@(0) forKey:@"payAmount"];
        } else {
            [param setValue:[NSString stringWithFormat:@"%.2f",totalMoney-couMoney] forKey:@"payAmount"];
        }
        [self updateOrderWithDict:couponDict skuArr:skusArr];
    }];
}

#pragma mark ------ 修改订单 ------
- (void)updateOrderWithDict:(NSDictionary *)param skuArr:(NSArray *)skuArr {
    NSMutableDictionary *orderDict = [[NSMutableDictionary alloc] init];
    [orderDict setValue:param forKey:@"orderInfo"];
    NSMutableArray *skusArr = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *muDict in skuArr) {
        BOOL contain = NO;
        for (NSMutableDictionary *dict in skusArr) {
            if ([dict[@"id"] isEqualToString:muDict[@"id"]]) {
                contain = YES;
                break;
            }
        }
        if (contain) {
            for (NSMutableDictionary *skuDict in skusArr) {
                if ([skuDict[@"id"] isEqualToString:muDict[@"id"]]) {
                    [skuDict setValue:@([skuDict[@"num"] intValue] +1) forKey:@"num"];
                    if (skuDict[@"service"]) {
                        NSMutableDictionary *serDict = [skuDict[@"service"] firstObject];
                        [serDict setValue:skuDict[@"num"] forKey:@"num"];
                    }
                    break;
                }
            }
        } else {
            [skusArr addObject:muDict];
        }
    }
    [orderDict setValue:skusArr forKey:@"skus"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderDict options:kNilOptions error:nil];
    [ADLNetWorkManager postStringPath:k_update_order stringData:jsonData autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"修改成功"];
            self.orderId = responseDict[@"data"][@"orderId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER_LIST object:nil userInfo:nil];
            [self updateOrder];
        }
    } failure:nil];
}

#pragma mark ------ 获取订单详情 ------
- (void)getOrderData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.orderId forKey:@"orderId"];
    [params setValue:self.suborderId forKey:@"subOrderId"];
    [ADLNetWorkManager postWithPath:k_order_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            NSDictionary *ordDict = dict[@"orderVO"];
            self.addressId = ordDict[@"addrId"];
            self.expressId = ordDict[@"expressCompanyId"];
            self.freight = [ordDict[@"freight"] doubleValue];
            if ([ordDict[@"couponPrice"] doubleValue] > 0) {
                self.couponDict = @{@"amount":ordDict[@"couponPrice"], @"id":ordDict[@"couponId"], @"orderAmount":ordDict[@"couponMinPrice"]};
            }
            
            NSDictionary *orderDict = [ordDict[@"suborderList"] firstObject];
            NSArray *serArr = orderDict[@"serviceInfoList"];
            NSInteger status = [ordDict[@"status"] integerValue];
            BOOL service = [ordDict[@"orderType"] boolValue];
            self.serviceOrder = service;
            self.status = status;
            if (status == 0) {
                self.firstBtn.hidden = NO;
                self.secondBtn.hidden = NO;
                self.bottomView.hidden = NO;
                [self.firstBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.secondBtn setTitle:@"去付款" forState:UIControlStateNormal];
            } else if (status == 1) {
                self.secondBtn.hidden = NO;
                self.bottomView.hidden = NO;
                if ([orderDict[@"customerStatus"] intValue] != 0) {
                    self.firstBtn.hidden = NO;
                    [self.firstBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                }
                [self.secondBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
            } else if (status == 2 || status == 5 || status == 6) {
                if (service) {
                    self.tableView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H);
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
                } else {
                    self.secondBtn.hidden = NO;
                    self.bottomView.hidden = NO;
                    [self.secondBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                }
            } else if (status == 3) {
                self.secondBtn.hidden = NO;
                self.bottomView.hidden = NO;
                [self.secondBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            } else if (status == 4) {
                self.firstBtn.hidden = NO;
                self.secondBtn.hidden = NO;
                self.bottomView.hidden = NO;
                [self.firstBtn setTitle:@"选择配件" forState:UIControlStateNormal];
                if ([orderDict[@"customerStatus"] intValue] == 0) {
                    [self.secondBtn setTitle:@"确认完成" forState:UIControlStateNormal];
                } else {
                    [self.secondBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                }
                
            } else {
                
            }
            
            self.lockerDict = dict[@"serviceArtisan"];
            if (self.lockerDict) {
                [self.lockerDict setValue:[NSString stringWithFormat:@"预计上门时间：%@",[ADLUtils getDateFromTimestamp:[self.lockerDict[@"appointedTime"] doubleValue] format:@"yyyy-MM-dd HH:mm"]] forKey:@"time"];
                [self.lockerDict setValue:dict[@"address"][@"coordinates"] forKey:@"userLocation"];
            }
            
            if (service) {
                for (NSMutableDictionary *serDict in serArr) {
                    [serDict setValue:@(service) forKey:@"orderType"];
                    [serDict setValue:@(status) forKey:@"status"];
                    [serDict setValue:@([[serDict[@"customerStatus"] firstObject] integerValue]) forKey:@"customerStatus"];
                }
                [self.dataArr addObjectsFromArray:serArr];
                
            } else {
                self.expDict = dict[@"orderExpress"];
                NSArray *goodsArr = orderDict[@"orderGoodsList"];
                
                for (NSMutableDictionary *goodsDict in goodsArr) {
                    [goodsDict setValue:@(service) forKey:@"orderType"];
                    [goodsDict setValue:@(status) forKey:@"status"];
                    [goodsDict setValue:@([[goodsDict[@"customerStatus"] firstObject] integerValue]) forKey:@"customerStatus"];
                    
                    NSArray *attrArr = [NSJSONSerialization JSONObjectWithData:[goodsDict[@"goodsProperty"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                    NSMutableString *attrStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"数量：%@    规格：",goodsDict[@"goodsNum"]]];
                    for (NSDictionary *attrDict in attrArr) {
                        [attrStr appendString:attrDict[@"propertyValue"]];
                        [attrStr appendString:@", "];
                    }
                    [goodsDict setValue:[attrStr substringToIndex:attrStr.length-2] forKey:@"attribute"];
                    if (serArr.count > 0) {
                        for (NSDictionary *serDict in serArr) {
                            if ([serDict[@"skuId"] isEqualToString:goodsDict[@"skuId"]]) {
                                [goodsDict setValue:serDict forKey:@"service"];
                                [goodsDict setValue:[NSString stringWithFormat:@"服务    %@",serDict[@"serviceName"]] forKey:@"serviceStr"];
                                [goodsDict setValue:[NSString stringWithFormat:@"¥ %.2f x%@",[serDict[@"price"] doubleValue],goodsDict[@"goodsNum"]] forKey:@"startingPrice"];
                            }
                        }
                    }
                }
                [self.dataArr addObjectsFromArray:goodsArr];
            }
            
            ADLOrderDetailHeader *headerView = [ADLOrderDetailHeader headerViewWithStatus:status lockerDict:self.lockerDict goods:!service];
            headerView.delegate = self;
            self.tableView.tableHeaderView = headerView;
            
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
            footerView.backgroundColor = [UIColor whiteColor];
            
            UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 0.5)];
            spView.backgroundColor = SEPARATOR_COLOR;
            [footerView addSubview:spView];
            
            UILabel *payMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, SCREEN_WIDTH-24, 40)];
            payMoneyLab.font = [UIFont systemFontOfSize:FONT_SIZE];
            payMoneyLab.textAlignment = NSTextAlignmentRight;
            payMoneyLab.textColor = APP_COLOR;
            [footerView addSubview:payMoneyLab];
            self.payMoneyLab = payMoneyLab;
            self.tableView.tableFooterView = footerView;
            
            //订单信息
            NSString *orderDate = [NSString stringWithFormat:@"下单日期：%@",[ADLUtils getDateFromTimestamp:[ordDict[@"addDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm:ss"]];
            [self.orderInfArr addObject:[NSString stringWithFormat:@"订单编号：%@",self.suborderId]];
            [self.orderInfArr addObject:orderDate];
            if (dict[@"payment"][@"name"] && status != 0) {
                [self.orderInfArr addObject:[NSString stringWithFormat:@"支付方式：%@",dict[@"payment"][@"name"]]];
            }
            if (dict[@"orderExpress"][@"expressName"]) {
                [self.orderInfArr addObject:[NSString stringWithFormat:@"配送方式：%@",dict[@"orderExpress"][@"expressName"]]];
                [self.orderInfArr addObject:[NSString stringWithFormat:@"快递单号：%@",dict[@"orderExpress"][@"shipCode"]]];
            }
            
            //发票信息
            if (dict[@"receipt"][@"id"]) {
                self.invoiceId = dict[@"receipt"][@"id"];
                if ([dict[@"receipt"][@"type"] boolValue]) {
                    [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票类型：增值税专用发票(纸质)"]];
                } else {
                    [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票类型：普通发票(纸质)"]];
                }
                if ([dict[@"receipt"][@"title"] boolValue]) {
                    [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票抬头：单位"]];
                } else {
                    [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票抬头：个人"]];
                }
                if ([dict[@"receipt"][@"content"] boolValue]) {
                    [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票内容：商品类别"]];
                } else {
                    [self.invoiceInfArr addObject:[NSString stringWithFormat:@"发票内容：商品明细"]];
                }
            }
            
            //保险单信息
            NSArray *insArr = orderDict[@"orderInsurance"];
            if (insArr.count > 0) {
                for (NSDictionary *dict in insArr) {
                    if (dict[@"insuranceMoney"]) {
                        [self.insuranceArr addObject:dict];
                    }
                }
            }
            
            self.tableView.hidden = NO;
            [self calculateTotalMoney];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
                NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
                NSArray *provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSString *cityId = [ADLUtils queryAddressWithDataArr:provinceArr areaId:[ordDict[@"areaId"] stringValue]].cityId;
                [self getLockServiceData:cityId];
            });
        }
    } failure:nil];
}

#pragma mark ------ 更新订单 ------
- (void)updateOrder {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.orderId forKey:@"orderId"];
    [ADLNetWorkManager postWithPath:k_order_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            NSDictionary *ordDict = dict[@"orderVO"];
            self.addressId = ordDict[@"addrId"];
            self.expressId = ordDict[@"expressCompanyId"];
            self.freight = [ordDict[@"freight"] doubleValue];
            if ([ordDict[@"couponPrice"] doubleValue] > 0) {
                self.couponDict = @{@"amount":ordDict[@"couponPrice"], @"id":ordDict[@"couponId"], @"orderAmount":ordDict[@"couponMinPrice"]};
            } else {
                self.couponDict = nil;
            }
            
            [self.dataArr removeAllObjects];
            NSDictionary *orderDict = [ordDict[@"suborderList"] firstObject];
            self.suborderId = orderDict[@"id"];
            NSArray *serArr = orderDict[@"serviceInfoList"];
            NSInteger status = [ordDict[@"status"] integerValue];
            BOOL service = [ordDict[@"orderType"] boolValue];
            if (service) {
                for (NSMutableDictionary *serDict in serArr) {
                    [serDict setValue:@(service) forKey:@"orderType"];
                    [serDict setValue:@(status) forKey:@"status"];
                    [serDict setValue:@([[serDict[@"customerStatus"] firstObject] integerValue]) forKey:@"customerStatus"];
                }
                [self.dataArr addObjectsFromArray:serArr];
                
            } else {
                NSArray *goodsArr = orderDict[@"orderGoodsList"];
                for (NSMutableDictionary *goodsDict in goodsArr) {
                    [goodsDict setValue:@(service) forKey:@"orderType"];
                    [goodsDict setValue:@(status) forKey:@"status"];
                    [goodsDict setValue:@([[goodsDict[@"customerStatus"] firstObject] integerValue]) forKey:@"customerStatus"];
                    
                    NSArray *attrArr = [NSJSONSerialization JSONObjectWithData:[goodsDict[@"goodsProperty"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                    NSMutableString *attrStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"数量：%@    规格：",goodsDict[@"goodsNum"]]];
                    for (NSDictionary *attrDict in attrArr) {
                        [attrStr appendString:attrDict[@"propertyValue"]];
                        [attrStr appendString:@", "];
                    }
                    [goodsDict setValue:[attrStr substringToIndex:attrStr.length-2] forKey:@"attribute"];
                    if (serArr.count > 0) {
                        for (NSDictionary *serDict in serArr) {
                            if ([serDict[@"skuId"] isEqualToString:goodsDict[@"skuId"]]) {
                                [goodsDict setValue:serDict forKey:@"service"];
                                [goodsDict setValue:[NSString stringWithFormat:@"服务    %@",serDict[@"serviceName"]] forKey:@"serviceStr"];
                                [goodsDict setValue:[NSString stringWithFormat:@"¥ %.2f x%@",[serDict[@"price"] doubleValue],goodsDict[@"goodsNum"]] forKey:@"startingPrice"];
                            }
                        }
                    }
                }
                [self.dataArr addObjectsFromArray:goodsArr];
            }
            
            //订单信息
            [self.orderInfArr removeAllObjects];
            NSString *orderDate = [NSString stringWithFormat:@"下单日期：%@",[ADLUtils getDateFromTimestamp:[ordDict[@"addDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm:ss"]];
            [self.orderInfArr addObject:[NSString stringWithFormat:@"订单编号：%@",self.suborderId]];
            [self.orderInfArr addObject:orderDate];
            if (dict[@"payment"][@"name"]) {
                [self.orderInfArr addObject:[NSString stringWithFormat:@"支付方式：%@",dict[@"payment"][@"name"]]];
            }
            if (dict[@"orderExpress"][@"expressName"]) {
                [self.orderInfArr addObject:[NSString stringWithFormat:@"配送方式：%@",dict[@"orderExpress"][@"expressName"]]];
                [self.orderInfArr addObject:[NSString stringWithFormat:@"快递单号：%@",dict[@"orderExpress"][@"shipCode"]]];
            }
            [self calculateTotalMoney];
        }
    } failure:nil];
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

@end
