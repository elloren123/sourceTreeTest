//
//  ADLShipAddressCell.m
//  lockboss
//
//  Created by adel on 2019/4/4.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLShipAddressCell.h"

@implementation ADLShipAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickEditAddressBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEditBtn:)]) {
        [self.delegate didClickEditBtn:self];
    }
}

@end
