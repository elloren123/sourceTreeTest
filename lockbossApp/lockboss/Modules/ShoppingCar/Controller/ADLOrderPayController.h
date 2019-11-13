//
//  ADLOrderPayController.h
//  lockboss
//
//  Created by adel on 2019/6/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLOrderPayController : ADLBaseViewController

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, assign) double money;

@property (nonatomic, assign) BOOL serviceOrder;

@end
