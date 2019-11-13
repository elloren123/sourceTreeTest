//
//  ADLActivityCell.m
//  lockboss
//
//  Created by adel on 2019/5/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLActivityCell.h"

@implementation ADLActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 5;
    self.titLab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

@end
