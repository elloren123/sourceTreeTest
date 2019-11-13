//
//  ADLCouponCell.m
//  lockboss
//
//  Created by adel on 2019/5/8.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCouponCell.h"

@implementation ADLCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lingquBtn.layer.cornerRadius = 14;
    self.lingquBtn.layer.borderWidth = 0.5;
}

- (IBAction)clickLingQuBtn:(UIButton *)sender {
    if (!sender.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLingQuBtn:)]) {
            [self.delegate didClickLingQuBtn:sender];
        }
    }
}

@end
