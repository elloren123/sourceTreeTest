//
//  ADLFAuthorityDetailController.h
//  lockboss
//
//  Created by Adel on 2019/9/19.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLFAuthorityDetailController : ADLBaseViewController

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, copy) void (^refresh) (void);

@end
