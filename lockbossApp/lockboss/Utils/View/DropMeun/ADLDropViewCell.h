//
//  ADLDropViewCell.h
//  lockboss
//
//  Created by adel on 2019/8/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLDropViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIView *spView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier image:(BOOL)image lightMode:(BOOL)lightMode;

@end
