//
//  ADLReservationServiceCell.h
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLReservationServiceCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *lockName;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIButton *switchBtn;
@end

NS_ASSUME_NONNULL_END
