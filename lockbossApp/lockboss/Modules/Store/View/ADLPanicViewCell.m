//
//  ADLPanicViewCell.m
//  lockboss
//
//  Created by adel on 2019/4/24.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLPanicViewCell.h"

@implementation ADLPanicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.panicBtn.layer.cornerRadius = 3;
    self.progressView.layer.cornerRadius = 6;
    self.progressView.layer.borderWidth = 1;
    self.progressView.layer.borderColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1].CGColor;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        self.imgW.constant = 70;
        self.goodsLab.font = [UIFont systemFontOfSize:13];
    }
}

- (IBAction)clickPanicBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPanicPurchaseBtn:cell:)]) {
        [self.delegate clickPanicPurchaseBtn:sender cell:self];
    }
}

@end
