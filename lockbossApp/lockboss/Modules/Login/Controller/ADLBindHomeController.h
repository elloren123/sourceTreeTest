//
//  ADLBindHomeController.h
//  lockboss
//
//  Created by Adel on 2019/9/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLBindHomeController : ADLBaseViewController

@property (nonatomic, strong) NSString *unionId;

///1QQ  2微信
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) void (^finishLogin) (void);

@end
