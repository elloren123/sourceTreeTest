//
//  ADLActivityGoodsCell.m
//  lockboss
//
//  Created by adel on 2019/5/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLActivityGoodsCell.h"

@implementation ADLActivityGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carBtn.layer.cornerRadius = 4;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        self.descLab.font = [UIFont systemFontOfSize:11];
        self.titLab.font = [UIFont systemFontOfSize:13];
        self.moneyLab.font = [UIFont systemFontOfSize:13];
        self.fullMoneyLab.font = [UIFont systemFontOfSize:10];
    }
}

- (IBAction)clickShoppingCarBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShoppingCarBtn:)]) {
        [self.delegate didClickShoppingCarBtn:sender];
    }
}

@end
