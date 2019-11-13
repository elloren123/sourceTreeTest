//
//  ADLGatewayAddDeviceCell.h
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLDeviceModel;

@interface ADLGatewayAddDeviceCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong) ADLDeviceModel *model;

@end

NS_ASSUME_NONNULL_END
