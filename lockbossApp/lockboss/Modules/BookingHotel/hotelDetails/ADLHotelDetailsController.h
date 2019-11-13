//
//  ADLHotelDetailsController.h
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ADLBookingHotelModel;
@interface ADLHotelDetailsController : ADLBaseViewController
@property (nonatomic ,strong)ADLBookingHotelModel *model;
@end

NS_ASSUME_NONNULL_END
