//
//  ADLFamilyUpgradeController.h
//  lockboss
//
//  Created by Adel on 2019/9/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@class ADLDeviceModel;

@interface ADLFamilyUpgradeController : ADLBaseViewController

@property (nonatomic, strong) ADLDeviceModel *model;

@property (nonatomic, assign) NSInteger type;

@end
