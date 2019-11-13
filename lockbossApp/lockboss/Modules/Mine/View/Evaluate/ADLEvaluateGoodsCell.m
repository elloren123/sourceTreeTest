//
//  ADLEvaluateGoodsCell.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEvaluateGoodsCell.h"

@implementation ADLEvaluateGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.evaluateBtn.layer.borderWidth = 0.5;
    self.evaluateBtn.layer.cornerRadius = 4;
}

- (IBAction)clickEvaluateBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEvaluateBtn:)]) {
        [self.delegate didClickEvaluateBtn:sender];
    }
}

@end
