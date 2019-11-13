//
//  ADLHotelCollectController.h
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ADLBookingHotelModel;
@interface ADLHotelCollectController : ADLBaseViewController
@property (nonatomic ,assign)NSInteger titleType; //0收藏夹 1 浏览记录
@property (nonatomic ,strong)ADLBookingHotelModel *model;
@end

NS_ASSUME_NONNULL_END
