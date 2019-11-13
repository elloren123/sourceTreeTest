//
//  ADLSwitchDeviceCell.m
//  lockboss
//
//  Created by Adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSwitchDeviceCell.h"

@implementation ADLSwitchDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.shadowRadius = 3;
    self.shadowView.layer.shadowOpacity = 0.2;
    self.shadowView.layer.shadowOffset = CGSizeZero;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lockBtn.layer.borderColor = [UIColor colorWithRed:218/255.0 green:37/255.0 blue:28/255.0 alpha:1].CGColor;
    self.lockBtn.layer.borderWidth = 0.5;
    self.lockBtn.layer.cornerRadius = 16;
}

- (IBAction)clickLockBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLockBtn:)]) {
        [self.delegate didClickLockBtn:sender];
    }
}

@end
