//
//  ADLSingleTextCell.m
//  lockboss
//
//  Created by Han on 2019/6/2.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSingleTextCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLSingleTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titLab = [[UILabel alloc] init];
        titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titLab.textColor = COLOR_333333;
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
        self.spView = spView;
        self.leftMargin = 0;
        self.top = NO;
    }
    return self;
}

- (void)layoutSubviews {
    if (self.top) {
        self.titLab.frame = CGRectMake(12, -3, SCREEN_WIDTH-24, 19);
    } else {
        self.titLab.frame = CGRectMake(12, 0, SCREEN_WIDTH-24, self.frame.size.height);
    }
    if (!self.spView.hidden) {
        self.spView.frame = CGRectMake(self.leftMargin, self.frame.size.height-0.5, SCREEN_WIDTH-self.leftMargin, 0.5);
    }
}

@end
