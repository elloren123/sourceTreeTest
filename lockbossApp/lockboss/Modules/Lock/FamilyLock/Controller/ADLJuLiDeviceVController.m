//
//  ADLJuLiDeviceVController.m
//  lockboss
//
//  Created by bailun91 on 2019/10/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLJuLiDeviceVController.h"
#import "ADLDoNotDisturbVController.h"
#import "ADLCleanViewController.h"
#import "ADLInsideMachineAlarmController.h"
#import "ADLInsideMachineVoiceController.h"
#import "ADLInsideMachineScreenController.h"

@interface ADLJuLiDeviceVController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel   *devNameLabel;  //设备名称
@property (nonatomic, strong) UILabel   *devStatusLabel;//设备状态: 在线/离线
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableDictionary *InfosDict;   //设备额外信息集合

@end

@implementation ADLJuLiDeviceVController

- (void)updateDeviceInfos {
    [self getDeviceInfos];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addRedNavigationView:self.deviceName];
    [self createContentView];
    [self getDeviceInfos];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceInfos) name:@"UPDATE_DEVICE_INFOS_NOTIFICATION" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark ------ 按钮点击事件 ------
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101://'勿扰'
        {
            ADLDoNotDisturbVController *vc = [[ADLDoNotDisturbVController alloc] init];
            vc.deviceId = self.deviceId;
            vc.deviceCode = self.deviceCode;
            vc.disturbStatus = [self.InfosDict[@"disturbStatus"] intValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 102://'清洁'
        {
            ADLCleanViewController *vc = [[ADLCleanViewController alloc] init];
            vc.deviceId = self.deviceId;
            vc.deviceCode = self.deviceCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 201://'闹钟'
        {
            ADLInsideMachineAlarmController *vc = [[ADLInsideMachineAlarmController alloc] init];
            vc.deviceId = self.deviceId;
            vc.deviceCode = self.deviceCode;
            vc.alarmTime  = self.InfosDict[@"alarmTime"];
            vc.switchStatus = [self.InfosDict[@"alarmOpen"] intValue];
            vc.validStatus  = self.InfosDict[@"alarmValidTime"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 202://'音量'
        {
            ADLInsideMachineVoiceController *vc = [[ADLInsideMachineVoiceController alloc] init];
            vc.deviceId = self.deviceId;
            vc.deviceCode = self.deviceCode;
            vc.volumeValue = [self.InfosDict[@"voice"] floatValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 203://'显示'
        {
            ADLInsideMachineScreenController *vc = [[ADLInsideMachineScreenController alloc] init];
            vc.deviceId = self.deviceId;
            vc.deviceCode = self.deviceCode;
            vc.brightnessValue = [self.InfosDict[@"brightness"] floatValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)createContentView {
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT/3-20)];
    grayView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    [self.view addSubview:grayView];
    
    
    
    UIImageView *devImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/6-85, 100, 100)];
    devImgV.image = [UIImage imageNamed:@"icon_airoom_juli"];
    [grayView addSubview:devImgV];
    
    
    UILabel *devNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/6+15, SCREEN_WIDTH, 30)];
    devNameLab.font = [UIFont systemFontOfSize:16];
    devNameLab.textAlignment = NSTextAlignmentCenter;
    devNameLab.textColor = [UIColor darkGrayColor];
    devNameLab.text = ([self.deviceType isEqualToString:@"30"])?@"居里富人外机":@"居里富人内机";
    [grayView addSubview:devNameLab];
    self.devNameLabel = devNameLab;
    
    
    
    UILabel *devStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/6+45, SCREEN_WIDTH, 20)];
    devStatusLab.font = [UIFont systemFontOfSize:14];
    devStatusLab.textAlignment = NSTextAlignmentCenter;
    devStatusLab.textColor = [UIColor darkGrayColor];
    devStatusLab.text = ([self.deviceStatus isEqualToString:@"1"])?@"设备在线":@"设备离线";
    [grayView addSubview:devStatusLab];
    self.devStatusLabel = devStatusLab;
    
    
    
    //------ **** ------
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3+NAVIGATION_H-20, SCREEN_WIDTH, SCREEN_HEIGHT*2/3-NAVIGATION_H+20)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    
    UIButton *NoDisBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH/2-30, SCREEN_WIDTH/4-20)];
    [NoDisBtn setImage:[UIImage imageNamed:@"icon_juli_not"] forState:UIControlStateNormal];
    [NoDisBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    NoDisBtn.tag = 101;
    [whiteView addSubview:NoDisBtn];
    
    
    UIButton *cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, 20, SCREEN_WIDTH/2-30, SCREEN_WIDTH/4-20)];
    [cleanBtn setImage:[UIImage imageNamed:@"icon_juli_clean"] forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cleanBtn.tag = 102;
    [whiteView addSubview:cleanBtn];
    
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREEN_WIDTH/4+12, SCREEN_WIDTH-40, 105)];
    borderView.layer.masksToBounds = YES;
    borderView.layer.cornerRadius = 6.0;
    borderView.layer.borderColor = SEPARATOR_COLOR.CGColor;
    borderView.layer.borderWidth = 1.0;
    borderView.layer.shadowColor = SEPARATOR_COLOR.CGColor;
    borderView.layer.shadowOffset = CGSizeMake(-1, -1);
    borderView.layer.shadowOpacity = 0.6;
    borderView.layer.shadowRadius = 3;
    [whiteView addSubview:borderView];
    
    
    for (int i = 0 ; i < 3; i++) {
        UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(30+50*i+(SCREEN_WIDTH-250)*i/2, 15, 50, 90)];
        [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        clickBtn.tag = 201+i;
        [borderView addSubview:clickBtn];
        
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [clickBtn addSubview:imgV];
        
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 40)];
        textLab.font = [UIFont systemFontOfSize:15];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.textColor = [UIColor darkGrayColor];
        [clickBtn addSubview:textLab];
        
        if (0 == i) {
            imgV.image = [UIImage imageNamed:@"icon_juli_clock"];
            textLab.text = @"闹钟";
        } else if (1 == i) {
            imgV.image = [UIImage imageNamed:@"icon_juli_volume"];
            textLab.text = @"音量";
        } else if (2 == i) {
            imgV.image = [UIImage imageNamed:@"icon_juli_display"];
            textLab.text = @"显示";
        }
    }
    
    
    
    // ------ **** ------
    UILabel *devLeadLab = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_WIDTH/4+120, SCREEN_WIDTH-40, 40)];
    devLeadLab.font = [UIFont systemFontOfSize:16];
    devLeadLab.textAlignment = NSTextAlignmentLeft;
    devLeadLab.textColor = [UIColor blackColor];
    devLeadLab.text = @"室内物联设备";
    [whiteView addSubview:devLeadLab];
    
    UITableView *Table = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/4+160, SCREEN_WIDTH, SCREEN_HEIGHT*2/3-NAVIGATION_H-SCREEN_WIDTH/4-140) style:UITableViewStylePlain];
    Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    Table.delegate = self;
    Table.dataSource = self;
    Table.rowHeight = 60;
    [whiteView addSubview:Table];
    self.tableView = Table;
}

#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devArray.count;
//    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *devCell = [tableView dequeueReusableCellWithIdentifier:@"devCell"];
    if (devCell == nil) {
        devCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        devCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([devCell.contentView.subviews lastObject] != nil) {
            [(UIView*)[devCell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    NSDictionary *dict = self.devArray[indexPath.row];
    
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6, 48, 48)];
    imgV.image = [self getDeviceImage:dict[@"deviceType"]];
    [contentV addSubview:imgV];
    
    
    UILabel *devNameLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH-120, 24)];
    devNameLab.font = [UIFont systemFontOfSize:16];
    devNameLab.textAlignment = NSTextAlignmentLeft;
    devNameLab.textColor = [UIColor blackColor];
//    devNameLab.text = @"设备名称";
    devNameLab.text = dict[@"deviceName"];
    [contentV addSubview:devNameLab];
    
    
    
    UILabel *devStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, SCREEN_WIDTH-120, 20)];
    devStatusLab.font = [UIFont systemFontOfSize:13];
    devStatusLab.textAlignment = NSTextAlignmentLeft;
    devStatusLab.textColor = [UIColor lightGrayColor];
//    devStatusLab.text = @"设备离线";
    devStatusLab.text = ([dict[@"deviceStatus"] intValue] == 1)?@"设备在线":@"设备离线";
    [contentV addSubview:devStatusLab];
    
    
    UIImageView *nextIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-28, 22, 8, 16)];
    nextIcon.image = [UIImage imageNamed:@"icon_xiao"];
    [contentV addSubview:nextIcon];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = SEPARATOR_COLOR;
    [contentV addSubview:line];
    
    
    [devCell.contentView addSubview:contentV];
    
    
    return devCell;
}
- (UIImage *)getDeviceImage:(NSString *)type {
    if ([type isEqualToString:@"51"]) {//储物箱
        return [UIImage imageNamed:@"icon_device_boxoff"];
        
    } else if ([type isEqualToString:@"41"]) {//燃气阀
        return [UIImage imageNamed:@"icon_device_gason"];
        
    } else if ([type isEqualToString:@"30"] || [type isEqualToString:@"31"]) {//居里防盗
        return [UIImage imageNamed:@"icon_airoom_juli"];
   
    } else {
        return [ADLUtils lockImageWithType:type];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}


#pragma mark ------ 查询设备额外的信息 - 勿扰、闹铃、音量、屏幕 ------
- (void)getDeviceInfos {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId      forKey:@"deviceId"];
    [params setValue:self.deviceCode    forKey:@"deviceCode"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/company/user/dev/other/info.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"查询设备额外信息返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            //保存信息
            self.InfosDict = [NSMutableDictionary dictionaryWithDictionary:responseDict[@"data"]];
        } else {
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
    }];
}
@end
