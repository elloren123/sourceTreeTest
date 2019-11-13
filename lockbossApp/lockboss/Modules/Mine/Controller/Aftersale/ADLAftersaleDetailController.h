//
//  ADLAftersaleDetailController.h
//  lockboss
//
//  Created by adel on 2019/7/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLAftersaleDetailController : ADLBaseViewController

@property (nonatomic, strong) NSString *aftersaleId;

@property (nonatomic, copy) void (^clickConfirmBtn) (void);

@end
