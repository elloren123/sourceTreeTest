//
//  ADLDeviceInfoController.h
//  lockboss
//
//  Created by Adel on 2019/9/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@class ADLDeviceModel;

@interface ADLDeviceInfoController : ADLBaseViewController

@property (nonatomic, strong) ADLDeviceModel *model;

@property (nonatomic,assign) BOOL isHotelDevice;//是否是酒店设备,非酒店不传

@end
