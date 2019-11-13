//
//  ADLSelectCouponController.h
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLSelectCouponController : ADLBaseViewController

@property (nonatomic, assign) double servicePrice;

@property (nonatomic, strong) NSString *skuIdsStr;

@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, assign) double money;

@property (nonatomic, copy) void (^clickCoupon) (NSDictionary *couponDict);

@end
