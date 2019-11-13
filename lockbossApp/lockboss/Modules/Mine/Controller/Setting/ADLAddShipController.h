//
//  ADLAddShipController.h
//  lockboss
//
//  Created by adel on 2019/4/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLAddShipController : ADLBaseViewController

@property (nonatomic, strong) NSString *addressId;

@property (nonatomic, strong) NSArray *provinceArr;

@property (nonatomic, copy) void(^finish) (NSDictionary *addressDict);

@end
