//
//  ADLAfterSaleListCell.m
//  lockboss
//
//  Created by adel on 2019/6/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAfterSaleListCell.h"
#import "ADLImagePreView.h"

@implementation ADLAfterSaleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.applyBtn.layer.cornerRadius = 4;
    self.applyBtn.layer.borderWidth = 0.5;
    self.applyBtn.layer.borderColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGoodsImageView)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)clickGoodsImageView {
    if (self.imgUrl) {
        [ADLImagePreView showWithImageViews:@[self.imgView] urlArray:@[self.imgUrl] currentIndex:0];
    }
}

- (IBAction)clickApplyAfterSaleBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickApplyAfterSaleBtn:)]) {
        [self.delegate didClickApplyAfterSaleBtn:sender];
    }
}

@end
