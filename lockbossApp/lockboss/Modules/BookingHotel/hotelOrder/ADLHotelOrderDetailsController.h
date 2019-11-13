//
//  ADLHotelOrderDetailsController.h
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ADLHotelOrderModel;
@interface ADLHotelOrderDetailsController : ADLBaseViewController
@property (nonatomic ,strong)ADLHotelOrderModel *model;

@property (nonatomic, assign)int payType;//1待支付  2已经支付 3已完成 4已取消 5退款处理中
@end

NS_ASSUME_NONNULL_END
