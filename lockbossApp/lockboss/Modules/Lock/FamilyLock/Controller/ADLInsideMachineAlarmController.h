//
//  ADLInsideMachineAlarmController.h
//  lockboss
//
//  Created by adel on 2019/10/21.
//  Copyright © 2019 adel. All rights reserved.
/*
 居里富人闹钟vc
 */

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLInsideMachineAlarmController : ADLBaseViewController

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, copy) NSString *alarmTime;
@property (nonatomic, assign) int    switchStatus;  //开关状态: 1开启; 2关闭
@property (nonatomic, copy) NSString *validStatus;  //有效时间: 

@end

NS_ASSUME_NONNULL_END
