//
//  ADLSettleApplyController.h
//  lockboss
//
//  Created by Han on 2019/6/7.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLSettleApplyController : ADLBaseViewController

@property (nonatomic, assign) BOOL apply;

@property (nonatomic, copy) void (^submitAction) (void);

@end
