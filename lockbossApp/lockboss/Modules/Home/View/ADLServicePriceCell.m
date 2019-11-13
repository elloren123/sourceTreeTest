//
//  ADLServicePriceCell.m
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServicePriceCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLServicePriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellH:(CGFloat)cellH {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 0.5)];
        topLine.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:topLine];
        self.topLine = topLine;
        
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 0.5, cellH)];
        leftLine.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:leftLine];
        
        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, 0, 0.5, cellH)];
        centerLine.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:centerLine];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-12, 0, 0.5, cellH)];
        rightLine.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:rightLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(12, cellH-0.5, SCREEN_WIDTH-24, 0.5)];
        bottomLine.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:bottomLine];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH*0.5-29, cellH-2)];
        titLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        titLab.textAlignment = NSTextAlignmentRight;
        titLab.numberOfLines = 2;
        titLab.textColor = COLOR_333333;
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5+14, 1, SCREEN_WIDTH*0.5-40, cellH-2)];
        priceLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        priceLab.textAlignment = NSTextAlignmentCenter;
        priceLab.textColor = COLOR_333333;
        [self.contentView addSubview:priceLab];
        self.priceLab = priceLab;
    }
    return self;
}

@end
