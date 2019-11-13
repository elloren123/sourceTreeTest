//
//  ADLRefundController.h
//  lockboss
//
//  Created by adel on 2019/7/11.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLRefundController : ADLBaseViewController

@property (nonatomic, strong) NSString *suborderId;

@property (nonatomic, strong) NSArray *refundArr;

@property (nonatomic, assign) BOOL service;

@end

