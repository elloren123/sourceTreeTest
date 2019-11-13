//
//  ADLGoodsEvaListController.h
//  lockboss
//
//  Created by adel on 2019/5/13.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLGoodsEvaListController : ADLBaseViewController

@property (nonatomic, strong) NSString *goodsId;

@property (nonatomic, copy) void (^deallocAction) (void);

@end

