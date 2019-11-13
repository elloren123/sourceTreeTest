//
//  ADLGoodsClassController.h
//  lockboss
//
//  Created by adel on 2019/5/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLGoodsClassController : ADLBaseViewController

@property (nonatomic, strong) NSString *className;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, assign) BOOL systemLock;

@end

