//
//  ADLFAuthDeviceCell.m
//  lockboss
//
//  Created by Adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFAuthDeviceCell.h"
#import "ADLSwitch.h"

@implementation ADLFAuthDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editBtn.layer.cornerRadius = 13;
    self.plab.text = ADLString(@"lock_permit");
    [self.editBtn setTitle:ADLString(@"edit_time") forState:UIControlStateNormal];
    
    ADLSwitch *pswitch = [[ADLSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-52, 81, 40, 24)];
    [pswitch addTarget:self action:@selector(clickSwitch:)];
    [self.contentView addSubview:pswitch];
    self.pswitch = pswitch;
}

- (void)clickSwitch:(ADLSwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSwitch:)]) {
        [self.delegate didClickSwitch:sender];
    }
}

- (IBAction)clickEditTimeBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickModifyTimeBtn:)]) {
        [self.delegate didClickModifyTimeBtn:sender];
    }
}

@end
