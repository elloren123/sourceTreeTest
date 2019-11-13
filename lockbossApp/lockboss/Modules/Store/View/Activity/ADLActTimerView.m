//
//  ADLActTimerView.m
//  lockboss
//
//  Created by adel on 2019/5/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLActTimerView.h"

@implementation ADLActTimerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dayLab.layer.cornerRadius = 3;
    self.hourLab.layer.cornerRadius = 3;
    self.minLab.layer.cornerRadius = 3;
    self.secLab.layer.cornerRadius = 3;
}

@end
