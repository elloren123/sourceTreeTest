//
//  ADLNewUserCell.m
//  lockboss
//
//  Created by adel on 2019/5/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLNewUserCell.h"

@implementation ADLNewUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.useBtn.layer.cornerRadius = 12;
}

- (IBAction)clickLingQuBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLingQuBtn:)]) {
        [self.delegate didClickLingQuBtn:sender];
    }
}

@end
