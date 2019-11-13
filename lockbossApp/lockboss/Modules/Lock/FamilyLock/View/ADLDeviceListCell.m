//
//  ADLDeviceListCell.m
//  lockboss
//
//  Created by Adel on 2019/9/17.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLDeviceListCell.h"

@implementation ADLDeviceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bindBtn.layer.cornerRadius = 15;
}

- (IBAction)clickBindBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBindingBtn:)]) {
        [self.delegate didClickBindingBtn:sender];
    }
}

@end
