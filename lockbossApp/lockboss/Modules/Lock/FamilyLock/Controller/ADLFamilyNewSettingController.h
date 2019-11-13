//
//  ADLFamilyNewSettingController.h
//  lockboss
//
//  Created by adel on 2019/10/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@class ADLDeviceModel;

@interface ADLFamilyNewSettingController : ADLBaseViewController

@property (nonatomic, strong) ADLDeviceModel *model;

///1网关 2门锁
//现在的界面中,不存在对网关的设置  TODO
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger homeOrHotel;//0家庭,1酒店;

@property (nonatomic, copy) void (^familyNameChanged) (NSString *name);

@end

NS_ASSUME_NONNULL_END
