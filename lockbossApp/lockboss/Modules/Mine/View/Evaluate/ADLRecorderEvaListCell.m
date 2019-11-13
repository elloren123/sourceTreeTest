//
//  ADLRecorderEvaListCell.m
//  lockboss
//
//  Created by adel on 2019/6/25.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLRecorderEvaListCell.h"

@implementation ADLRecorderEvaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailBtn.layer.cornerRadius = 4;
    self.detailBtn.layer.borderWidth = 0.5;
    self.detailBtn.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1].CGColor;
    
    self.evaluateBtn.layer.cornerRadius = 4;
    self.evaluateBtn.layer.borderWidth = 0.5;
    self.evaluateBtn.layer.borderColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1].CGColor;
}

- (IBAction)clickLookRecorderDetailBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRecorderDetailBtn:)]) {
        [self.delegate didClickRecorderDetailBtn:sender];
    }
}

- (IBAction)clickRecorderEvaluateBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRecorderEvaluateBtn:)]) {
        [self.delegate didClickRecorderEvaluateBtn:sender];
    }
}

@end
