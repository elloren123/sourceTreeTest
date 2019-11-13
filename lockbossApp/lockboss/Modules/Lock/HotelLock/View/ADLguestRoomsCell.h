//
//  ADLguestRoomsCell.h
//  ADEL-APP
//
//  Created by bailun91 on 2018/6/14.
//

#import <UIKit/UIKit.h>
@class ADLGuestRoomsModel;
@interface ADLguestRoomsCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ADLGuestRoomsModel *model;

@property (nonatomic, copy)void(^addressBlack)(UIButton *btn);
@end
