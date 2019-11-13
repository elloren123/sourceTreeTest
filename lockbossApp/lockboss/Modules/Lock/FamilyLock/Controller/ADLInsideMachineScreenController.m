//
//  ADLInsideMachineScreenController.m
//  lockboss
//
//  Created by adel on 2019/10/21.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLInsideMachineScreenController.h"

@interface ADLInsideMachineScreenController ()

@property (nonatomic, strong) UISwitch      *MainSwitch;
@property (nonatomic, strong) UISlider      *MainSlider;
@property (nonatomic, strong) UIButton      *volumeBtn;

@end

@implementation ADLInsideMachineScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"屏幕"];
    [self createContentView];
}
- (void)createContentView {
    // ------ **** ------
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H, SCREEN_WIDTH/2, 60)];
    txtLab.font = [UIFont systemFontOfSize:15.5];
    txtLab.textAlignment = NSTextAlignmentLeft;
    txtLab.textColor = [UIColor darkGrayColor];
    txtLab.text = @"屏幕开关";
    [self.view addSubview:txtLab];
    
    
    UISwitch *witch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, NAVIGATION_H+15, 50, 30)];
    witch.onTintColor = COLOR_E0212A;//开状态下的颜色
    witch.tintColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];//开状态下的颜色
    [witch addTarget:self action:@selector(mainswitchStatusChanged:) forControlEvents:UIControlEventValueChanged];
    [witch setOn:(self.brightnessValue > 0)?YES:NO animated:NO];
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
    
    //'同时关闭声音'按钮
    UIButton *markBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3-30, NAVIGATION_H+70, SCREEN_WIDTH/3+20, 40)];
    [markBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    markBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [markBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
    [markBtn setTitle:@"同时关闭声音" forState:UIControlStateNormal];
    [markBtn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    markBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:markBtn];
    self.volumeBtn = markBtn;
    
    
    
    
    // ------ **** ------
    UILabel *volumeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H+120, SCREEN_WIDTH/2, 60)];
    volumeLab.font = [UIFont systemFontOfSize:15.5];
    volumeLab.textAlignment = NSTextAlignmentLeft;
    volumeLab.textColor = [UIColor darkGrayColor];
    volumeLab.text = @"屏幕亮度";
    [self.view addSubview:volumeLab];
    
    
    
    //sliderBar
    UISlider *sliderBar = [[UISlider alloc] initWithFrame:CGRectMake(45, NAVIGATION_H+200, SCREEN_WIDTH-90, 30)];
    sliderBar.tintColor = COLOR_E0212A;
    [sliderBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    sliderBar.value = self.brightnessValue/100;
    [self.view addSubview:sliderBar];
    self.MainSlider = sliderBar;
}

- (void)clickBtnAction {
    self.volumeBtn.selected = !self.volumeBtn.selected;
    if (self.volumeBtn.selected) {
        [self.volumeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
    } else {
        [self.volumeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
    }
    
    int openFlag  = (self.MainSwitch.on == YES)?1:2;
    int voiceFlag = (self.volumeBtn.selected == YES)?1:2;
    [self setScreenSwitch:openFlag openVoice:voiceFlag flag:2];
}

- (void)mainswitchStatusChanged:(UISwitch *)sender {
    NSLog(@"sender.on = %d", sender.on);
    int openFlag  = (self.MainSwitch.on == YES)?1:2;
    int voiceFlag = (self.volumeBtn.selected == YES)?1:2;
    [self setScreenSwitch:openFlag openVoice:voiceFlag flag:1];
}

- (void)sliderValueChanged:(UISlider *)slider {
    NSLog(@"value: %d", (int)(slider.value*100));
    [self setScreenBrightness:(int)(slider.value*100)];
}

#pragma mark ------ 屏幕亮度设置 ------
/*
 * volume: 屏幕亮度值
 * flag: 1表示开关设置; 2表示音量设置
 */
- (void)setScreenBrightness:(int)value {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId   forKey:@"deviceId"];
    [params setValue:self.deviceCode forKey:@"deviceCode"];
    [params setValue:@(value)        forKey:@"brightness"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
//    NSLog(@"屏幕亮度设置参数: %@", params);
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/app/user/l3/in/brightness.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"屏幕亮度设置返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DEVICE_INFOS_NOTIFICATION" object:nil];
            
        } else {
            self.MainSlider.value = self.brightnessValue/100.0;
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        self.MainSlider.value = self.brightnessValue/100.0;
    }];
}
#pragma mark ------ 屏幕开关设置 ------
/*
 * openFlag: 屏幕开关状态值
 * voiceFlag: 声音开关状态值
 * flag: 1屏幕开关设置; 2声音开关设置
 */
- (void)setScreenSwitch:(int)openFlag openVoice:(int)voiceFlag flag:(int)flag {
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId   forKey:@"deviceId"];
    [params setValue:self.deviceCode forKey:@"deviceCode"];
    [params setValue:@(openFlag)     forKey:@"openScreen"];
    [params setValue:@(voiceFlag)    forKey:@"openVoice"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
//    NSLog(@"屏幕开关设置参数: %@", params);
    
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/app/user/l3/in/screen.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"屏幕开关设置返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DEVICE_INFOS_NOTIFICATION" object:nil];
            
        } else {
            if (flag == 1) {
                [self.MainSwitch setOn:!self.MainSwitch.on animated:YES];
            } else {
                if (self.volumeBtn.selected) {
                    [self.volumeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
                } else {
                    [self.volumeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
                }
            }

            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);

        if (flag == 1) {
            [self.MainSwitch setOn:!self.MainSwitch.on animated:YES];
        } else {
            if (self.volumeBtn.selected) {
                [self.volumeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong_G"] forState:UIControlStateNormal];
            } else {
                [self.volumeBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
            }
        }
    }];
}

@end
