//
//  ADLFUnlockMethodController.h
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLFAddSecretController : ADLBaseViewController

///1 添加密码 2 添加指纹 3 添加RF卡  4添加人脸??  TODO
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString *deviceCode;

@property (nonatomic, strong) NSString *deviceType;

@property (nonatomic, strong) NSString *gatewayCode;

@property (nonatomic, copy) void (^success) (void);

@end

