//
//  ADLGatewayAddDetailLeftCell.h
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLGatewayAddDetailLeftCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong) UILabel *titLab;//导航标题

@property (nonatomic, assign) BOOL isSelected;//是否被选中

@end

NS_ASSUME_NONNULL_END
