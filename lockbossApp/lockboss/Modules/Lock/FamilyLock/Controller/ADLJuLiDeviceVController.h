//
//  ADLJuLiDeviceVController.h
//  lockboss
//
//  Created by bailun91 on 2019/10/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLJuLiDeviceVController : ADLBaseViewController

@property (nonatomic,   copy) NSString *deviceId;
@property (nonatomic,   copy) NSString *deviceCode;
@property (nonatomic,   copy) NSString *deviceType;     //设备类型: 30表示外机; 31表示内机;
@property (nonatomic,   copy) NSString *deviceName;     //设备名称
@property (nonatomic,   copy) NSString *deviceStatus;   //是否在线
@property (nonatomic, strong) NSArray *devArray; //设备列表

@end

NS_ASSUME_NONNULL_END
