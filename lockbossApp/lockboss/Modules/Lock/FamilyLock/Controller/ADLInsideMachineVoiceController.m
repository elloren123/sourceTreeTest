//
//  ADLInsideMachineVoiceController.m
//  lockboss
//
//  Created by adel on 2019/10/21.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLInsideMachineVoiceController.h"

@interface ADLInsideMachineVoiceController ()

@property (nonatomic, strong) UISwitch      *MainSwitch;
@property (nonatomic, strong) UISlider      *MainSlider;

@end

@implementation ADLInsideMachineVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"音量"];
    [self createContentView];
}
- (void)createContentView {
    // ------ **** ------
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H, SCREEN_WIDTH/2, 60)];
    txtLab.font = [UIFont systemFontOfSize:15.5];
    txtLab.textAlignment = NSTextAlignmentLeft;
    txtLab.textColor = [UIColor darkGrayColor];
    txtLab.text = @"静音";
    [self.view addSubview:txtLab];
    
    
    UISwitch *witch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, NAVIGATION_H+15, 50, 30)];
    witch.onTintColor = COLOR_E0212A;//开状态下的颜色
    witch.tintColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];//开状态下的颜色
    [witch addTarget:self action:@selector(mainswitchStatusChanged:) forControlEvents:UIControlEventValueChanged];
    [witch setOn:(self.volumeValue > 0)?YES:NO animated:NO];
    [self.view addSubview:witch];
    self.MainSwitch = witch;
    
    
    
    for (int i = 0 ; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+60+150*i, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self.view addSubview:line];
    }
    
    
    
    
    // ------ **** ------
    UILabel *volumeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H+60, SCREEN_WIDTH/2, 60)];
    volumeLab.font = [UIFont systemFontOfSize:15.5];
    volumeLab.textAlignment = NSTextAlignmentLeft;
    volumeLab.textColor = [UIColor darkGrayColor];
    volumeLab.text = @"音量大小";
    [self.view addSubview:volumeLab];
    
    
    UILabel *minValueLab = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+140, 40, 30)];
    minValueLab.font = [UIFont systemFontOfSize:15];
    minValueLab.textAlignment = NSTextAlignmentRight;
    minValueLab.textColor = [UIColor lightGrayColor];
    minValueLab.text = @"0";
    [self.view addSubview:minValueLab];
    
    
    UILabel *maxValueLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, NAVIGATION_H+140, 40, 30)];
    maxValueLab.font = [UIFont systemFontOfSize:15];
    maxValueLab.textAlignment = NSTextAlignmentLeft;
    maxValueLab.textColor = [UIColor lightGrayColor];
    maxValueLab.text = @"100";
    [self.view addSubview:maxValueLab];
    
    
    
    //sliderBar
    UISlider *sliderBar = [[UISlider alloc] initWithFrame:CGRectMake(45, NAVIGATION_H+140, SCREEN_WIDTH-90, 30)];
    sliderBar.tintColor = COLOR_E0212A;
    [sliderBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    sliderBar.value = self.volumeValue/100;
    [self.view addSubview:sliderBar];
    self.MainSlider = sliderBar;
}
- (void)mainswitchStatusChanged:(UISwitch *)sender {
    NSLog(@"sender.on = %d", sender.on);
    if (sender.on) {
        [self setVolumeStatus:50 flag:1];
    } else {
        [self setVolumeStatus:0 flag:1];
    }
}
- (void)sliderValueChanged:(UISlider *)slider {
    [self setVolumeStatus:slider.value*100 flag:2];
}

#pragma mark ------ 音量设置 ------
/*
 * volume: 音量值
 * flag: 1表示开关设置; 2表示音量设置
 */
- (void)setVolumeStatus:(CGFloat)volume flag:(int)flag {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId   forKey:@"deviceId"];
    [params setValue:self.deviceCode forKey:@"deviceCode"];
    [params setValue:@((int)volume)  forKey:@"voice"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/app/user/l3/in/voice.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"音量设置返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            if (flag == 1) {//开关设置
                self.volumeValue = (CGFloat)volume;
                self.MainSlider.value = self.volumeValue/100.0;
            
            } else {//音量设置
                [self.MainSwitch setOn:(volume>0)?YES:NO animated:YES];
            }
            
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DEVICE_INFOS_NOTIFICATION" object:nil];
            
        } else {
            if (flag == 1) {//开关设置
                [self.MainSwitch setOn:!self.MainSwitch.on animated:YES];
            } else {
                self.MainSlider.value = self.volumeValue/100.0;
            }
            
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        if (flag == 1) {//开关设置
            [self.MainSwitch setOn:!self.MainSwitch.on animated:YES];
        } else {
            self.MainSlider.value = self.volumeValue/100.0;
        }
        
    }];
}

@end
