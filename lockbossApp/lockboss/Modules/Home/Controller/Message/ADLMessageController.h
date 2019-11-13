//
//  ADLMessageController.h
//  lockboss
//
//  Created by adel on 2019/4/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLMessageController : ADLBaseViewController

@property (nonatomic, copy) void (^finishBlock) (void);

@end
