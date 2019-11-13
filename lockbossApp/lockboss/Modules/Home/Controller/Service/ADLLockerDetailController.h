//
//  ADLLockerDetailController.h
//  lockboss
//
//  Created by adel on 2019/6/18.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLLockerDetailController : ADLBaseViewController

@property (nonatomic, strong) NSString *lockerId;

@property (nonatomic, assign) BOOL hideSelBtn;

@property (nonatomic, copy) void (^selectLocker) (void);

@end
