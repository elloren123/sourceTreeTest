//
//  ADLShipAddressController.h
//  lockboss
//
//  Created by adel on 2019/4/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLShipAddressController : ADLBaseViewController

@property (nonatomic, copy) void(^clickAddress) (NSDictionary *addressDict);

@end
