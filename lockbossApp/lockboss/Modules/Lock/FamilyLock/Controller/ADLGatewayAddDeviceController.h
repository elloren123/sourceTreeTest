//
//  ADLGatewayAddDeviceController.h
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ADLDeviceModel;
@interface ADLGatewayAddDeviceController : ADLBaseViewController

@property (nonatomic ,strong) ADLDeviceModel *gatewayModel;//网关信息

@property (nonatomic ,strong) NSArray *gatewayChildDeviceArray;//网关下的子设备;

@end

NS_ASSUME_NONNULL_END
