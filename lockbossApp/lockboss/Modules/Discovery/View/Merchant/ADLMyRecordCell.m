//
//  ADLMyRecordCell.m
//  lockboss
//
//  Created by adel on 2019/6/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMyRecordCell.h"

@implementation ADLMyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.actionBtn.layer.cornerRadius = 3;
}

- (IBAction)clickActionBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickActionBtn:)]) {
        [self.delegate didClickActionBtn:sender];
    }
}

@end
