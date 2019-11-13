//
//  ADLHotelOrderCommentController.h
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ADLHotelOrderModel;
@interface ADLHotelOrderCommentController : ADLBaseViewController
@property (nonatomic ,strong)ADLHotelOrderModel *model;
@property (nonatomic ,copy)NSString *navigTitle;
@property (nonatomic ,assign)int afterType;   //1评论  2,用户退款请求 
@end

NS_ASSUME_NONNULL_END
