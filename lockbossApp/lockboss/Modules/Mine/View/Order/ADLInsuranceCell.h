//
//  ADLInsuranceCell.h
//  lockboss
//
//  Created by adel on 2019/7/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLInsuranceCell : UITableViewCell

///投保订单编号
@property (nonatomic, strong) UILabel *serialLab;

///投保公司
@property (nonatomic, strong) UILabel *companyLab;

///保费金额
@property (nonatomic, strong) UILabel *moneyLab;

///保单号
@property (nonatomic, strong) UILabel *insuranceLab;

@end
