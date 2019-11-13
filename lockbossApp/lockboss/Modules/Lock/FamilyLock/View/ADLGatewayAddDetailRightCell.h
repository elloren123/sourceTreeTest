//
//  ADLGatewayAddDetailRightCell.h
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLDeviceTypeModel;

@interface ADLGatewayAddDetailRightCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong) ADLDeviceTypeModel *deviceTypeModel;

@end

NS_ASSUME_NONNULL_END
