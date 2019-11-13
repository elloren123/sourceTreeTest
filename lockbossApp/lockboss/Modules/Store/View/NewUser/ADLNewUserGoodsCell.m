//
//  ADLNewUserGoodsCell.m
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNewUserGoodsCell.h"

@implementation ADLNewUserGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carBtn.layer.cornerRadius = 4;
}

- (IBAction)clickShoppingCarBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShoppingCarBtn:)]) {
        [self.delegate didClickShoppingCarBtn:sender];
    }
}

@end
