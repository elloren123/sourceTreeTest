//
//  ADLCheckInRecordCell.m
//  lockboss
//
//  Created by adel on 2019/8/2.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLCheckInRecordCell.h"

@implementation ADLCheckInRecordCell

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

- (IBAction)clickFeedbackBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFeedbackBtn:)]) {
        [self.delegate didClickFeedbackBtn:sender];
    }
}

- (IBAction)clickPhoneBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPhoneBtn:)]) {
        [self.delegate didClickPhoneBtn:sender.titleLabel.text];
    }
}

@end
