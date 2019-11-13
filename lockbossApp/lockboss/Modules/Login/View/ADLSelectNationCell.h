//
//  ADLSelectNationCell.h
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSelectNationCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellW:(CGFloat)cellW cellH:(CGFloat)cellH;

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UILabel *codeLab;

@property (nonatomic, strong) UILabel *phoneLab;

@end
