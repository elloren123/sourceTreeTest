//
//  ADLServiceTableViewCell.h
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ADLHomeServiceModel;
@interface ADLServiceTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UILabel *servicetype;
//服务单号
@property (nonatomic, weak) UILabel *orderLabel;
//留言
@property (nonatomic, strong) UILabel *messageLable;
//驳回
@property (nonatomic, weak) UILabel *refundDes;
//支付状态
@property (nonatomic, strong) UILabel *orderType;

@property (nonatomic, strong) UIButton *reminderBtn;//催单
//取消服务
@property (nonatomic, strong) UIButton *cancelServiceBtn;

//线条
@property (nonatomic, weak) UIView *line;

@property (nonatomic, strong) ADLHomeServiceModel *model;

@property (nonatomic, strong) ADLHomeServiceModel *serviceModel;

@property (nonatomic, copy) void(^serviveBlock)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
