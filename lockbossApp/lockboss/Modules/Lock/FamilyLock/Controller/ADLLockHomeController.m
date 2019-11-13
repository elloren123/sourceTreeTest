//
//  ADLLockHomeController.m
//  lockboss
//
//  Created by Adel on 2019/8/26.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLLockHomeController.h"

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

#import "ADLHotelView.h"

#import "ADLCampusView.h"

#import "ADLAllFamilyDeviceController.h"

#import "ADLHotelUnlockController.h"

#import "ADLOrderDinnerController.h"

#import "ADLAllServiceController.h"

#import "ADLReservationServiceController.h"

#import "ADLHotelServiceModel.h"

#import "ADLGuestRoomsModel.h"

#import "ADLHomeServiceModel.h"

@interface ADLLockHomeController ()<UIScrollViewDelegate,ADLFamilyViewDelegate,ADLHotelViewDelegate>

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *changeHotelBtn;//切换酒店,没有英文  TODO

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UISegmentedControl *segControl;

@property (nonatomic, strong) ADLFamilyView *familyView;

@property (nonatomic, strong) ADLHotelView *hotelView;

@property (nonatomic, strong) ADLCampusView *campusView;

@property (nonatomic, strong) NSString *familyTitle;

@property (nonatomic, strong) NSString *hotelTitle;

@property (nonatomic, strong) NSString *campusTitle;

@end

@implementation ADLLockHomeController

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
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //家庭锁视图
    ADLFamilyView *familyView = [[ADLFamilyView alloc] initWithFrame:self.view.bounds];
    familyView.delegate = self;
    familyView.checkingInId = @"0";
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
    
    //更多
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-NAV_H, STATUS_HEIGHT, NAV_H, NAV_H)];
    [moreBtn setImage:[UIImage imageNamed:@"lock_set"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    moreBtn.hidden = YES;
    
    UIButton *changeHotelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, STATUS_HEIGHT, 60, NAV_H)];
    [changeHotelBtn setTitle:@"切换房间" forState:UIControlStateNormal];
    [changeHotelBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    changeHotelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [changeHotelBtn addTarget:self action:@selector(clickChangeHotel) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:changeHotelBtn];
    self.changeHotelBtn = changeHotelBtn;
    changeHotelBtn.hidden = YES;
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] init];
    segControl.tintColor = [UIColor whiteColor];
    segControl.backgroundColor = COLOR_E0212A;
    [segControl addTarget:self action:@selector(segControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [navView addSubview:segControl];
    
    self.segControl = segControl;
    segControl.hidden = YES;
    
    [self queryUserPattern];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark ------ 查询用户模式 ------
- (void)queryUserPattern {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[ADLUtils handleParamsSign:params] forKey:@"sign"];
    [ADLNetWorkManager postWithPath:ADEL_getUserPattern parameters:params autoToast:YES success:^(NSDictionary *responseDict) {
        ADLLog(@"用户模式 == %@",responseDict);
        if ([responseDict[@"code"] integerValue] == 10000) {
            
            NSDictionary *dict = responseDict[@"data"];
            [self.dataArr removeAllObjects];
            [self.segControl removeAllSegments];
            [self.dataArr addObject:ADLString(@"family")];//默认添加一个家庭 ?? TODO
            if ([dict[@"isUser"] boolValue]) {
                [self.dataArr addObject:ADLString(@"hotel")];
                self.hotelView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [self.scrollView addSubview:self.hotelView];
            }
            if ([dict[@"isSchool"] boolValue]) {
                [self.dataArr addObject:ADLString(@"campus")];
                if ([dict[@"isUser"] boolValue]) {
                    self.campusView.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                } else {
                    self.campusView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }
                [self.scrollView addSubview:self.campusView];
            }
            NSInteger number = self.dataArr.count;
            if (number > 1) {
                self.segControl.hidden = NO;
                self.segControl.frame = CGRectMake((SCREEN_WIDTH-180)/2, STATUS_HEIGHT+6, 180, 32); //+6是为了和左侧的返回按钮居中对齐,按钮高度为44
                for (int i = 0; i < number; i++) {
                    [self.segControl insertSegmentWithTitle:self.dataArr[i] atIndex:i animated:NO];
                }
                
                //这里会有个小问题，暂不处理
                //什么问题  ?? TODO
                int index = [[[NSUserDefaults standardUserDefaults] valueForKey:USER_PATTERN] intValue];
                self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*number, 0);
                if (index < number-1) {
                    self.segControl.selectedSegmentIndex = index;
                    [self.scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:NO];
                    [self changeNavRigBtnWith:index];
                    
                } else {
                    [ADLUtils saveValue:@(0) forKey:USER_PATTERN];
                    self.segControl.selectedSegmentIndex = 0;
                    self.scrollView.contentOffset = CGPointZero;
                    [self changeNavRigBtnWith:index];
                }
            } else {
                self.segControl.hidden = YES;
                self.scrollView.contentSize = CGSizeZero;
                self.scrollView.contentOffset = CGPointZero;
            }
        }
    } failure:nil];
}

#pragma mark ------ 返回 ------
- (void)clickBackBtn {
    //这里应该改成直接返回到根视图去;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ------ 右侧下拉列表 ------
- (void)clickMoreBtn {
    [ADLDropMenuView showWithView:self.moreBtn imgNameArray:@[@"chat_more",@"topic_write",@"family_setting"] titleArray:@[ADLString(@"add_gateway"),ADLString(@"unlock_records"),ADLString(@"setting")] lightMode:YES finish:^(NSInteger index) {
        if (index == 0) {
            ADLAddGatewayController *addGatewayVC = [[ADLAddGatewayController alloc] init];
            [self.navigationController pushViewController:addGatewayVC animated:YES];
        } else if(index == 1){
            ADLFamilyOpenLockController *openLockVC = [[ADLFamilyOpenLockController alloc] init];
            openLockVC.model = self.familyView.model;
            [self.navigationController pushViewController:openLockVC animated:YES];
        } else {
            ADLFamilyNewSettingController *settingVC = [[ADLFamilyNewSettingController alloc] init];
            settingVC.model = self.familyView.model;
            settingVC.type = 0;
            settingVC.familyNameChanged = ^(NSString *name) {
                [self updateFamilyTitle:name];
            };
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }];
}

#pragma mark ------ 家庭锁设备 ------
- (void)clickDeviceBtn {
    ADLFamilyDevicesController *devicesVC = [[ADLFamilyDevicesController alloc] init];
    [self.navigationController pushViewController:devicesVC animated:YES];
}

#pragma mark ------ 切换UISegmentedControl ------
- (void)segControlValueChanged:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    [ADLUtils saveValue:@(index) forKey:USER_PATTERN];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
    //切换时,判断是否为酒店,修改右侧导航按钮
    [self changeNavRigBtnWith:index];
    
}
#pragma mark ------ 切换导航右侧按钮 ------
-(void)changeNavRigBtnWith:(NSInteger)index {
    if (self.dataArr.count>index && (self.dataArr[index] == ADLString(@"hotel"))) {
        self.moreBtn.hidden = YES;
        self.changeHotelBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = NO;
        self.changeHotelBtn.hidden = YES;
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//滑动时同步segment
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.segControl.selectedSegmentIndex = index;
    [ADLUtils saveValue:@(index) forKey:USER_PATTERN];
}

#pragma mark ------ 更新家庭锁标题 ------
//这个方法应该不需要了,view中不再调用 TODO
- (void)updateFamilyTitle:(NSString *)title {
    NSInteger index = self.scrollView.contentOffset.x/SCREEN_WIDTH;
    if (index == 0) {
        self.familyTitle = title;
        if (title) {
            self.moreBtn.hidden = NO;
        } else {
            self.moreBtn.hidden = YES;
        }
    } else if (index == 1) {
        self.hotelTitle = title;
        
    } else {
        self.campusTitle = title;
    }
}


#pragma mark ****** family delegate ******

//  ------ 点击家庭锁Item ------
- (void)didClickLockItem:(NSInteger)index {
    if (index < 3) {
        ADLFSecretManageController *manageVC = [[ADLFSecretManageController alloc] init];
        manageVC.model = self.familyView.model;
        manageVC.type = index;
        [self.navigationController pushViewController:manageVC animated:YES];
    } else if (index == 3) {
        ADLFShareDeviceController *shareVC = [[ADLFShareDeviceController alloc] init];
        shareVC.model = self.familyView.model;
        [self.navigationController pushViewController:shareVC animated:YES];
    } else {
        ADLFUnlockRecordController *recordVC = [[ADLFUnlockRecordController alloc] init];
        recordVC.model = self.familyView.model;
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

#pragma mark ------ 进入到所有设备界面 ------
-(void)goAllUserDeviceVC{
    ADLAllFamilyDeviceController *allDeviceVC = [[ADLAllFamilyDeviceController alloc] init];
    [self.navigationController pushViewController:allDeviceVC animated:YES];
}

#pragma mark ------ 刷新用户模式 ------
- (void)refreshUserPattern {
    [self queryUserPattern];
}

#pragma mark ------ 懒加载 ------
- (ADLHotelView *)hotelView {
    if (_hotelView == nil) {
        _hotelView = [[ADLHotelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hotelView.backgroundColor = [UIColor clearColor];
        _hotelView.delegate = self;
    }
    return _hotelView;
}

- (ADLCampusView *)campusView {
    if (_campusView == nil) {
        _campusView = [[ADLCampusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _campusView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    }
    return _campusView;
}

#pragma mark 切换酒店
-(void)clickChangeHotel{
    ADLLog(@"切换酒店");
    [self.hotelView selectHotel];
}

#pragma mark ********************** ADLHotelViewDelegate **********************
-(void)bannelImgClickWith:(NSString *)urlString {
    ADLLog(@"点击的URL ==  %@",urlString);
    ADLOrderDinnerController *vc = [[ADLOrderDinnerController alloc] init];
    if ([urlString containsString:@"0+"]) {
        vc.goodsType = 0;
    } else {
        vc.goodsType = 1;
    }
    vc.hotalAddress = [urlString substringFromIndex:2];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)moreHotelRoomsDeivicesWithcheckingInId:(NSString *)checkingInId {
    ADLAllFamilyDeviceController *allDeviceVC = [[ADLAllFamilyDeviceController alloc] init];
    allDeviceVC.checkingInId = checkingInId;
    [self.navigationController pushViewController:allDeviceVC animated:YES];
}

-(void)deviceClickWith:(ADLDeviceModel *)deviceModel checkID:(NSString *)checkingInId {
    [ADLUtils saveValue:deviceModel.deviceId forKey:HOTEL_DEVICE_SELECT];
    ADLHotelUnlockController *hotelVC = [[ADLHotelUnlockController alloc] init];
    hotelVC.checkingInId = checkingInId;
    if ([deviceModel.deviceType isEqualToString:@"111"] ) {
        hotelVC.isMoreBtnShow = YES;
    }
    [self.navigationController pushViewController:hotelVC animated:YES];
    
}
#pragma mark ------ 查看更多服务 ------
-(void)moreHotelRoomsServicesWithcheckingInId:(ADLGuestRoomsModel *)model {
    ADLAllServiceController *vc = [[ADLAllServiceController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ------ 查看服务详情 ------
-(void)serviceClickWith:(ADLHotelServiceModel *)serviceModel guestRoomsModel:(ADLGuestRoomsModel *)model{
    ADLReservationServiceController *vc = [[ADLReservationServiceController alloc]init];
    
    NSMutableDictionary *dict =[serviceModel mj_keyValues];
    [dict addEntriesFromDictionary:[model mj_keyValues]];
    vc.model = [ADLHomeServiceModel mj_objectWithKeyValues:dict];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ------ 433设备点击 ------
-(void)deviceFTTClick {
    ADLHotelUnlockController *hotelVC = [[ADLHotelUnlockController alloc] init];
    hotelVC.isFTT = YES;
    [self.navigationController pushViewController:hotelVC animated:YES];
}

#pragma mark ------ 移除通知 ------
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
