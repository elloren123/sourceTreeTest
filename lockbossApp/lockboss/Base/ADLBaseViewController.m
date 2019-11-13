//
//  ADLBaseViewController.m
//  lockboss
//
//  Created by adel on 2019/3/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"
#import "ADLLoginController.h"

@interface ADLBaseViewController ()

@end

@implementation ADLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_F2F2F2;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArr = [[NSMutableArray alloc] init];
    self.offset = 0;
    self.pageSize = 20;
}

#pragma mark ------ 自定义导航栏 ------
- (void)addNavigationView:(NSString *)title {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [navigationView addSubview:backBtn];
    self.backBtn = backBtn;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(NAV_H, STATUS_HEIGHT, SCREEN_WIDTH-NAV_H*2, NAV_H)];
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = COLOR_333333;
    [navigationView addSubview:titleLab];
    titleLab.text = title;
    self.titleLab = titleLab;
    
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H-0.3, SCREEN_WIDTH, 0.3)];
    spView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [navigationView addSubview:spView];
    self.spView = spView;
}

#pragma mark ------ 红色导航栏 ------
- (void)addRedNavigationView:(NSString *)title {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navigationView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [navigationView addSubview:backBtn];
    self.backBtn = backBtn;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(NAV_H, STATUS_HEIGHT, SCREEN_WIDTH-NAV_H*2, NAV_H)];
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [navigationView addSubview:titleLab];
    titleLab.text = title;
    self.titleLab = titleLab;
}

#pragma mark ------ 返回 ------
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 跳转到登录控制器 ------
- (void)pushLoginViewControllerHideTabbar:(BOOL)hideTabbar success:(void(^)(void))success {
    ADLLoginController *loginVC = [[ADLLoginController alloc] init];
    if (hideTabbar) {
        loginVC.hidesBottomBarWhenPushed = YES;
    }
    if (success) {
        loginVC.loginSuccess = ^{ success(); };
    }
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark ------ 添加左边文字按钮 ------
- (UIButton *)addLeftButtonWithTitle:(NSString *)title action:(SEL)action {
    //不考虑多个按钮和情况，基本用不到；action不要传nil，否则崩溃,也不要添加多次
    CGFloat titleW = [ADLUtils calculateString:title rectSize:CGSizeMake(MAXFLOAT, 44) fontSize:16].width+14;
    self.titleLab.frame = CGRectMake(titleW, STATUS_HEIGHT, SCREEN_WIDTH-titleW*2, NAV_H);
    [self.backBtn removeFromSuperview];
    self.backBtn = nil;
    
    UIButton *leftTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, titleW, NAV_H)];
    [leftTextBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    leftTextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftTextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    leftTextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftTextBtn setTitle:title forState:UIControlStateNormal];
    [leftTextBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:leftTextBtn];
    return leftTextBtn;
}

#pragma mark ------ 添加左边图片按钮 ------
- (UIButton *)addLeftButtonWithImageName:(NSString *)imageName action:(SEL)action {
    [self.backBtn removeFromSuperview];
    self.backBtn = nil;
    
    UIButton *leftImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [leftImageBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    leftImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [leftImageBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:leftImageBtn];
    return leftImageBtn;
}

#pragma mark ------ 添加右边文字按钮 ------
- (UIButton *)addRightButtonWithTitle:(NSString *)title action:(SEL)action {
    CGFloat titleW = [ADLUtils calculateString:title rectSize:CGSizeMake(MAXFLOAT, 44) fontSize:16].width+14;
    self.titleLab.frame = CGRectMake(titleW, STATUS_HEIGHT, SCREEN_WIDTH-titleW*2, NAV_H);
    
    UIButton *rightTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-titleW, STATUS_HEIGHT, titleW, NAV_H)];
    [rightTextBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    rightTextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightTextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    rightTextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightTextBtn setTitle:title forState:UIControlStateNormal];
    [rightTextBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:rightTextBtn];
    return rightTextBtn;
}

#pragma mark ------ 添加右边图片按钮 ------
- (UIButton *)addRightButtonWithImageName:(NSString *)imageName action:(SEL)action {
    UIButton *rightImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [rightImageBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    rightImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    [rightImageBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:rightImageBtn];
    return rightImageBtn;
}

#pragma mark ------ 从下向上的Push动画 ------
- (void)customPushViewController:(UIViewController *)controller {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4 ;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark ------ 从上向下的Pop动画 ------
- (void)customPopViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc {
    NSLog(@"loc = %@, desc = %@",self.class,@"dealloc");
}

@end
