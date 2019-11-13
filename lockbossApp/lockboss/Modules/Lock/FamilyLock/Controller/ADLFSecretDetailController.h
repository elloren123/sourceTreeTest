//
//  ADLFSecretDetailController.h
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@class ADLDeviceModel;

@interface ADLFSecretDetailController : ADLBaseViewController

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) ADLDeviceModel *model;

///1 密码 2 卡  3 指纹
@property (nonatomic, assign) NSInteger secretType;

///1 永久 2 临时
@property (nonatomic, assign) NSInteger dataType;

///删除、修改日期操作
@property (nonatomic, copy) void (^refreshBlock) (void);

@end
