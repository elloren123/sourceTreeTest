//
//  ADLHotelUnlockController.h
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
/*
酒店的设备的控制界面,没法和家庭的公用是,逻辑跳转很乱这样
*/

#import "ADLBaseViewController.h"
#import "ADLDeviceModel.h"
//#import "ADLGuestRoomsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ADLHotelUnlockController : ADLBaseViewController

@property (nonatomic ,strong)NSString *checkingInId;

@property (nonatomic ,assign)BOOL isFTT;//是否433系列

@property (nonatomic,assign)BOOL isMoreBtnShow;//对于1800 和河马防盗,有更多的显示

@end

NS_ASSUME_NONNULL_END
