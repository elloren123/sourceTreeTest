//
//  ADLGoodsParamsCell.m
//  lockboss
//
//  Created by adel on 2019/5/13.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLGoodsSpecCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLGoodsSpecCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titLab = [[UILabel alloc] init];
        titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titLab.textAlignment = NSTextAlignmentRight;
        titLab.numberOfLines = 0;
        titLab.textColor = COLOR_666666;
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
        UILabel *descLab = [[UILabel alloc] init];
        descLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        descLab.textAlignment = NSTextAlignmentCenter;
        descLab.numberOfLines = 0;
        descLab.textColor = COLOR_666666;
        [self.contentView addSubview:descLab];
        self.descLab = descLab;
        
        UIView *spView = [[UIView alloc] init];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
        self.spView = spView;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat hei = self.frame.size.height;
    self.titLab.frame = CGRectMake(12, 0, SCREEN_WIDTH*0.3, hei);
    self.lineView.frame = CGRectMake(SCREEN_WIDTH*0.3+24, 0, 0.5, hei);
    self.descLab.frame = CGRectMake(SCREEN_WIDTH*0.3+36, 0, SCREEN_WIDTH*0.7-48, hei);
    self.spView.frame = CGRectMake(12, hei-0.5, SCREEN_WIDTH-12, 0.5);
}

@end

