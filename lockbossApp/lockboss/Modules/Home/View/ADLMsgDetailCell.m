//
//  ADLMsgDetailCell.m
//  lockboss
//
//  Created by adel on 2019/4/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMsgDetailCell.h"

@implementation ADLMsgDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickCheckBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckBtn:)]) {
        [self.delegate didClickCheckBtn:sender];
    }
}

- (IBAction)clickPullBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPullBtn:)]) {
        [self.delegate didClickPullBtn:self];
    }
}

- (IBAction)clickPullTextBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPullBtn:)]) {
        [self.delegate didClickPullBtn:self];
    }
}

@end
