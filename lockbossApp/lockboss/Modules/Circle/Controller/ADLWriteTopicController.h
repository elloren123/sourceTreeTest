//
//  ADLWriteTopicController.h
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLWriteTopicController : ADLBaseViewController

@property (nonatomic, strong) NSString *circleId;

@property (nonatomic, copy) void (^publishAction) (void);

@end
