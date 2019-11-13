//
//  ADLSubmitOrderCell.m
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSubmitOrderCell.h"

@implementation ADLSubmitOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickImgView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImgView:)]) {
        [self.delegate didClickImgView:(UIImageView *)tap.view];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddBtn:)]) {
        [self.delegate didClickAddBtn:sender];
    }
}

- (IBAction)clickReduceBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReduceBtn:)]) {
        [self.delegate didClickReduceBtn:sender];
    }
}

@end
