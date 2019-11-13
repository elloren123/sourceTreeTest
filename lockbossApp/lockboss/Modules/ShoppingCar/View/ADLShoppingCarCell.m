//
//  ADLShoppingCarCell.m
//  lockboss
//
//  Created by adel on 2019/5/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLShoppingCarCell.h"

@implementation ADLShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickCheckBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckBtn:)]) {
        [self.delegate didClickCheckBtn:sender];
    }
}

- (IBAction)clickAttributeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAttributeBtn:)]) {
        [self.delegate didClickAttributeBtn:sender];
    }
}

- (IBAction)clickServiceBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickServiceBtn:)]) {
        [self.delegate didClickServiceBtn:sender];
    }
}

- (IBAction)clickAddBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddBtn:count:)]) {
        [self.delegate didClickAddBtn:sender count:[self.numLab.text integerValue]+1];
    }
}

- (IBAction)clickReduceBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReduceBtn:count:)]) {
        [self.delegate didClickReduceBtn:sender count:[self.numLab.text integerValue]-1];
    }
}

@end
