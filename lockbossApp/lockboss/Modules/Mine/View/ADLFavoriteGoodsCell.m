//
//  ADLFavoriteGoodsCell.m
//  lockboss
//
//  Created by Han on 2019/5/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFavoriteGoodsCell.h"

@implementation ADLFavoriteGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carBtn.layer.cornerRadius = 4;
}

- (IBAction)clickShoppingCarBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShoppingCarBtn:)]) {
        [self.delegate didClickShoppingCarBtn:sender];
    }
}

- (IBAction)clickCheckBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckBtn:)]) {
        [self.delegate didClickCheckBtn:sender];
    }
}

@end
