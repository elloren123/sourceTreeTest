//
//  ADLSelectServiceCell.h
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSelectServiceCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellH:(CGFloat)cellH;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *priceLab;

@end
