//
//  ADLOrderAddressView.m
//  lockboss
//
//  Created by adel on 2019/5/22.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderAddressView.h"

@implementation ADLOrderAddressView

- (IBAction)clickAddressBtn:(UIButton *)sender {
    if (self.clickAddress) {
        if (self.addBtn.titleLabel.text.length == 1) {
            self.clickAddress(NO);
        } else {
            self.clickAddress(YES);
        }
    }
}

@end
