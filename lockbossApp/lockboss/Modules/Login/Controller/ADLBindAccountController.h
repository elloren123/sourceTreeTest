//
//  ADLBindAccountController.h
//  lockboss
//
//  Created by Adel on 2019/9/3.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLBindAccountController : ADLBaseViewController

@property (nonatomic, strong) NSString *unionId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL existing;

@property (nonatomic, copy) void (^loginSuccess) (void);

@end
