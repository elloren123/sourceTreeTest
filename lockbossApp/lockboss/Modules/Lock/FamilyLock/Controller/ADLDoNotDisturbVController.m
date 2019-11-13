//
//  ADLDoNotDisturbVController.m
//  lockboss
//
//  Created by bailun91 on 2019/10/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLDoNotDisturbVController.h"

@interface ADLDoNotDisturbVController ()

@property (nonatomic, strong) UISwitch *MainSwitch;

@end


@implementation ADLDoNotDisturbVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRedNavigationView:@"勿扰"];
    [self createContentView];
}
- (void)createContentView {
    // ------ **** ------
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATION_H, SCREEN_WIDTH/2, 60)];
    txtLab.font = [UIFont systemFontOfSize:15.5];
    txtLab.textAlignment = NSTextAlignmentLeft;
    txtLab.textColor = [UIColor blackColor];
    txtLab.text = @"勿扰模式";
    [self.view addSubview:txtLab];
    
    
    UISwitch *witch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, NAVIGATION_H+15, 50, 30)];
    witch.onTintColor = COLOR_E0212A;//开状态下的颜色
    witch.tintColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];//开状态下的颜色
    [witch addTarget:self action:@selector(mainswitchStatusChanged:) forControlEvents:UIControlEventValueChanged];
    [witch setOn:(self.disturbStatus == 1)?YES:NO animated:NO];
    [self.view addSubview:witch];
    self.MainSwitch = witch;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+60, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self.view addSubview:line];
}
- (void)mainswitchStatusChanged:(UISwitch *)sender {
    NSLog(@"sender.on = %d", sender.on);
    
    //设置开关状态
    if (sender.on) {
        [self settingNoDisturbMode:1];
    } else {
        [self settingNoDisturbMode:2];
    }
}

#pragma mark ------ 勿扰设置 ------
- (void)settingNoDisturbMode:(int)opt {
    NSLog(@"opt = %d", opt);
    [ADLToast showLoadingMessage:@"请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceId   forKey:@"deviceId"];
    [params setValue:self.deviceCode forKey:@"deviceCode"];
    [params setValue:@(opt)          forKey:@"opt"];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
//    NSLog(@"设置参数: %@", params);
    
    ///网络请求
    [ADLNetWorkManager postWithPath:ADELMain_UrlSan"/lockboss-api/app/user/l3/in/doNotDisturb.do" parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        NSLog(@"勿扰设置返回: %@", responseDict);
        if ([responseDict[@"code"] intValue] == 10000) {    //成功
            [ADLToast hide];
            
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_DEVICE_INFOS_NOTIFICATION" object:nil];
        } else {
            //设置开关状态
            [self.MainSwitch setOn:(opt == 2)?YES:NO animated:YES];
            [ADLToast showMessage:responseDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error ---> %@", error);
        
        //设置开关状态
        [self.MainSwitch setOn:(opt == 2)?YES:NO animated:YES];
    }];
}

@end
