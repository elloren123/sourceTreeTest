//
//  ADLSelectServiceCell.m
//  lockboss
//
//  Created by adel on 2019/6/17.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectServiceCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLSelectServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellH:(CGFloat)cellH {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, cellH-16, cellH-16)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imgView];
        imgView.clipsToBounds = YES;
        self.imgView = imgView;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(cellH+6, 15, SCREEN_WIDTH-cellH-16, 20)];
        nameLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        nameLab.textColor = COLOR_333333;
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(cellH+6, cellH-35, SCREEN_WIDTH-cellH-16, 20)];
        priceLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        priceLab.textColor = APP_COLOR;
        [self.contentView addSubview:priceLab];
        self.priceLab = priceLab;
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(cellH+6, cellH-0.5, SCREEN_WIDTH-12, 0.5)];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
    }
    return self;
}

@end
