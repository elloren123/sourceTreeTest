//
//  ADLCommetViewCell.h
//  lockboss
//
//  Created by bailun91 on 2019/10/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLNYCommetViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLCommetViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *userHeadImgV;
@property (nonatomic, strong) UILabel       *userNameLab;
@property (nonatomic, strong) UILabel       *cmtDateLab;
@property (nonatomic, strong) UIImageView   *scoreImgV1;
@property (nonatomic, strong) UIImageView   *scoreImgV2;
@property (nonatomic, strong) UIImageView   *scoreImgV3;
@property (nonatomic, strong) UIImageView   *scoreImgV4;
@property (nonatomic, strong) UIImageView   *scoreImgV5;
@property (nonatomic, strong) UILabel       *cmtMsgLab;
@property (nonatomic, strong) UIImageView   *cmtImgV;
@property (nonatomic, strong) UIImageView   *cmtImgV2;
@property (nonatomic, strong) UIImageView   *cmtImgV3;
@property (nonatomic, strong) UILabel       *stoMsgLab;
@property (nonatomic, strong) UIView        *lineV;

- (void)updateSubviewsFrame:(ADLNYCommetViewModel *)model;


@end

NS_ASSUME_NONNULL_END
