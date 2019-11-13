//
//  ADLHotelDetailsTableViewCell.h
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLBookingHotelModel;
@interface ADLHotelDetailsTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong)ADLBookingHotelModel *model;
@property (nonatomic ,copy)void(^blockBtn)(void);
@end

NS_ASSUME_NONNULL_END
