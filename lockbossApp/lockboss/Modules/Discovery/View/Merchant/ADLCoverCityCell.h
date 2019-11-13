//
//  ADLCoverCityCell.h
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLCoverCityCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellH:(CGFloat)cellH;

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UIImageView *satisfyImgView;

@end

