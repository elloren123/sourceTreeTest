//
//  ADLCircleHomeCell.m
//  lockboss
//
//  Created by Han on 2019/6/1.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCircleHomeCell.h"

@implementation ADLCircleHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLab.layer.cornerRadius = 7;
    self.imgView.layer.cornerRadius = 6;
}

@end
