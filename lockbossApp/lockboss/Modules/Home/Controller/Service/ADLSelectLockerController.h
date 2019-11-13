//
//  ADLSelectLockerController.h
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLSelectLockerController : ADLBaseViewController

@property (nonatomic, strong) NSString *address;

@property (nonatomic, copy) void (^clickAction) (NSDictionary *lockerDict);

@end
