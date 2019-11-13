//
//  ADLAftersaleDetailController.m
//  lockboss
//
//  Created by adel on 2019/7/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAftersaleDetailController.h"
#import "ADLProgressDetailController.h"
#import "ADLAftersaleDetailCell.h"
#import "ADLAfterDetailHeader.h"
#import "ADLAfterDetailFooter.h"
#import "ADLImagePreView.h"

@interface ADLAftersaleDetailController ()<UITableViewDelegate,UITableViewDataSource,ADLAftersaleProViewDelegate>
@property (nonatomic, strong) ADLAfterDetailHeader *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSArray *detailArr;
@property (nonatomic, strong) NSArray *imgArr;
@end

@implementation ADLAftersaleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"售后服务单详情"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 94;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self getAftersaleData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLAftersaleDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"AftersaleDetailCell"];
    if (detailCell == nil) {
        detailCell = [[NSBundle mainBundle] loadNibNamed:@"ADLAftersaleDetailCell" owner:nil options:nil].lastObject;
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    if (dict[@"goodsId"]) {
        [detailCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"goodsImg"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        detailCell.nameLab.text = dict[@"goodsName"];
        NSString *descStr = [NSString stringWithFormat:@"单价：¥%.2f  申请数量：%@",[dict[@"price"] doubleValue],dict[@"goodsNum"]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:descStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:NSMakeRange(0, 3)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:[descStr rangeOfString:@"申请数量："]];
        detailCell.descLab.attributedText = attributeStr;
    } else {
        [detailCell.imgView sd_setImageWithURL:[NSURL URLWithString:[dict[@"imgUrl"] stringValue]] placeholderImage:[UIImage imageNamed:@"img_square"]];
        detailCell.nameLab.text = dict[@"name"];
        NSString *descStr = [NSString stringWithFormat:@"单价：¥%.2f  申请数量：%@",[dict[@"price"] doubleValue],dict[@"num"]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:descStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:NSMakeRange(0, 3)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:[descStr rangeOfString:@"申请数量："]];
        detailCell.descLab.attributedText = attributeStr;
    }
    return detailCell;
}

#pragma mark ------ 处理详情 ------
- (void)didClickProgressDetailBtn {
    ADLProgressDetailController *detailVC = [[ADLProgressDetailController alloc] init];
    detailVC.progArr = self.detailArr;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ------ 获取售后详情数据 ------
- (void)getAftersaleData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.aftersaleId forKey:@"customerId"];
    [ADLNetWorkManager postWithPath:k_query_after_sale_detail parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSDictionary *dict = responseDict[@"data"];
            self.detailArr = dict[@"customerHandleInfoVOList"];
            [self initializationHeaderFooter:dict];
        }
    } failure:nil];
}

#pragma mark ------ 初始化Header ------
- (void)initializationHeaderFooter:(NSDictionary *)dict {
    ADLAfterDetailHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"ADLAfterDetailHeader" owner:nil options:nil].lastObject;
    headerView.delegate = self;
    self.headerView = headerView;
    
    NSInteger status = [dict[@"status"] integerValue];
    NSInteger type = [dict[@"type"] integerValue];
    NSInteger progress = 1;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 245);
    NSString *typeStr;
    NSString *addressStr;
    if (type == 0) {
        typeStr = @"(退货处理中)";
        if (status != 0 && status != 4) {
            if (status == 1 || status == 2) {
                progress = 2;
            }
            if (status == 3) {
                progress = 3;
            }
            if (status == 5 || status == 6) {
                progress = 4;
            }
            if (status == 9) {
                progress = 5;
                typeStr = @"(退货完成)";
            }
            addressStr = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[dict[@"customerAddress"][@"areaId"] stringValue]].address;
            addressStr = [NSString stringWithFormat:@"%@%@",addressStr,dict[@"customerAddress"][@"address"]];
            CGFloat addressH = [ADLUtils calculateString:addressStr rectSize:CGSizeMake(SCREEN_WIDTH-96, MAXFLOAT) fontSize:14].height;
            if (addressH < 25) {
                frame.size.height = 672;
            } else {
                frame.size.height = 655+addressH;
            }
        }
        headerView.frame = frame;
        if (status == 4) {
            [headerView addProgressViewWithTitles:@[@"提交申请",@"商家审核",@"申请驳回"] progress:3];
        } else {
            [headerView addProgressViewWithTitles:@[@"提交申请",@"商家审核",@"商家收货",@"商家处理",@"完成"] progress:progress];
        }
        
    } else if (type == 1) {
        typeStr = @"(换货处理中)";
        if (status != 0 && status != 4) {
            if (status == 1 || status == 2) {
                progress = 2;
            }
            if (status == 3 || status == 5) {
                progress = 3;
            }
            if (status == 7) {
                progress = 4;
            }
            if (status == 8) {
                progress = 4;
                UIButton *receiptBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                receiptBtn.frame = CGRectMake(0, SCREEN_HEIGHT-VIEW_HEIGHT-BOTTOM_H, SCREEN_WIDTH, VIEW_HEIGHT);
                [receiptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                receiptBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
                [receiptBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [receiptBtn addTarget:self action:@selector(clickConfirmReceiptBtn) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:receiptBtn];
                self.tableView.frame = CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-VIEW_HEIGHT);
                self.tableView.contentInset = UIEdgeInsetsZero;
            }
            if (status == 9) {
                progress = 5;
                typeStr = @"(换货完成)";
            }
            addressStr = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[dict[@"customerAddress"][@"areaId"] stringValue]].address;
            addressStr = [NSString stringWithFormat:@"%@%@",addressStr,dict[@"customerAddress"][@"address"]];
            CGFloat addrH = [ADLUtils calculateString:addressStr rectSize:CGSizeMake(SCREEN_WIDTH-96, MAXFLOAT) fontSize:14].height;
            if (addrH < 25) {
                frame.size.height = 672;
            } else {
                frame.size.height = 655+addrH;
            }
        }
        headerView.frame = frame;
        if (status == 4) {
            [headerView addProgressViewWithTitles:@[@"提交申请",@"商家审核",@"申请驳回"] progress:3];
        } else {
            [headerView addProgressViewWithTitles:@[@"提交申请",@"商家审核",@"商家收货",@"商家处理",@"完成"] progress:progress];
        }
    } else if (type == 2) {
        typeStr = @"(维修处理中)";
        if (status == 5) {
            progress = 2;
        }
        if (status == 10) {
            progress = 3;
        }
        if (status == 9) {
            progress = 4;
            typeStr = @"(维修完成)";
        }
        headerView.frame = frame;
        if (status == 4) {
            if ([dict[@"orderType"] boolValue]) {
                [headerView addProgressViewWithTitles:@[@"提交申请",@"系统审核",@"申请驳回"] progress:3];
            } else {
                [headerView addProgressViewWithTitles:@[@"提交申请",@"商家审核",@"申请驳回"] progress:3];
            }
        } else {
            [headerView addProgressViewWithTitles:@[@"提交申请",@"系统审核",@"上门维修",@"服务完成"] progress:progress];
        }
    } else {
        typeStr = @"(退款处理中)";
        if (status == 5 || status == 6) {
            progress = 2;
        }
        if (status == 9) {
            progress = 3;
            typeStr = @"(退款完成)";
        }
        headerView.frame = frame;
        if (status == 4) {
            if ([dict[@"orderType"] boolValue]) {
                [headerView addProgressViewWithTitles:@[@"提交申请",@"系统审核",@"申请驳回"] progress:3];
            } else {
                [headerView addProgressViewWithTitles:@[@"提交申请",@"商家审核",@"申请驳回"] progress:3];
            }
        } else {
            [headerView addProgressViewWithTitles:@[@"提交申请",@"商家处理",@"退款完成"] progress:progress];
        }
    }
    if (status == 4) {
        headerView.orderLab.text = [NSString stringWithFormat:@"服务单号：%@(已驳回)",self.aftersaleId];
    } else {
        headerView.orderLab.text = [NSString stringWithFormat:@"服务单号：%@%@",self.aftersaleId,typeStr];
    }
    headerView.timeLab.text = [NSString stringWithFormat:@"申请时间：%@",dict[@"addDatetime"]];
    if (frame.size.height > 300) {
        headerView.addressLab.text = addressStr;
        headerView.receiverLab.text = [NSString stringWithFormat:@"收件人：%@",dict[@"customerAddress"][@"consignee"]];
        headerView.postLab.text = [NSString stringWithFormat:@"邮编：%@",dict[@"customerAddress"][@"postalCode"]];
        headerView.phoneLab.text = [NSString stringWithFormat:@"电话：%@",dict[@"customerAddress"][@"phone"]];
    }
    if ([dict[@"expressName"] stringValue].length > 0) {
        headerView.expLab.text = dict[@"expressName"];
        headerView.expLab.textColor = COLOR_333333;
        headerView.expLab.userInteractionEnabled = NO;
        headerView.expTF.text = dict[@"shipCode"];
        headerView.expTF.enabled = NO;
        headerView.expBtn.hidden = YES;
        CGRect aframe = headerView.frame;
        aframe.size.height = aframe.size.height-55;
        headerView.frame = aframe;
    }
    if (frame.size.height > 300 && [dict[@"expressName"] stringValue].length == 0) {
        [self getExpData];
    }
    
    if ([dict[@"orderType"] boolValue]) {
        headerView.listTitLab.text = @"服务信息";
        [self.dataArr addObjectsFromArray:dict[@"serviceChargeVOList"]];
    } else {
        [self.dataArr addObjectsFromArray:dict[@"orderGoodsList"]];
    }
    
    ADLAfterDetailFooter *footerView = [[NSBundle mainBundle] loadNibNamed:@"ADLAfterDetailFooter" owner:nil options:nil].lastObject;
    footerView.typeLab.text = [NSString stringWithFormat:@"售后类型：%@",[typeStr substringWithRange:NSMakeRange(1, 2)]];
    footerView.reasonLab.text = [NSString stringWithFormat:@"申请原因：%@",dict[@"tagName"]];
    CGFloat descH = [ADLUtils calculateString:dict[@"reason"] rectSize:CGSizeMake(SCREEN_WIDTH-96, MAXFLOAT) fontSize:14].height;
    
    NSString *shipAddr = [ADLUtils queryAddressWithDataArr:self.provinceArr areaId:[dict[@"areaId"] stringValue]].address;
    shipAddr = [NSString stringWithFormat:@"%@%@",shipAddr,dict[@"address"]];
    CGFloat shipAddrH = [ADLUtils calculateString:shipAddr rectSize:CGSizeMake(SCREEN_WIDTH-96, MAXFLOAT) fontSize:14].height;
    footerView.descLab.text = dict[@"reason"];
    footerView.addressLab.text = shipAddr;
    footerView.personLab.text = [NSString stringWithFormat:@"联系人：%@",dict[@"consignee"]];
    footerView.phoneLab.text = [NSString stringWithFormat:@"联系人手机：%@",dict[@"phone"]];
    NSArray *imgs = [dict[@"imgsUrl"] componentsSeparatedByString:@","];
    NSInteger imgCount = imgs.count;
    if (imgCount > 0) {
        self.imgArr = imgs;
        footerView.imgH.constant = 92;
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, descH+shipAddrH+255);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(72, 0, SCREEN_WIDTH-96, 80)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(86*imgCount-6, 0);
        [footerView.imageView addSubview:scrollView];
        for (int i = 0; i < imgCount; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(86*i, 0, 80, 80)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.userInteractionEnabled = YES;
            imgView.clipsToBounds = YES;
            imgView.tag = i;
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgs[i]] placeholderImage:[UIImage imageNamed:@"img_square"]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
            [imgView addGestureRecognizer:tap];
            [scrollView addSubview:imgView];
        }
    } else {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, descH+shipAddrH+165);
    }
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    [self.tableView reloadData];
}

#pragma mark ------ 点击售后图片 ------
- (void)clickImgView:(UITapGestureRecognizer *)tap {
    [ADLImagePreView showWithImageViews:nil urlArray:self.imgArr currentIndex:tap.view.tag];
}

#pragma mark ------ 提交物流信息 ------
- (void)didClickSubmitExpBtn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUserModel sharedModel].userId forKey:@"userId"];
    [params setValue:self.aftersaleId forKey:@"customerServiceId"];
    [params setValue:self.headerView.expDict[@"name"] forKey:@"expressName"];
    [params setValue:self.headerView.expDict[@"id"] forKey:@"expressId"];
    [params setValue:self.headerView.expTF.text forKey:@"shipCode"];
    [ADLNetWorkManager postWithPath:k_after_sale_add_express parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.headerView.expLab.userInteractionEnabled = NO;
            self.headerView.expTF.enabled = NO;
            self.headerView.expBtn.hidden = YES;
            CGRect aframe = self.headerView.frame;
            aframe.size.height = aframe.size.height-55;
            self.headerView.frame = aframe;
        }
    } failure:nil];
}

#pragma mark ------ 确认收货 ------
- (void)clickConfirmReceiptBtn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.aftersaleId forKey:@"customerServiceId"];
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:k_after_sale_confirm_ship parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"确认收货成功"];
            if (self.clickConfirmBtn) {
                self.clickConfirmBtn();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

#pragma mark ------ 获取快递信息 ------
- (void)getExpData {
    [ADLNetWorkManager postWithPath:k_query_after_sale_exp parameters:nil autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            self.headerView.expArr = responseDict[@"data"];
        }
    } failure:nil];
}

- (NSMutableArray *)provinceArr {
    if (_provinceArr == nil) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        _provinceArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return _provinceArr;
}

@end
