//
//  ADLHotelUnlockController.m
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelUnlockController.h"

#import "ADLAddGatewayController.h"//添加网关

#import "ADLFamilyDevicesController.h"//这个貌似不需要了,待定,子界面添加到网关中去;

#import "ADLFamilySettingController.h"//这个设置界面需要修改

#import "ADLFamilyNewSettingController.h"//新的设置界面

#import "ADLFamilyOpenLockController.h"//开锁记录

#import "ADLFSecretManageController.h"

#import "ADLFShareDeviceController.h"

#import "ADLFUnlockRecordController.h"

#import "ADLSwitchDeviceView.h"

#import "ADLDropMenuView.h"

#import "ADLFamilyView.h"

#import "ADLAllFamilyDeviceController.h"

#import "ADLHotelSettingViewController.h"

@interface ADLHotelUnlockController ()<ADLFamilyViewDelegate>

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ADLFamilyView *familyView;

@end

@implementation ADLHotelUnlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //*************ScrollView*************
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //家庭锁视图
    ADLFamilyView *familyView = [[ADLFamilyView alloc] initWithFrame:self.view.bounds];
    familyView.delegate = self;
    if(self.isFTT){
        familyView.isFTT = YES;
    }else {
        familyView.checkingInId = self.checkingInId;
    }
    [scrollView addSubview:familyView];
    self.familyView = familyView;
    
    //*************导航栏*************
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_H)];
    navView.backgroundColor = COLOR_E0212A;
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, NAV_H, NAV_H)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //----进入客人的设备设置界面-----
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [moreBtn setImage:[UIImage imageNamed:@"lock_set"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:moreBtn];
    moreBtn.hidden = !self.isMoreBtnShow;
    self.moreBtn = moreBtn;
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark ------ 返回 ------
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 进入到所有设备界面 ------
-(void)goAllUserDeviceVC{
    ADLAllFamilyDeviceController *allDeviceVC = [[ADLAllFamilyDeviceController alloc] init];
    allDeviceVC.checkingInId = self.checkingInId;
    [self.navigationController pushViewController:allDeviceVC animated:YES];
}

- (void)clickMoreBtn {
    [ADLDropMenuView showWithView:self.moreBtn imgNameArray:@[@"family_setting"] titleArray:@[@"通用设置"] lightMode:YES finish:^(NSInteger index) {
 
//        ADLFamilyNewSettingController *settingVC = [[ADLFamilyNewSettingController alloc] init];
//        settingVC.model = self.familyView.model;
//        settingVC.type = 0;
//        settingVC.familyNameChanged = ^(NSString *name) {
//            [self updateFamilyTitle:name];
//        };
//        [self.navigationController pushViewController:settingVC animated:YES];
        
        ADLHotelSettingViewController *setVC = [[ADLHotelSettingViewController alloc] init];
        setVC.model = self.familyView.model;
        [self.navigationController pushViewController:setVC animated:YES];
    }];
}


@end
