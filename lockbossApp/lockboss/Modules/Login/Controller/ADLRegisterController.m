//
//  ADLRegisterController.m
//  lockboss
//
//  Created by adel on 2019/4/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRegisterController.h"
#import "ADLModifySuccessController.h"
#import "ADLRegisterView.h"

@interface ADLRegisterController ()<ADLRegisterViewDelegate>

@end

@implementation ADLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"注册"];
    ADLRegisterView *registerView = [[ADLRegisterView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_H) delegate:self];
    registerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:registerView];
}

#pragma mark ------ 注册成功 ------
- (void)didRegistPhoneAccount:(BOOL)phone {
    ADLModifySuccessController *modifyVC = [[ADLModifySuccessController alloc] init];
    modifyVC.titleName = @"注册成功";
    if (phone) {
        modifyVC.promptStr = @"注册成功";
        modifyVC.btnTitle = @"去登录";
    } else {
        modifyVC.promptStr = @"激活链接已发送至邮箱，确认后方可登录";
        modifyVC.btnTitle = @"确定";
    }
    [self.navigationController pushViewController:modifyVC animated:YES];
}

#pragma mark ------ 用户协议 ------
- (void)didClickProtocolBtn {
    
}

#pragma mark ------ 隐私政策 ------
- (void)didClickPrivacyBtn {
    
}

-(void)dealloc{
    ADLLog(@"销毁==== %s",__func__);
}

@end
