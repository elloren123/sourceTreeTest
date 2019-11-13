//
//  ADLCircleDetailHeadView.m
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCircleDetailHeadView.h"

@implementation ADLCircleDetailHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = 6;
    self.actionBtn.layer.cornerRadius = 3;
    self.actionBtn.layer.borderWidth = 0.5;
    self.actionBtn.layer.borderColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickImageView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickGroupImageView:)]) {
        [self.delegate didClickGroupImageView:(UIImageView *)tap.view];
    }
}

- (IBAction)clickActionBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickActionBtn:)]) {
        [self.delegate didClickActionBtn:sender];
    }
}

@end
