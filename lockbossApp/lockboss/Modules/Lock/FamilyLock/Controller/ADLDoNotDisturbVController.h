//
//  ADLDoNotDisturbVController.h
//  lockboss
//
//  Created by bailun91 on 2019/10/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLDoNotDisturbVController : ADLBaseViewController

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, assign) int    disturbStatus;    //勿扰状态: 1：请勿打扰; 0：关闭"

@end

NS_ASSUME_NONNULL_END
