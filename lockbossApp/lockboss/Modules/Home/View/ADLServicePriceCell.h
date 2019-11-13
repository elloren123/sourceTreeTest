//
//  ADLServicePriceCell.h
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLServicePriceCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellH:(CGFloat)cellH;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UILabel *priceLab;

@end
