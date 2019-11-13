//
//  ADLAddServiceCell.m
//  lockboss
//
//  Created by Han on 2019/6/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLAddServiceCell.h"

@implementation ADLAddServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickAddCountBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddBtn:count:)]) {
        [self.delegate didClickAddBtn:sender count:[self.countLab.text integerValue]];
    }
}

- (IBAction)clickReduceCountBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReduceBtn:count:)]) {
        [self.delegate didClickReduceBtn:sender count:[self.countLab.text integerValue]];
    }
}

- (IBAction)clickMarkBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMarkBtn:)]) {
        [self.delegate didClickMarkBtn:sender];
    }
}

@end
