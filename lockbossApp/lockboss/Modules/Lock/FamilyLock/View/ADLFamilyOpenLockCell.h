//
//  ADLFamilyOpenLockCell.h
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLLockRecordModel.h"

NS_ASSUME_NONNULL_BEGIN
//@class ADLLockModel,ADLDeviceModel;

@interface ADLFamilyOpenLockCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ADLLockRecordModel *model;

//@property (nonatomic, strong) ADLDeviceModel *model;
//@property (nonatomic, strong) ADLLockModel *lockModel;
//
//@property (nonatomic, strong) ADLDeviceModel *equipmentModel;
//@property (nonatomic, strong) UIButton *btn;





@end

NS_ASSUME_NONNULL_END
