//
//  ADLOrderDetailCell.m
//  lockboss
//
//  Created by adel on 2019/7/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderDetailCell.h"

@implementation ADLOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.actionBtn.layer.cornerRadius = 3;
    self.actionBtn.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1].CGColor;
}

- (IBAction)clickActionBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickActionBtn:)]) {
        [self.delegate didClickActionBtn:sender];
    }
}

@end
