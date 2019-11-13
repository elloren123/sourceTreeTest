//
//  ADLOrderDinnerCell.h
//  lockboss
//
//  Created by bailun91 on 2019/9/5.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLOrderDinnerCell : UITableViewCell 

@property (nonatomic, strong) UIImageView   *iconImg;   //店铺icon
@property (nonatomic, strong) UILabel       *shopName;  //店铺名
@property (nonatomic, strong) UIImageView   *starImg1;
@property (nonatomic, strong) UIImageView   *starImg2;
@property (nonatomic, strong) UIImageView   *starImg3;
@property (nonatomic, strong) UIImageView   *starImg4;
@property (nonatomic, strong) UIImageView   *starImg5;
@property (nonatomic, strong) UILabel       *renQiLbl;  //人气label
@property (nonatomic, strong) UILabel       *juLiLbl;   //距离label
@property (nonatomic, strong) UILabel       *workLbl;   //营业时间label

@end

NS_ASSUME_NONNULL_END
