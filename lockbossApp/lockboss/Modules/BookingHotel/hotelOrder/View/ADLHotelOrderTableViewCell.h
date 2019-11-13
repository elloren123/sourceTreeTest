//
//  ADLHotelOrderTableViewCell.h
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLHotelOrderTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)title:(NSString *)title placeholder:(NSString *)placeholder titleField:(NSString *)titleField;
@property(nonatomic ,strong)UIButton *phoneCode;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic ,strong)UILabel *iocn;
@property (nonatomic ,copy)void (^titleFieldBlock)(UITextField *title);
@end

NS_ASSUME_NONNULL_END
