//
//  ADLMoneyTextCell.m
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLMoneyTextCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLMoneyTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titLab = [[UILabel alloc] init];
        titLab.font = [UIFont systemFontOfSize:13];
        titLab.textColor = COLOR_333333;
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UILabel *descLab = [[UILabel alloc] init];
        descLab.font = [UIFont boldSystemFontOfSize:13];
        descLab.textAlignment = NSTextAlignmentRight;
        descLab.textColor = COLOR_333333;
        [self.contentView addSubview:descLab];
        self.descLab = descLab;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
        self.spView = spView;
        self.leftMargin = 12;
        self.top = NO;
    }
    return self;
}

- (void)layoutSubviews {
    //不考虑文字重叠
    if (self.top) {
        self.titLab.frame = CGRectMake(12, -2, SCREEN_WIDTH-24, 17);
        self.descLab.frame = CGRectMake(12, -2, SCREEN_WIDTH-24, 17);
    } else {
        self.titLab.frame = CGRectMake(12, 0, SCREEN_WIDTH-24, self.frame.size.height);
        self.descLab.frame = CGRectMake(12, 0, SCREEN_WIDTH-24, self.frame.size.height);
    }
    if (!self.spView.hidden) {
        self.spView.frame = CGRectMake(self.leftMargin, self.frame.size.height-0.5, SCREEN_WIDTH-self.leftMargin, 0.5);
    }
}

@end
