//
//  ADLBindHomeController.m
//  lockboss
//
//  Created by Adel on 2019/9/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBindHomeController.h"
#import "ADLBindAccountController.h"

@interface ADLBindHomeController ()

@end

@implementation ADLBindHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"关联账号"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-66)/2, NAVIGATION_H+60, 66, 66)];
    imgView.image = [UIImage imageNamed:@"app_logo"];
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = 10;
    [self.view addSubview:imgView];
    
    UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_H+156, SCREEN_WIDTH-60, 20)];
    promptLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    promptLab.textAlignment = NSTextAlignmentCenter;
    promptLab.text = @"您的账号未关联锁老大账号";
    promptLab.textColor = COLOR_333333;
    [self.view addSubview:promptLab];
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    newBtn.frame = CGRectMake(29, NAVIGATION_H+246, SCREEN_WIDTH-58, VIEW_HEIGHT);
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [newBtn setTitle:@"关联新账号" forState:UIControlStateNormal];
    newBtn.backgroundColor = APP_COLOR;
    newBtn.layer.cornerRadius = CORNER_RADIUS;
    [newBtn addTarget:self action:@selector(clickLinkAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];
    
    UIButton *existBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    existBtn.frame = CGRectMake(29, NAVIGATION_H+VIEW_HEIGHT+262, SCREEN_WIDTH-58, VIEW_HEIGHT);
    [existBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    existBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [existBtn setTitle:@"关联已有账号" forState:UIControlStateNormal];
    existBtn.tag = 23;
    existBtn.backgroundColor = APP_COLOR;
    existBtn.layer.cornerRadius = CORNER_RADIUS;
    [existBtn addTarget:self action:@selector(clickLinkAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:existBtn];
}

#pragma mark ------ 关联账号 ------
- (void)clickLinkAccount:(UIButton *)sender {
    ADLBindAccountController *accountVC = [[ADLBindAccountController alloc] init];
    accountVC.unionId = self.unionId;
    accountVC.type = self.type;
    if (sender.tag == 23) {
        accountVC.existing = YES;
    } else {
        accountVC.existing = NO;
    }
    accountVC.loginSuccess = ^{
        if (self.finishLogin) {
            self.finishLogin();
        }
    };
    [self.navigationController pushViewController:accountVC animated:YES];
}

@end
