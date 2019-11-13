//
//  ADLPaySuccessController.m
//  lockboss
//
//  Created by adel on 2019/6/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLPaySuccessController.h"
#import "ADLStoreOrderController.h"

@interface ADLPaySuccessController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@end

@implementation ADLPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView:@"支付成功"];
    self.homeBtn.layer.cornerRadius = CORNER_RADIUS;
    self.top.constant = NAVIGATION_H+60;
    if (!self.serviceOrder) {
        self.promptLab.text = @"我们将尽快为您安排送货服务";
    }
    self.time = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    [self.homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
}

#pragma mark ------ 查看订单 ------
- (IBAction)clickLookMyOrderBtn:(UIButton *)sender {
    ADLStoreOrderController *orderVC = [[ADLStoreOrderController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark ------ 返回首页 ------
- (IBAction)clickGoHomeBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ------ 更新标题 ------
- (void)updateTitle {
    self.time--;
    if (self.time == 0) {
        [self.homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.homeBtn setTitle:[NSString stringWithFormat:@"返回首页(%lu)",self.time] forState:UIControlStateNormal];
    }
}

@end
