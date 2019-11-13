//
//  ADLRecorderEvaluateController.h
//  lockboss
//
//  Created by adel on 2019/6/27.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLRecorderEvaluateController : ADLBaseViewController

@property (nonatomic, strong) NSString *recorderId;

@property (nonatomic, strong) NSString *serviceId;

@property (nonatomic, copy) void (^submitEvaluate) (void);

@end
