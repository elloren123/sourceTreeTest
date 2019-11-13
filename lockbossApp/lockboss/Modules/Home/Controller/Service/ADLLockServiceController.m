//
//  ADLLockingController.m
//  lockboss
//
//  Created by adel on 2019/6/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLLockServiceController.h"
#import "ADLServicePriceController.h"
#import "ADLSelectServiceController.h"
#import "ADLSelectCouponController.h"
#import "ADLSelectLockerController.h"
#import "ADLServiceNoteController.h"
#import "ADLShipAddressController.h"
#import "ADLServicePayController.h"

#import "ADLMineViewCell.h"
#import "ADLAddServiceCell.h"
#import "ADLMoneyTextCell.h"
#import "ADLServiceAddressCell.h"
#import "ADLServicePickerView.h"

#import "ADLServiceModel.h"

@interface ADLLockServiceController ()<UITableViewDelegate,UITableViewDataSource,ADLAddServiceCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableDictionary *addressDict;
@property (nonatomic, strong) NSDictionary *lockerDict;
@property (nonatomic, strong) NSDictionary *couponDict;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, assign) double serviceMoney;
@property (nonatomic, assign) double totalMoney;
@property (nonatomic, assign) double expediteMoney;
@property (nonatomic, strong) NSDictionary *expediteDict;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, assign) BOOL expedite;
@end

@implementation ADLLockServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"开锁换锁"];
    [self addRightButtonWithTitle:@"服务价目" action:@selector(clickServicePriceBtn)];
    
    self.expedite = NO;
    self.serviceMoney = 0;
    self.totalMoney = 0;
    self.expediteMoney = 0;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT+123)];
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 26)];
    moneyLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    moneyLab.textAlignment = NSTextAlignmentRight;
    moneyLab.textColor = COLOR_333333;
    [footerView addSubview:moneyLab];
    self.moneyLab = moneyLab;
    
    UIButton *bookingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bookingBtn.frame = CGRectMake(12, 60, SCREEN_WIDTH-24, VIEW_HEIGHT);
    [bookingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookingBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [bookingBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    bookingBtn.backgroundColor = APP_COLOR;
    bookingBtn.layer.cornerRadius = CORNER_RADIUS;
    [bookingBtn addTarget:self action:@selector(clickBookingBtn) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:bookingBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = footerView;
    self.tableView = tableView;
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    self.provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [self getAddressData];
}

#pragma mark ------ 服务价目 ------
- (void)clickServicePriceBtn {
    if (self.addressDict == nil) {
        [ADLToast showMessage:@"请先添加安装地址"];
    } else {
        ADLServicePriceController *priceVC = [[ADLServicePriceController alloc] init];
        priceVC.areaId = self.addressDict[@"cityId"];
        [self.navigationController pushViewController:priceVC animated:YES];
    }
}

#pragma mark ------ UITableViewDelegate && DataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count;
    } else if (section == 1) {
        return 4;
    } else{
        if (self.expedite) {
            return 3;
        } else {
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 8;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    headerView.backgroundColor = COLOR_F2F2F2;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return VIEW_HEIGHT;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        addBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT);
        [addBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [addBtn setTitle:@"+ 添加服务" forState:UIControlStateNormal];
        addBtn.backgroundColor = [UIColor whiteColor];
        [addBtn addTarget:self action:@selector(clickAddServiceBtn) forControlEvents:UIControlEventTouchUpInside];
        return addBtn;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 99;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1 && self.addressDict) {
            return 73;
        } else {
            return ROW_HEIGHT;
        }
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 25;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ADLAddServiceCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:@"AddServiceCell"];
        if (serviceCell == nil) {
            serviceCell = [[NSBundle mainBundle] loadNibNamed:@"ADLAddServiceCell" owner:nil options:nil].lastObject;
            serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            serviceCell.delegate = self;
        }
        ADLServiceModel *model = self.dataArr[indexPath.row];
        serviceCell.serviceLab.text = model.serviceName;
        serviceCell.countLab.text = [NSString stringWithFormat:@"%lu",model.serviceCount];
        return serviceCell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            ADLServiceAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceAddressCell"];
            if (addressCell == nil) {
                addressCell = [[NSBundle mainBundle] loadNibNamed:@"ADLServiceAddressCell" owner:nil options:nil].lastObject;
                addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.addressDict) {
                addressCell.promptLab.hidden = YES;
                addressCell.nameLab.text = self.addressDict[@"name"];
                addressCell.addressLab.text = self.addressDict[@"address"];
            } else {
                addressCell.promptLab.hidden = NO;
                addressCell.nameLab.text = @"";
                addressCell.addressLab.text = @"";
            }
            return addressCell;
        } else {
            ADLMineViewCell *mineCell = [tableView dequeueReusableCellWithIdentifier:@"mine"];
            if (mineCell == nil) {
                mineCell = [[NSBundle mainBundle] loadNibNamed:@"ADLMineViewCell" owner:nil options:nil].lastObject;
                mineCell.selectionStyle = UITableViewCellSelectionStyleNone;
                mineCell.spView.hidden = YES;
                mineCell.bottomView.hidden = NO;
            }
            if (indexPath.row == 0) {
                mineCell.imgView.image = [UIImage imageNamed:@"service_time"];
                if (self.dateStr) {
                    mineCell.label.textColor = COLOR_333333;
                    mineCell.label.text = self.dateStr;
                } else {
                    mineCell.label.textColor = PLACEHOLDER_COLOR;
                    mineCell.label.text = @"选择上门时间";
                }
            } else if (indexPath.row == 2) {
                mineCell.imgView.image = [UIImage imageNamed:@"service_locker"];
                if (self.lockerDict) {
                    mineCell.label.textColor = COLOR_333333;
                    mineCell.label.text = self.lockerDict[@"name"];
                } else {
                    mineCell.label.textColor = PLACEHOLDER_COLOR;
                    mineCell.label.text = @"选择锁匠";
                }
            } else {
                mineCell.imgView.image = [UIImage imageNamed:@"service_coupon"];
                if (self.couponDict) {
                    mineCell.label.textColor = COLOR_333333;
                    mineCell.label.text = self.dateStr;
                } else {
                    mineCell.label.textColor = PLACEHOLDER_COLOR;
                    mineCell.label.text = @"选择优惠券";
                }
            }
            return mineCell;
        }
    } else {
        ADLMoneyTextCell *doubleCell = [tableView dequeueReusableCellWithIdentifier:@"double"];
        if (doubleCell == nil) {
            doubleCell = [[ADLMoneyTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"double"];
            doubleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            doubleCell.spView.hidden = YES;
        }
        NSInteger index = 0;
        if (self.expedite == NO) {
            index = -1;
        }
        if (indexPath.row == 0) {
            doubleCell.top = NO;
            doubleCell.titLab.text = @"服务费用";
            doubleCell.descLab.text = [NSString stringWithFormat:@"¥ %.2f",self.serviceMoney];
        } else if (indexPath.row == index+1) {
            doubleCell.top = YES;
            doubleCell.titLab.text = @"加急费用";
            doubleCell.descLab.text = [NSString stringWithFormat:@"¥ %.2f",self.expediteMoney];
        } else {
            doubleCell.top = YES;
            doubleCell.titLab.text = @"优惠券抵扣";
            doubleCell.descLab.text = [NSString stringWithFormat:@"-¥ %.2f",[self.couponDict[@"amount"] doubleValue]];
        }
        return doubleCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.addressDict) {
                [ADLServicePickerView showPickerWithFinishBlock:^(NSString *dateStr, NSInteger year) {
                    if ([dateStr isEqualToString:@"加急"]) {
                        self.expedite = YES;
                        self.dateStr = @"加急（约半小时后到达）";
                        self.timestamp = nil;
                        self.expediteMoney = [self.expediteDict[@"startingPrice"] doubleValue];
                    } else {
                        self.expedite = NO;
                        self.timestamp = [ADLUtils timestampWithDateStr:[NSString stringWithFormat:@"%lu年%@",year,dateStr] format:@"yyyy年MM月dd日 HH:mm"];
                        self.dateStr = [NSString stringWithFormat:@"%@ 前到达",dateStr];
                        self.expediteMoney = 0;
                    }
                    [self calculateMoney];
                }];
            } else {
                [ADLToast showMessage:@"请选择安装地址"];
            }
        } else if (indexPath.row == 1) {
            ADLShipAddressController *shipVC = [[ADLShipAddressController alloc] init];
            shipVC.clickAddress = ^(NSDictionary *addressDict) {
                [self.addressDict removeAllObjects];
                [self.addressDict setValue:addressDict[@"id"] forKey:@"id"];
                [self.addressDict setValue:addressDict[@"phone"] forKey:@"phone"];
                [self.addressDict setValue:addressDict[@"cityId"] forKey:@"cityId"];
                [self.addressDict setValue:addressDict[@"consignee"] forKey:@"consignee"];
                [self.addressDict setValue:[addressDict[@"areaStr"] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"address"];
                [self.addressDict setValue:[NSString stringWithFormat:@"%@  %@",addressDict[@"consignee"],addressDict[@"phone"]] forKey:@"name"];
                [self.dataArr removeAllObjects];
                self.lockerDict = nil;
                self.couponDict = nil;
                [self getExpediteCost];
            };
            [self.navigationController pushViewController:shipVC animated:YES];
        } else if (indexPath.row == 2) {
            if (self.addressDict) {
                ADLSelectLockerController *lockerVC = [[ADLSelectLockerController alloc] init];
                lockerVC.address = self.addressDict[@"address"];
                lockerVC.clickAction = ^(NSDictionary *lockerDict) {
                    self.lockerDict = lockerDict;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:lockerVC animated:YES];
            } else {
                [ADLToast showMessage:@"请选择安装地址"];
            }
        } else {
            ADLSelectCouponController *couponVC = [[ADLSelectCouponController alloc] init];
            couponVC.orderType = 0;
            couponVC.servicePrice = self.serviceMoney;
            couponVC.money = self.serviceMoney+self.expediteMoney;
            couponVC.clickCoupon = ^(NSDictionary *couponDict) {
                self.couponDict = couponDict;
                [self calculateMoney];
            };
            [self.navigationController pushViewController:couponVC animated:YES];
        }
    }
}

#pragma mark ------ 加 ------
- (void)didClickAddBtn:(UIButton *)sender count:(NSInteger)count {
    ADLAddServiceCell *cell = (ADLAddServiceCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLServiceModel *model = self.dataArr[indexPath.row];
    model.serviceCount = model.serviceCount+1;
    [self calculateMoney];
}

#pragma mark ------ 减 ------
- (void)didClickReduceBtn:(UIButton *)sender count:(NSInteger)count {
    ADLAddServiceCell *cell = (ADLAddServiceCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLServiceModel *model = self.dataArr[indexPath.row];
    model.serviceCount = model.serviceCount-1;
    if (model.serviceCount == 0) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
    }
    [self calculateMoney];
}

#pragma mark ------ 备注 ------
- (void)didClickMarkBtn:(UIButton *)sender {
    ADLMineViewCell *cell = (ADLMineViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ADLServiceNoteController *noteVC = [[ADLServiceNoteController alloc] init];
    noteVC.model = self.dataArr[indexPath.row];
    noteVC.clickConfirm = ^(ADLServiceModel *model) {
        [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
    };
    [self.navigationController pushViewController:noteVC animated:YES];
}

#pragma mark ------ 计算金额 ------
- (void)calculateMoney {
    self.serviceMoney = 0;
    for (ADLServiceModel *model in self.dataArr) {
        self.serviceMoney = self.serviceMoney+model.servicePrice*model.serviceCount;
    }
    double couponMoney = [self.couponDict[@"amount"] doubleValue];
    self.totalMoney = self.serviceMoney+self.expediteMoney-couponMoney;
    if (self.totalMoney < 0) {
        self.totalMoney = 0;
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥ %.2f",self.totalMoney]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(3, attributeStr.length-3)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_SIZE] range:NSMakeRange(3, attributeStr.length-3)];
    self.moneyLab.attributedText = attributeStr;
    [self.tableView reloadData];
}

#pragma mark ------ 添加服务 ------
- (void)clickAddServiceBtn {
    if (self.addressDict == nil) {
        [ADLToast showMessage:@"请先添加安装地址"];
    } else {
        ADLSelectServiceController *serviceVC = [[ADLSelectServiceController alloc] init];
        serviceVC.areaId = self.addressDict[@"cityId"];
        serviceVC.clickAction = ^(NSMutableDictionary *serviceDict) {
            BOOL contain = NO;
            for (ADLServiceModel *model in self.dataArr) {
                if ([model.serviceId isEqualToString:serviceDict[@"id"]]) {
                    model.serviceCount = model.serviceCount+1;
                    contain = YES;
                    break;
                }
            }
            if (!contain) {
                ADLServiceModel *model = [[ADLServiceModel alloc] init];
                model.serviceId = serviceDict[@"id"];
                model.serviceName = serviceDict[@"name"];
                model.serviceCount = 1;
                model.servicePrice = [serviceDict[@"startingPrice"] doubleValue];
                [self.dataArr addObject:model];
            }
            [self calculateMoney];
        };
        [self.navigationController pushViewController:serviceVC animated:YES];
    }
}

#pragma mark ------ 立即预约 ------
- (void)clickBookingBtn {
    if (self.dataArr.count == 0) {
        [ADLToast showMessage:@"请添加服务"];
        return;
    }
    if (self.dateStr == nil) {
        [ADLToast showMessage:@"请选择服务时间"];
        return;
    }
    if (self.lockerDict == nil) {
        [ADLToast showMessage:@"请选择锁匠"];
        return;
    }
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSInteger imgCount = 0;
    for (ADLServiceModel *model in self.dataArr) {
        [model.noteImageUrlArr removeAllObjects];
        imgCount = model.noteImageArr.count+imgCount;
    }
    if (imgCount > 0) {
        NSMutableArray *proArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < imgCount; i++) {
            [proArr addObject:@(0.0)];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_group_t group = dispatch_group_create();
            for (int i = 0; i < self.dataArr.count; i++) {
                ADLServiceModel *model = self.dataArr[i];
                if (model.noteImageArr.count > 0) {
                    for (int j = 0; j < model.noteImageArr.count; j++) {
                        dispatch_group_enter(group);
                        NSData *data = [ADLUtils compressImageQuality:model.noteImageArr[j] maxLength:IMAGE_MAX_LENGTH];
                        [ADLNetWorkManager postImagePath:k_upload_image parameters:nil imageDataArr:@[data] imageName:@"img" autoToast:NO progress:^(NSProgress *progress) {
                            
                            NSInteger kindex = 0;
                            for (NSInteger k = 0; k < i; k++) {
                                ADLServiceModel *kmodel = self.dataArr[k];
                                kindex = kindex+kmodel.noteImageArr.count;
                            }
                            [proArr replaceObjectAtIndex:kindex+j withObject:@(progress.fractionCompleted)];
                            double totalProgress = 0;
                            for (NSNumber *number in proArr) {
                                totalProgress = totalProgress+[number doubleValue];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [ADLToast showLoadingMessage:[NSString stringWithFormat:@"图片上传中(%.0f/%ld)",totalProgress,imgCount]];
                            });
                            
                        } success:^(NSDictionary *responseDict) {
                            if ([responseDict[@"code"] integerValue] == 10000) {
                                [model.noteImageUrlArr addObject:[responseDict[@"data"] firstObject][@"imgUrl"]];
                            }
                            dispatch_group_leave(group);
                        } failure:^(NSError *error) {
                            dispatch_group_leave(group);
                        }];
                    }
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSInteger imgUrlCount = 0;
                for (ADLServiceModel *model in self.dataArr) {
                    imgUrlCount = model.noteImageUrlArr.count+imgUrlCount;
                }
                if (imgCount != imgUrlCount) {
                    [ADLToast showMessage:@"图片上传失败！"];
                } else {
                    [self submitServiceOrder];
                }
            });
        });
    } else {
        [self submitServiceOrder];
    }
}

#pragma mark ------ 提交服务订单 ------
- (void)submitServiceOrder {
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *orderDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfDict = [[NSMutableDictionary alloc] init];
    [orderInfDict setValue:[NSString stringWithFormat:@"%.2f",self.serviceMoney+self.expediteMoney] forKey:@"goodsAmount"];
    [orderInfDict setValue:[NSString stringWithFormat:@"%.2f",self.totalMoney] forKey:@"payAmount"];
    [orderInfDict setValue:self.addressDict[@"id"] forKey:@"addrId"];
    [orderInfDict setValue:self.couponDict[@"id"] forKey:@"couponId"];
    [orderInfDict setValue:self.lockerDict[@"drivingDistance"] forKey:@"distance"];
    
    if (self.timestamp == nil) {
        [orderInfDict setValue:[ADLUtils timestampWithMinuteDelay:30] forKey:@"appointedTime"];
    } else {
        [orderInfDict setValue:self.timestamp forKey:@"appointedTime"];
    }
    [orderDict setValue:orderInfDict forKey:@"orderInfo"];
    
    NSMutableArray *serviceArr = [[NSMutableArray alloc] init];
    for (ADLServiceModel *model in self.dataArr) {
        NSMutableDictionary *serDict = [[NSMutableDictionary alloc] init];
        [serDict setValue:model.serviceId forKey:@"id"];
        [serDict setValue:@(model.serviceCount) forKey:@"num"];
        [serDict setValue:self.lockerDict[@"id"] forKey:@"uid"];
        [serDict setValue:@(model.servicePrice) forKey:@"price"];
        [serDict setValue:model.serviceNote forKey:@"userMsg"];
        if (model.noteImageUrlArr.count > 0) {
            [serDict setValue:[model.noteImageUrlArr componentsJoinedByString:@","] forKey:@"serviceSceneImg"];
        }
        [serviceArr addObject:serDict];
    }
    if (self.timestamp == nil) {
        NSMutableDictionary *expDict = [[NSMutableDictionary alloc] init];
        [expDict setValue:self.expediteDict[@"id"] forKey:@"id"];
        [expDict setValue:@(1) forKey:@"num"];
        [expDict setValue:self.lockerDict[@"id"] forKey:@"uid"];
        [expDict setValue:self.expediteDict[@"startingPrice"] forKey:@"price"];
        [serviceArr addObject:expDict];
    }
    
    [orderDict setValue:serviceArr forKey:@"service"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderDict options:kNilOptions error:nil];
    
    [ADLNetWorkManager postStringPath:k_submit_order stringData:jsonData autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast hide];
            ADLServicePayController *payVC = [[ADLServicePayController alloc] init];
            payVC.dateStr = self.dateStr;
            payVC.money = self.totalMoney;
            payVC.phoneStr = self.addressDict[@"phone"];
            payVC.nameStr = self.addressDict[@"consignee"];
            payVC.addressStr = self.addressDict[@"address"];
            payVC.orderId = responseDict[@"data"][@"orderId"];
            [self.navigationController pushViewController:payVC animated:YES];
        }
    } failure:nil];
}

#pragma mark ------ 收货地址 ------
- (void)getAddressData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [ADLNetWorkManager postWithPath:k_query_address_list parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    if ([dict[@"isDefault"] integerValue] == 0) {
                        self.addressDict = dict;
                        break;
                    }
                }
                if (self.addressDict == nil) {
                    self.addressDict = resArr.firstObject;
                }
                AddressInfo info = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[self.addressDict[@"areaId"] stringValue]];
                NSString *address = [NSString stringWithFormat:@"%@%@",info.address,self.addressDict[@"address"]];
                [self.addressDict setValue:address forKey:@"address"];
                [self.addressDict setValue:info.cityId forKey:@"cityId"];
                [self.addressDict setValue:[NSString stringWithFormat:@"%@  %@",self.addressDict[@"consignee"],self.addressDict[@"phone"]] forKey:@"name"];
            }
            [self getExpediteCost];
        }
    } failure:nil];
}

#pragma mark ------ 加急费用 ------
- (void)getExpediteCost {
    self.expediteDict = nil;
    self.expediteMoney = 0;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.addressDict[@"cityId"] forKey:@"areaId"];
    [ADLNetWorkManager postWithPath:k_query_all_service parameters:params autoToast:NO success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            for (NSDictionary *dict in resArr) {
                if ([dict[@"serviceTypeId"] integerValue] == 4) {
                    self.expediteDict = dict;
                    if ([self.dateStr hasPrefix:@"加急"]) {
                        self.expediteMoney = [dict[@"startingPrice"] doubleValue];
                    }
                    break;
                }
            }
        }
        [self calculateMoney];
    } failure:nil];
}

@end
