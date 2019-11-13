//
//  ADLGoodsEvaDetailController.h
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

@interface ADLGoodsEvaDetailController : ADLBaseViewController

@property (nonatomic, strong) NSMutableDictionary *evaluateDict;

@property (nonatomic, copy) void (^finishBlock) (NSMutableDictionary *dict);

@end
