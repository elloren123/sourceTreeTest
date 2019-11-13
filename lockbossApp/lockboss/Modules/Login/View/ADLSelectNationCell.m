//
//  ADLSelectNationCell.m
//  lockboss
//
//  Created by adel on 2019/7/3.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectNationCell.h"

@implementation ADLSelectNationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellW:(CGFloat)cellW cellH:(CGFloat)cellH {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cellW-136, cellH)];
        titLab.font = [UIFont systemFontOfSize:14];
        titLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.contentView addSubview:titLab];
        self.titLab = titLab;
        
        UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake(cellW-112, 0, 50, cellH)];
        codeLab.font = [UIFont systemFontOfSize:14];
        codeLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:codeLab];
        self.codeLab = codeLab;
        
        UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(cellW-60, 0, 50, cellH)];
        phoneLab.font = [UIFont systemFontOfSize:14];
        phoneLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:phoneLab];
        self.phoneLab = phoneLab;
    }
    return self;
}

@end
