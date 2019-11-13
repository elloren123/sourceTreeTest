//
//  ADLFSharedPersonController.m
//  lockboss
//
//  Created by Adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFSharedPersonController.h"
#import "ADLFSharedPersonCell.h"
#import "ADLFModifyTimeView.h"
#import "ADLImagePreView.h"

@interface ADLFSharedPersonController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *remarkTF;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) UIButton *allowBtn;
@property (nonatomic, strong) UIButton *disallowBtn;
@end

@implementation ADLFSharedPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"共享人"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, NAVIGATION_H+30, 70, 70)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[self.infoDict[@"headShot"] stringValue]] placeholderImage:[UIImage imageNamed:@"user_head"]];
    imgView.userInteractionEnabled = YES;
    imgView.layer.cornerRadius = 6;
    imgView.clipsToBounds = YES;
    [self.view addSubview:imgView];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
    [imgView addGestureRecognizer:imgTap];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+110, SCREEN_WIDTH-60, 30)];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.infoDict[@"userName"];
    nameLab.textColor = COLOR_333333;
    [self.view addSubview:nameLab];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+160, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H-160)];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.hidden = YES;
    
    CGFloat remarkW = [ADLUtils calculateString:ADLString(@"remark") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:14].width+10;
    UILabel *remarkLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-remarkW-200)/2, 0, remarkW, 30)];
    remarkLab.font = [UIFont systemFontOfSize:14];
    remarkLab.text = ADLString(@"remark");
    remarkLab.textColor = COLOR_333333;
    [contentView addSubview:remarkLab];
    
    UITextField *remarkTF = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+remarkW-200)/2, 0, 200, 30)];
    remarkTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    remarkTF.borderStyle = UITextBorderStyleRoundedRect;
    remarkTF.font = [UIFont systemFontOfSize:14];
    remarkTF.returnKeyType = UIReturnKeyDone;
    remarkTF.placeholder = @"请设置备注名";
    remarkTF.textColor = COLOR_333333;
    remarkTF.delegate = self;
    [contentView addSubview:remarkTF];
    self.remarkTF = remarkTF;
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 60, SCREEN_WIDTH-70, 30)];
    dateLab.font = [UIFont systemFontOfSize:14];
    dateLab.text = ADLString(@"set_date");
    dateLab.textColor = COLOR_333333;
    [contentView addSubview:dateLab];
    
    CGFloat dateW = [ADLUtils calculateString:ADLString(@"set_date") rectSize:CGSizeMake(MAXFLOAT, 30) fontSize:14].width+15;
    UIButton *dateBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateW+35, 60, SCREEN_WIDTH-dateW-70, 30)];
    [dateBtn setTitleColor:PLACEHOLDER_COLOR forState:UIControlStateNormal];
    [dateBtn setTitle:ADLString(@"select_end_time") forState:UIControlStateNormal];
    dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [dateBtn addTarget:self action:@selector(clickSelectDateBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:dateBtn];
    self.dateBtn = dateBtn;
    
    UIImageView *pullView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 71, 14, 8)];
    pullView.image = [UIImage imageNamed:@"pull_down"];
    [contentView addSubview:pullView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(dateW+35, 89, SCREEN_WIDTH-dateW-70, 0.5)];
    lineView.backgroundColor = COLOR_D3D3D3;
    [contentView addSubview:lineView];
    
    NSString *permitStr = [NSString stringWithFormat:@"%@:",ADLString(@"lock_permit")];
    CGFloat permitW = [ADLUtils calculateString:permitStr rectSize:CGSizeMake(SCREEN_WIDTH-195, MAXFLOAT) fontSize:14].width+2;
    UILabel *permitLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 100, permitW, 40)];
    permitLab.font = [UIFont systemFontOfSize:14];
    permitLab.textColor = COLOR_333333;
    permitLab.numberOfLines = 2;
    permitLab.text = permitStr;
    [contentView addSubview:permitLab];
    
    UIButton *allowBtn = [[UIButton alloc] initWithFrame:CGRectMake(permitW+45, 100, 50, 40)];
    [allowBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [allowBtn setTitle:ADLString(@"yes") forState:UIControlStateNormal];
    allowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [allowBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [allowBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
    allowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    allowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [allowBtn addTarget:self action:@selector(clickPermissionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:allowBtn];
    allowBtn.selected = YES;
    self.allowBtn = allowBtn;
    
    UIButton *disallowBtn = [[UIButton alloc] initWithFrame:CGRectMake(permitW+110, 100, 50, 40)];
    [disallowBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [disallowBtn setTitle:ADLString(@"no") forState:UIControlStateNormal];
    disallowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [disallowBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [disallowBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
    disallowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    disallowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [disallowBtn addTarget:self action:@selector(clickPermissionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:disallowBtn];
    self.disallowBtn = disallowBtn;
    
    UILabel *deviceLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 140, 280, 30)];
    deviceLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    deviceLab.textColor = COLOR_333333;
    deviceLab.text = @"选择设备";
    [contentView addSubview:deviceLab];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 175, SCREEN_WIDTH-60, SCREEN_HEIGHT-NAVIGATION_H-BOTTOM_H-427)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = 70;
    tableView.delegate = self;
    tableView.dataSource = self;
    [contentView addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(20, SCREEN_HEIGHT-BOTTOM_H-68, SCREEN_WIDTH-40, 44);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:ADLString(@"confirm") forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    confirmBtn.layer.cornerRadius = CORNER_RADIUS;
    confirmBtn.backgroundColor = APP_COLOR;
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    confirmBtn.hidden = YES;
    
    [self queryRemarkName];
    [self queryDeviceList];
}

#pragma mark ------ UITableView Delegate && DataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLFSharedPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ADLFSharedPersonCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"isFirstConnection"] intValue] == 1) {
        cell.stateLab.textColor = COLOR_0AAA00;
        cell.stateLab.text = ADLString(@"online");
    } else {
        cell.stateLab.textColor = COLOR_999999;
        cell.stateLab.text = ADLString(@"offline");
    }
    cell.checkBtn.selected = [dict[@"check"] boolValue];
    cell.nameLab.text = dict[@"deviceName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"check"] boolValue]) {
        [dict setValue:@(0) forKey:@"check"];
    } else {
        [dict setValue:@(1) forKey:@"check"];
    }
    [tableView reloadData];
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [ADLUtils limitedTextField:textField replacementString:string maxLength:18];
}

#pragma mark ------ 点击图片 ------
- (void)clickImgView:(UITapGestureRecognizer *)tap {
    NSString *imgUrl = [self.infoDict[@"headShot"] stringValue];
    if (imgUrl.length > 0) {
        [ADLImagePreView showWithImageViews:@[tap.view] urlArray:@[imgUrl] currentIndex:0];
    }
}

#pragma mark ------ 选择截止日期 ------
- (void)clickSelectDateBtn {
    if ([self.remarkTF isFirstResponder]) {
        [self.remarkTF resignFirstResponder];
    }
    [ADLFModifyTimeView showWithTitle:ADLString(@"select_end_time") finish:^(NSString *dateStr) {
        [self.dateBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        if ([dateStr isEqualToString:@"-1"]) {
            [self.dateBtn setTitle:ADLString(@"permanent") forState:UIControlStateNormal];
        } else {
            [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
        }
    }];
}

#pragma mark ------ 点击查看开门记录权限按钮 ------
- (void)clickPermissionBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        if (sender == self.allowBtn) {
            self.disallowBtn.selected = NO;
        } else {
            self.allowBtn.selected = NO;
        }
    }
}

#pragma mark ------ 查询备注名 ------
- (void)queryRemarkName {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.infoDict[@"userId"] forKey:@"userId"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getIsCrew parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            if ([responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.remarkTF.text = responseDict[@"data"][@"remark"];
            }
        }
    } failure:nil];
}

#pragma mark ------ 查询设备 ------
- (void)queryDeviceList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.infoDict[@"userId"] forKey:@"userId"];
    [params setValue:@(1) forKey:@"operationType"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_family_getByDeviceCrew parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            NSArray *resArr = responseDict[@"data"];
            if (resArr.count > 0) {
                for (NSMutableDictionary *dict in resArr) {
                    if ([dict[@"deviceType"] intValue] != 21) {
                        [dict setValue:@(0) forKey:@"check"];
                        [self.dataArr addObject:dict];
                    }
                }
            }
            if (self.dataArr.count > 0) {
                self.contentView.hidden = NO;
                self.confirmBtn.hidden = NO;
            }
            [self.tableView reloadData];
        }
    } failure:nil];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    NSString *remark = [self.remarkTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (remark.length == 0) {
        [ADLToast showMessage:@"请输入备注名"];
        return;
    }
    if ([ADLUtils hasEmoji:remark]) {
        [ADLToast showMessage:@"暂时不支持输入表情或特殊符号"];
        return;
    }
    if ([self.dateBtn.titleLabel.text isEqualToString:ADLString(@"select_end_time")]) {
        [ADLToast showMessage:ADLString(@"select_end_time")];
        return;
    }
    
    NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.dataArr) {
        if ([dict[@"check"] boolValue]) {
            [deviceArr addObject:dict[@"deviceId"]];
        }
    }
    
    if (deviceArr.count == 0) {
        [ADLToast showMessage:@"请选择设备"];
        return;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceArr options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.allowBtn.selected) forKey:@"canQueryBlock"];
    [params setValue:self.infoDict[@"userId"] forKey:@"userId"];
    [params setValue:self.remarkTF.text forKey:@"remark"];
    [params setValue:jsonString forKey:@"deviceIds"];
    [params setValue:[ADLUtils timestampWithDate:nil format:@"yyyy-MM-dd HH:mm"] forKey:@"startDatetime"];
    if ([self.dateBtn.titleLabel.text isEqualToString:ADLString(@"permanent")]) {
        [params setValue:@"" forKey:@"endDatetime"];
    } else {
        [params setValue:[ADLUtils timestampWithDateStr:self.dateBtn.titleLabel.text format:@"yyyy-MM-dd HH:mm"] forKey:@"endDatetime"];
    }
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    [ADLToast showLoadingMessage:ADLString(@"loading")];
    [ADLNetWorkManager postWithPath:ADEL_family_setShareCrew parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        if ([responseDict[@"code"] integerValue] == 10000) {
            [ADLToast showMessage:@"添加成功"];
            if (self.success) self.success();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:nil];
}

@end
