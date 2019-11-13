//
//  ADLSelAfterTypeController.h
//  lockboss
//
//  Created by adel on 2019/7/1.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLSelAfterTypeController : ADLBaseViewController

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, copy) void (^finishBlock) (void);

@property (nonatomic, assign) NSInteger startRange;

@property (nonatomic, assign) BOOL orderVC;

@end
