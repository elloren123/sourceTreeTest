//
//  ADLFAuthorityDetailController.m
//  lockboss
//
//  Created by Adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFAuthorityDetailController.h"
#import "ADLFAuthDeviceCell.h"
#import "ADLFModifyTimeView.h"
#import "ADLImagePreView.h"
#import "ADLSwitch.h"

@interface ADLFAuthorityDetailController ()<UITableViewDelegate,UITableViewDataSource,ADLFAuthDeviceCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *remarkBtn;

@end

@implementation ADLFAuthorityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRedNavigationView:ADLString(@"grant_detail")];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+20, 50, 50)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[self.infoDict[@"url"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    imgView.userInteractionEnabled = YES;
    imgView.layer.cornerRadius = 6;
    imgView.clipsToBounds = YES;
    [self.view addSubview:imgView];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
    [imgView addGestureRecognizer:imgTap];
    
    CGFloat grantW = [ADLUtils calculateString:ADLString(@"grant_already") rectSize:CGSizeMake(MAXFLOAT, 20) fontSize:12].width+16;
    UILabel *grantLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-grantW-12, NAVIGATION_H+35, grantW, 20)];
    grantLab.textAlignment = NSTextAlignmentCenter;
    grantLab.backgroundColor = [UIColor blueColor];
    grantLab.font = [UIFont systemFontOfSize:12];
    grantLab.text = ADLString(@"grant_already");
    grantLab.textColor = [UIColor whiteColor];
    grantLab.layer.cornerRadius = 3;
    grantLab.clipsToBounds = YES;
    [self.view addSubview:grantLab];
    
    CGFloat remarkW = [ADLUtils calculateString:[self.infoDict[@"userName"] stringValue] rectSize:CGSizeMake(SCREEN_WIDTH-grantW-119, 20) fontSize:15].width+23;
    UIButton *remarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(72, NAVIGATION_H+18, remarkW, 26)];
    [remarkBtn setTitle:[self.infoDict[@"userName"] stringValue] forState:UIControlStateNormal];
    [remarkBtn setImage:[UIImage imageNamed:@"mine_feedback"] forState:UIControlStateNormal];
    remarkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [remarkBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    remarkBtn.imageEdgeInsets = UIEdgeInsetsMake(7, remarkW-12, 7, 0);
    remarkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    remarkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [remarkBtn addTarget:self action:@selector(clickRemarkBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remarkBtn];
    self.remarkBtn = remarkBtn;
    
    UILabel *nickLab = [[UILabel alloc] initWithFrame:CGRectMake(72, NAVIGATION_H+47, SCREEN_WIDTH-grantW-96, 20)];
    nickLab.text = [NSString stringWithFormat:@"%@：%@",ADLString(@"nickname"),self.infoDict[@"nickName"]];
    nickLab.font = [UIFont systemFontOfSize:13];
    nickLab.textColor = COLOR_999999;
    [self.view addSubview:nickLab];
    
    UILabel *deviceLab = [[UILabel alloc] initWithFrame:CGRectMake(12, NAVIGATION_H+90, SCREEN_WIDTH-24, 20)];
    deviceLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    deviceLab.text = ADLString(@"grant_device");
    deviceLab.textColor = COLOR_333333;
    [self.view addSubview:deviceLab];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+120, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-120)];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_H, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 118;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [ADLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf queryDeviceData];
    }];
    
    [self queryDeviceData];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLFAuthDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"auth"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLFAuthDeviceCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.lockView.image = [ADLUtils lockImageWithType:dict[@"deviceType"]];
    cell.modelLab.text = [self dealwithModel:dict[@"deviceType"]];
    cell.pswitch.open = [dict[@"canQueryBlock"] boolValue];
    cell.nameLab.text = dict[@"remark"];
    if ([dict[@"endDatetime"] intValue] == -1000) {
        cell.timeLab.text = [NSString stringWithFormat:@"%@：%@",ADLString(@"end_time"),ADLString(@"permanent")];
    } else {
        NSString *timeStr = [ADLUtils getDateFromTimestamp:[dict[@"endDatetime"] doubleValue] format:@"yyyy-MM-dd HH:mm"];
        cell.timeLab.text = [NSString stringWithFormat:@"%@：%@",ADLString(@"end_time"),timeStr];
    }
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAC = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [ADLAlertView showWithTitle:ADLString(@"delete_device") message:ADLString(@"delete_device_pp") confirmTitle:nil confirmAction:^{
            [self deleteDeviceWithIndexPath:indexPath];
        } cancleTitle:nil cancleAction:nil showCancle:YES];
    }];
    return @[deleteAC];
}

#pragma mark ------ 删除 ------
- (void)deleteDeviceWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:dict[@"deviceId"] forKey:@"deviceId"];
    [params setValue:dict[@"userId"] forKey:@"userId"];
    [params setValue:dict[@"id"] forKey:@"id"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_family_relieveShare parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:ADLString(@"unbind_success")];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADELfamillockUpdateDeviceNotification" object:nil userInfo:nil];
            if (self.refresh) {
                self.refresh();
            }
            if (self.dataArr.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } failure:nil];
}

#pragma mark ------ 修改时间 ------
- (void)didClickModifyTimeBtn:(UIButton *)sender {
    [ADLFModifyTimeView showWithTitle:ADLString(@"edit_time") finish:^(NSString *dateStr) {
        
        [ADLToast showLoadingMessage:ADLString(@"loading")];
        ADLFAuthDeviceCell *cell = (ADLFAuthDeviceCell *)sender.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableDictionary *dict = self.dataArr[indexPath.row];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:dict[@"userId"] forKey:@"userId"];
        [params setValue:dict[@"deviceId"] forKey:@"deviceId"];
        [params setValue:dict[@"id"] forKey:@"id"];
        [params setValue:[ADLUtils timestampWithDate:nil format:@"yyyy-MM-dd HH:mm"] forKey:@"startDatetime"];
        if ([dateStr isEqualToString:@"-1"]) {
            [params setValue:@"" forKey:@"endDatetime"];
        } else {
            [params setValue:[ADLUtils timestampWithDateStr:dateStr format:@"yyyy-MM-dd HH:mm"] forKey:@"endDatetime"];
        }
        [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
        
        [ADLNetWorkManager postWithPath:ADEL_family_postponeShare parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
            if ([responseDict[@"code"] integerValue] == 10000) {
                [ADLToast showMessage:@"修改成功"];
                [self queryDeviceData];
            }
        } failure:nil];
    }];
}

#pragma mark ------ 修改开门记录查询权限 ------
- (void)didClickSwitch:(ADLSwitch *)sender {
    ADLFAuthDeviceCell *cell = (ADLFAuthDeviceCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    
    NSString *path = ADEL_blockchain_add;
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (sender.on) {
        path = ADEL_blockchain_delete;
        [params setValue:dict[@"userBlockchainQueryId"] forKey:@"id"];
    } else {
        [params setValue:dict[@"userId"] forKey:@"userId"];
        [params setValue:dict[@"deviceId"] forKey:@"deviceId"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:path parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            sender.on = !sender.on;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ADLToast showMessage:@"修改成功"];
                [self queryDeviceData];
            });
        }
    } failure:nil];
}

#pragma mark ------ 点击图片 ------
- (void)clickImgView:(UITapGestureRecognizer *)tap {
    NSString *imgUrl = [self.infoDict[@"url"] stringValue];
    if (imgUrl.length > 0) {
        [ADLImagePreView showWithImageViews:@[tap.view] urlArray:@[imgUrl] currentIndex:0];
    }
}

#pragma mark ------ 点击修改备注名 ------
- (void)clickRemarkBtn {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改备注名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"cancle") style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:ADLString(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertVC.textFields.firstObject;
        NSString *name = textField.text;
        if (name.length > 0) {
            if (name.length > 18) {
                name = [name substringToIndex:18];
            }
            if ([ADLUtils hasEmoji:name]) {
                [ADLToast showMessage:@"暂时不支持表情或特殊符号"];
            } else {
                [self modifyRemarkName:name];
            }
        }
    }]];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = ADLString(@"remark_name_ph");
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ------ 修改备注名请求 ------
- (void)modifyRemarkName:(NSString *)name {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.infoDict[@"userId"] forKey:@"userId"];
    [params setValue:name forKey:@"remark"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_family_setRemark parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"修改成功"];
            CGFloat grantW = [ADLUtils calculateString:ADLString(@"grant_already") rectSize:CGSizeMake(MAXFLOAT, 20) fontSize:12].width+16;
            CGFloat remarkW = [ADLUtils calculateString:name rectSize:CGSizeMake(SCREEN_WIDTH-grantW-119, 20) fontSize:15].width+23;
            self.remarkBtn.frame = CGRectMake(72, NAVIGATION_H+18, remarkW, 26);
            if (self.refresh) {
                self.refresh();
            }
        }
    } failure:nil];
}

#pragma mark ------ 查询设备数据 ------
- (void)queryDeviceData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.infoDict[@"userId"] forKey:@"userId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_shareDetails parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"code"] integerValue] == 10000) {
            [self.dataArr removeAllObjects];
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                [self.dataArr addObjectsFromArray:resArr];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------ 处理型号 ------
- (NSString *)dealwithModel:(NSString *)type {
    if ([type isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%@：L0",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"2"]) {
        return [NSString stringWithFormat:@"%@：H10",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"3"]) {
        return [NSString stringWithFormat:@"%@：HOH77",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"4"]) {
        return [NSString stringWithFormat:@"%@：USB12",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"5"]) {
        return [NSString stringWithFormat:@"%@：BOX",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"6"]) {
        return [NSString stringWithFormat:@"%@：US3-6",ADLString(@"lock_model")];
    } else if ([type isEqualToString:@"7"]) {
        return [NSString stringWithFormat:@"%@：LS99",ADLString(@"lock_model")];
    } else {
        return [NSString stringWithFormat:@"%@：%@",ADLString(@"lock_model"),ADLString(@"unknown")];
    }
}

@end
