//
//  ADLOrderDinnerController.h
//  lockboss
//
//  Created by bailun91 on 2019/9/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLOrderDinnerController : ADLBaseViewController

@property (nonatomic, assign) int       goodsType;//0表示美食; 1表示特产
@property (nonatomic,   copy) NSString  *hotalAddress;

@end

NS_ASSUME_NONNULL_END
