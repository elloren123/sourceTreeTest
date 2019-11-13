//
//  ADLFSecretManageController.h
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@class ADLDeviceModel;

@interface ADLFSecretManageController : ADLBaseViewController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) ADLDeviceModel *model;

@end
