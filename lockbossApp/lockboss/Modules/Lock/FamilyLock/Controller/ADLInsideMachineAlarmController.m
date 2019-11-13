//
//  ADLInsideMachineAlarmController.m
//  lockboss
//
//  Created by adel on 2019/10/21.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLInsideMachineAlarmController.h"
#import "ADLHomeDateTimeView.h"

@interface ADLInsideMachineAlarmController ()

@property (nonatomic, strong) UISwitch      *MainSwitch;
@property (nonatomic, strong) UIButton      *timeBtn;
@property (nonatomic, strong) UIButton      *joinTimeBtn;
@property (nonatomic, strong) UIButton      *workDayBtn;
@property (nonatomic, strong) UIButton      *weekendBtn;
@property (nonatomic, assign) NSInteger     selectedBtnTag;
@property (nonatomic, strong) UIView        *darkView;
@property (nonatomic, strong) UIView        *pickerView;
@property (nonatomic, strong) UIDatePicker  *datePicker;

@end

@implementation ADLInsideMachineAlarmController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"闹钟"];
    [self createContentView];
    [self createDatePickerView];
}

#pragma mark ------ 按钮点击 ------
- (void)clickBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            //(@"YYYY-MM-dd HH:mm:ss")设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            [formatter setDateFormat:@"HH:mm"];
            [self.datePicker setDate:[formatter dateFromString:self.timeBtn.titleLabel.text]];
            
            [UIView animateWithDuration:0.35 animations:^{
                self.darkView.hidden = NO;
                self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT-245, SCREEN_WIDTH, 245);
            }];
        }
            break;
            
        case 201:
        case 202:
        case 203:
            if (self.selectedBtnTag != sender.tag-200) {
                int open = 2;
                if (self.MainSwitch.on) {
                    open = 1;
                }
                //设置有效时间
                [self setAlarmStatus:open btnTag:sender.tag time:self.timeBtn.titleLabel.text position:3];
            }
            break;
            
        case 301://'取消'btn
        {
            //隐藏时间选择器
            [UIView animateWithDuration:0.35 animations:^{
                self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 245);
            } completion:^(BOOL finished) {
                self.darkView.hidden = YES;
            }];
        }
            break;
        
        case 302://'确定'btn
        {
            NSDate *date = self.datePicker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *dateStr = [formatter stringFromDate:date];
            NSLog(@"dateStr = %@", dateStr);
//            [self.timeBtn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];

            //隐藏时间选择器
            [UIView animateWithDuration:0.35 animations:^{
                self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 245);
            } completion:^(BOOL finished) {
                self.darkView.hidden = YES;
                
                //设置时间
                int open = 2;
                if (self.MainSwitch.on) {
                    open = 1;
                }
                [self setAlarmStatus:open btnTag:self.selectedBtnTag+200 time:self.timeBtn.titleLabel.text position:2];
            }];
        }
            break;
            
            
        default:
            break;
    }
}
- (void)updateTimeBtns {
    if (self.selectedBtnTag == 1) {
        [self.joinTimeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
        [self.workDayBtn  setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        [self.weekendBtn  setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        
    } else if (self.selectedBtnTag == 2) {
        [self.joinTimeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        [self.workDayBtn  setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
        [self.weekendBtn  setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        
    } else if (self.selectedBtnTag == 3) {
        [self.joinTimeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        [self.workDayBtn  setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        [self.weekendBtn  setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
    }
}
- (void)setTime {
    
}
- (void)createContentView {
    // ------ **** ------
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H, SCREEN_WIDTH/2, 60)];
    txtLab.font = [UIFont systemFontOfSize:15.5];
    txtLab.textAlignment = NSTextAlignmentLeft;
    txtLab.textColor = [UIColor darkGrayColor];
    txtLab.text = @"闹钟";
    [self.view addSubview:txtLab];
    
    
    UISwitch *witch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, NAVIGATION_H+15, 50, 30)];
    witch.onTintColor = COLOR_E0212A;//开状态下的颜色
    witch.tintColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];//开状态下的颜色
    [witch addTarget:self action:@selector(mainswitchStatusChanged:) forControlEvents:UIControlEventValueChanged];
    [witch setOn:(self.switchStatus == 1)?YES:NO animated:NO];
    [self.view addSubview:witch];
    self.MainSwitch = witch;
    
    
    
    for (int i = 0 ; i < 3; i++) {
        CGFloat Height = 60*(i+1);
        if (i == 2) {
            Height = 270;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+Height, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self.view addSubview:line];
    }
    
    
    // ------ **** ------
    UILabel *alarmLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H+60, SCREEN_WIDTH/4, 60)];
    alarmLab.font = [UIFont systemFontOfSize:15.5];
    alarmLab.textAlignment = NSTextAlignmentLeft;
    alarmLab.textColor = [UIColor darkGrayColor];
    alarmLab.text = @"闹铃时间";
    [self.view addSubview:alarmLab];
    
    
    //timeBtn
    UIButton *markBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+15, NAVIGATION_H+65, 60, 50)];
    [markBtn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
    markBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [markBtn setTitle:([self.alarmTime containsString:@":"])?self.alarmTime:@"06:00" forState:UIControlStateNormal];
    [markBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    markBtn.tag = 101;
    [self.view addSubview:markBtn];
    self.timeBtn = markBtn;
    
    
    UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+15, NAVIGATION_H+110, 60, 1)];
    redLine.backgroundColor = COLOR_E0212A;
    [self.view addSubview:redLine];
    
    
    
    
    // ------ **** ------
    UILabel *volumeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H+120, SCREEN_WIDTH/2, 60)];
    volumeLab.font = [UIFont systemFontOfSize:15.5];
    volumeLab.textAlignment = NSTextAlignmentLeft;
    volumeLab.textColor = [UIColor darkGrayColor];
    volumeLab.text = @"有效时间";
    [self.view addSubview:volumeLab];
    
    
    
    if ([self.validStatus containsString:@"6,7"]) {
        self.selectedBtnTag = 3;
    } else if (![self.validStatus isEqualToString:@"10"]) {
        self.selectedBtnTag = 2;
    } else {
        self.selectedBtnTag = 1;
    }
    
    //3个btns
    for (int i = 0 ; i < 3; i++) {
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+20+SCREEN_WIDTH*(i%2)/3, NAVIGATION_H+130+(i/2)*40, 105, 40)];
        [selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:15.5];
        [selectBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = 201+i;
        selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [selectBtn setImage:[UIImage imageNamed:(self.selectedBtnTag == i+1)?@"icon_xuanzhong":@"icon_xuanzhong_G"] forState:UIControlStateNormal];
        [self.view addSubview:selectBtn];
        
        //赋值
        if (0 == i) {
            [selectBtn setTitle:@"入住期间" forState:UIControlStateNormal];
            self.joinTimeBtn = selectBtn;
            
        } else if (1 == i) {
            [selectBtn setTitle:@"周一至周五" forState:UIControlStateNormal];
            self.workDayBtn = selectBtn;
            
        } else if (2 == i) {
            [selectBtn setTitle:@"周六周日" forState:UIControlStateNormal];
            self.weekendBtn = selectBtn;
        }
    }
}

- (void)mainswitchStatusChanged:(UISwitch *)sender {
    NSLog(@"sender.on = %d", sender.on);
    
    //设置开关
    int open = 2;
    if (sender.on) {
        open = 1;
    }
    [self setAlarmStatus:open btnTag:self.selectedBtnTag+200 time:self.timeBtn.titleLabel.text position:1];
}


- (void)createDatePickerView {
    UIView *darkview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    darkview.backgroundColor = [UIColor blackColor];
    darkview.alpha = 0.4;
    [self.view addSubview:darkview];
    darkview.hidden = YES;
    self.darkView = darkview;
    
    
    
    //------ ***** ------
    _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 245)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    
    for (int i = 0 ; i < 2; i++) {
        UIButton *yesOrNoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3*i/4, 0, SCREEN_WIDTH/4, 44)];
        [yesOrNoBtn setTitleColor:COLOR_E0212A forState:UIControlStateNormal];
        yesOrNoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [yesOrNoBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        yesOrNoBtn.tag = 301+i;
        [self.pickerView addSubview:yesOrNoBtn];
        
        if (i == 0) {
            [yesOrNoBtn setTitle:@"取消" forState:UIControlStateNormal];
        } else {
            [yesOrNoBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
    }
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self.pickerView addSubview:line];
    
    
    UIDatePicker *pick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 200)];
    pick.datePickerMode = UIDatePickerModeTime;
    pick.calendar = [NSCalendar currentCalendar];
    pick.locale   = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    pick.timeZone = [NSTimeZone systemTimeZone];
    //    UIDatePicker没有代理方法
    //   监听UIDatePicker的值改变.
//    [pick addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventValueChanged];
    [self.pickerView addSubview:pick];
    self.datePicker = pick;
}
- (void)timeChange:(UIDatePicker *)picker {
    NSDate *date = picker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSLog(@"dateStr = %@", dateStr);
}


#pragma mark ------ 闹钟设置 ------
/*
 * open: 1表示开关打开; 2表示开关关闭
 * flag: 1表示设置开关状态; 2表示设置时间; 3表示设置有效时间
 */
- (void)setAlarmStatus:(int)open btnTag:(NSInteger)btnTag time:(NSString *)time position:(int)flag {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId   forKey:@"deviceId"];
    [params setValue:self.deviceCode forKey:@"deviceCode"];
    [params setValue:@(open)         forKey:@"open"];
    [params setValue:time            forKey:@"time"];
    [params setValue:[self getWorkTimestr:btnTag]  forKey:@"validTime"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    NSLog(@"闹钟设置参数: %@", params);
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/app/user/l3/in/alarm/set.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"闹钟设置返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            if (flag == 2) { //时间设置
                [self.timeBtn setTitle:time forState:UIControlStateNormal];
            
            } else if (flag == 3) { //有效时间设置
                self.selectedBtnTag = btnTag-200;
                [self updateTimeBtns];
            }
            
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DEVICE_INFOS_NOTIFICATION" object:nil];
            
        } else {
            if (flag == 1) { //开关设置
                //设置开关状态
                [self.MainSwitch setOn:(open == 2)?YES:NO animated:YES];
            }
            
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (flag == 1) { //开关设置
            //设置开关状态
            [self.MainSwitch setOn:(open == 2)?YES:NO animated:YES];
        }
    }];
}
- (NSString *)getWorkTimestr:(NSInteger)btnTag {
    NSString *workStr = @"10";  //默认值
    if (btnTag == 202) {
        workStr = @"1,2,3,4,5";
    
    } else if (btnTag == 203) {
        workStr = @"6,7";
    }
    
    return workStr;
}

@end
