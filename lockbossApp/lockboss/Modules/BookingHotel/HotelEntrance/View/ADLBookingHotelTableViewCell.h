//
//  ADLBookingHotelTableViewCell.h
//  lockboss
//
//  Created by adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLBookingHotelModel;
@interface ADLBookingHotelTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong)ADLBookingHotelModel *model;
@end

NS_ASSUME_NONNULL_END
