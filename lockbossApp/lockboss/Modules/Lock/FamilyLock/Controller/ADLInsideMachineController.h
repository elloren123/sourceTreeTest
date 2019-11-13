//
//  ADLInsideMachineController.h
//  lockboss
//
//  Created by adel on 2019/10/21.
//  Copyright © 2019 adel. All rights reserved.
/*
 
 居里富人,内机
 
 */

#import "ADLBaseViewController.h"
@class ADLDeviceModel;
NS_ASSUME_NONNULL_BEGIN

@interface ADLInsideMachineController : ADLBaseViewController

@property (nonatomic ,strong) ADLDeviceModel *insideMachineModel;//内机信息

@property (nonatomic ,strong) NSArray *otherChildDeviceArray;//其他子设备;

@end

NS_ASSUME_NONNULL_END
