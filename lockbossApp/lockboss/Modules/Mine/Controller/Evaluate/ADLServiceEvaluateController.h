//
//  ADLServiceEvaluateController.h
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLServiceEvaluateController : ADLBaseViewController

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *personId;

@property (nonatomic, copy) void (^evaluateFinish) (void);

@end
