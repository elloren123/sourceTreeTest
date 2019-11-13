//
//  ADLFamilySettingController.h
//  lockboss
//
//  Created by Adel on 2019/9/5.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@class ADLDeviceModel;

@interface ADLFamilySettingController : ADLBaseViewController

@property (nonatomic, strong) ADLDeviceModel *model;

///1网关 2门锁
//现在的界面中,不存在对网关的设置  TODO

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) void (^familyNameChanged) (NSString *name);

@end
