//
//  ADLMsgSettingCell.h
//  lockboss
//
//  Created by adel on 2019/4/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLMsgSettingCell;

@protocol ADLMsgSettingCellDelegate <NSObject>

- (void)switchValueChanged:(UISwitch *)sender cell:(ADLMsgSettingCell *)cell;

@end

@interface ADLMsgSettingCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UISwitch *swc;

@property (nonatomic, strong) UIView *spView;

@property (nonatomic, weak) id<ADLMsgSettingCellDelegate> delegate;

@end
