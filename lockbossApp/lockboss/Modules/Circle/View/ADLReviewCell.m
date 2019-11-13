//
//  ADLReviewCell.m
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLReviewCell.h"

@implementation ADLReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = 6;
    self.agreeBtn.layer.cornerRadius = 2;
    self.ignoreBtn.layer.cornerRadius = 2;
    self.agreeBtn.layer.borderWidth = 0.5;
    self.ignoreBtn.layer.borderWidth = 0.5;
    self.agreeBtn.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1].CGColor;
    self.ignoreBtn.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickImageView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageView:)]) {
        [self.delegate didClickImageView:(UIImageView *)tap.view];
    }
}

- (IBAction)clickAgreeBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAgreeBtn:)]) {
        [self.delegate didClickAgreeBtn:sender];
    }
}

- (IBAction)clickIgnoreBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickIgnoreBtn:)]) {
        [self.delegate didClickIgnoreBtn:sender];
    }
}

@end
