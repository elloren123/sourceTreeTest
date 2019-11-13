//
//  ADLApplyLeagueController.h
//  lockboss
//
//  Created by adel on 2019/6/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLApplyLeagueController : ADLBaseViewController

@property (nonatomic, assign) BOOL apply;

@property (nonatomic, copy) void (^applyAction) (void);

@end
