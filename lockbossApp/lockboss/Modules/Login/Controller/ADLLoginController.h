//
//  ADLLoginController.h
//  lockboss
//
//  Created by adel on 2019/4/16.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLLoginController : ADLBaseViewController

@property (nonatomic, copy) void (^loginSuccess) (void);

@end
