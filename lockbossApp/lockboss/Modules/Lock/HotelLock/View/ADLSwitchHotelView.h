//
//  ADLSwitchHotelView.h
//  lockboss
//
//  Created by adel on 2019/10/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLGuestRoomsModel;
@interface ADLSwitchHotelView : UIView

+ (instancetype)showWithSelectHotelMessage:(ADLGuestRoomsModel *)selHotelModel allHotelMeesage:(NSArray *)allHotelArray finish:(void(^)(ADLGuestRoomsModel *model))finish;

@end

NS_ASSUME_NONNULL_END
