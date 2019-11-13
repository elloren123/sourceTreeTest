//
//  ADLMsgSettingCell.m
//  lockboss
//
//  Created by adel on 2019/4/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMsgSettingCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLMsgSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titleLab.textColor = COLOR_333333;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        
        UISwitch *swc = [[UISwitch alloc] init];
        [swc addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:swc];
        self.swc = swc;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
        self.spView = spView;
    }
    return self;
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchValueChanged:cell:)]) {
        [self.delegate switchValueChanged:sender cell:self];
    }
}

- (void)layoutSubviews {
    CGFloat hei = self.frame.size.height;
    self.titleLab.frame = CGRectMake(12, 0, SCREEN_WIDTH-80, hei);
    self.swc.frame = CGRectMake(SCREEN_WIDTH-59, (hei-31)/2, 47, 31);
    self.spView.frame = CGRectMake(12, hei-0.5, SCREEN_WIDTH-12, 0.5);
}

@end
