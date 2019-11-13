//
//  ADLHotelOrderPayCell.h
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLHotelOrderPayCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,strong)UIImageView *iconImage;
@property (nonatomic ,strong)UILabel *name;
@property (nonatomic ,strong)UILabel *title;
@property (nonatomic ,strong)UIButton *iconbtn;
@end

NS_ASSUME_NONNULL_END
