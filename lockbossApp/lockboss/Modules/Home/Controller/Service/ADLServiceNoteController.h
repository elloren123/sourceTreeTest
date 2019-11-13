//
//  ADLServiceNoteController.h
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"
@class ADLServiceModel;

@interface ADLServiceNoteController : ADLBaseViewController

@property (nonatomic, strong) ADLServiceModel *model;

@property (nonatomic, copy) void (^clickConfirm) (ADLServiceModel *model);

@end
