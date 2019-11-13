//
//  ADLGoodsEvaluateController.h
//  lockboss
//
//  Created by adel on 2019/6/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLGoodsEvaluateController : ADLBaseViewController

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *skuId;

@property (nonatomic, strong) NSString *goodsId;

@property (nonatomic, strong) NSString *goodsName;

@property (nonatomic, copy) void (^evaluateFinish) (void);

@end
