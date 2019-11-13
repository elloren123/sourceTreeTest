//
//  ADLAddDeviceStepOneController.h
//  lockboss

//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class  ADLDeviceTypeModel;
@interface ADLAddDeviceStepOneController : ADLBaseViewController

@property (nonatomic ,strong) ADLDeviceTypeModel *deviceTypeModel;

@property (nonatomic ,strong) NSArray *gatewayChildDeviceArray;

@end

NS_ASSUME_NONNULL_END
