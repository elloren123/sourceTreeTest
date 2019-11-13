//
//  ADLCoverCityCell.m
//  lockboss
//
//  Created by Han on 2019/6/9.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCoverCityCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLCoverCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellH:(CGFloat)cellH {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, SCREEN_WIDTH-24, 19)];
        titLab.font = [UIFont systemFontOfSize:15];
        titLab.textColor = COLOR_333333;
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 33, SCREEN_WIDTH-24, 23)];
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = COLOR_333333;
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *satisfyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, cellH-28, SCREEN_WIDTH-24, 19)];
        satisfyLab.text = @"客户满意度：";
        satisfyLab.font = [UIFont systemFontOfSize:15];
        satisfyLab.textColor = COLOR_333333;
        [self.contentView addSubview:satisfyLab];
        
        UIImageView *satisfyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(105, cellH-28, 100, 19)];
        satisfyImgView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:satisfyImgView];
        self.satisfyImgView = satisfyImgView;
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(12, cellH-0.5, SCREEN_WIDTH-12, 0.5)];
        spView.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:spView];
    }
    return self;
}

@end
