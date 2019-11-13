//
//  ADLSelectServiceController.h
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLSelectServiceController : ADLBaseViewController

@property (nonatomic, strong) NSString *areaId;

@property (nonatomic, copy) void (^clickAction) (NSMutableDictionary *serviceDict);

@end

