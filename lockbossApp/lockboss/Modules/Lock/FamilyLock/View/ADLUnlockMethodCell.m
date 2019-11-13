//
//  ADLUnlockMethodCell.m
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLUnlockMethodCell.h"

@implementation ADLUnlockMethodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *remarkLab = [[UILabel alloc] init];
        remarkLab.font = [UIFont systemFontOfSize:13];
        remarkLab.textColor = COLOR_333333;
        [self.contentView addSubview:remarkLab];
        self.remarkLab = remarkLab;
        
        UILabel *startLab = [[UILabel alloc] init];
        startLab.font = [UIFont systemFontOfSize:12];
        startLab.textColor = COLOR_0AAA00;
        [self.contentView addSubview:startLab];
        self.startLab = startLab;
        
        UILabel *endLab = [[UILabel alloc] init];
        endLab.font = [UIFont systemFontOfSize:12];
        endLab.textAlignment = NSTextAlignmentRight;
        endLab.textColor = COLOR_0AAA00;
        [self.contentView addSubview:endLab];
        self.endLab = endLab;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
        self.spView = spView;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat hei = self.frame.size.height;
    self.endLab.frame = CGRectMake(SCREEN_WIDTH-127, 0, 115, hei);
    self.spView.frame = CGRectMake(12, hei-0.5, SCREEN_WIDTH-12, 0.5);
    self.startLab.frame = CGRectMake(SCREEN_WIDTH-122-20-110, 0, 115, hei);
    self.remarkLab.frame = CGRectMake(12, 0, SCREEN_WIDTH-122-110-20-32, hei);
}

@end
