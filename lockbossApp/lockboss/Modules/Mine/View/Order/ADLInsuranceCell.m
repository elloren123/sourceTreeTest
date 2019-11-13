//
//  ADLInsuranceCell.m
//  lockboss
//
//  Created by adel on 2019/7/10.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLInsuranceCell.h"
#import "ADLGlobalDefine.h"

@implementation ADLInsuranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UILabel *serialLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, SCREEN_WIDTH-24, 20)];
        serialLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        serialLab.textColor = COLOR_333333;
        [self.contentView addSubview:serialLab];
        self.serialLab = serialLab;
        
        UILabel *companyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 48, SCREEN_WIDTH-24, 20)];
        companyLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        companyLab.textColor = COLOR_333333;
        [self.contentView addSubview:companyLab];
        self.companyLab = companyLab;
        
        UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 82, SCREEN_WIDTH-24, 20)];
        moneyLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        moneyLab.textColor = COLOR_333333;
        [self.contentView addSubview:moneyLab];
        self.moneyLab = moneyLab;
        
        UILabel *insuranceLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 116, SCREEN_WIDTH-24, 20)];
        insuranceLab.font = [UIFont systemFontOfSize:FONT_SIZE];
        insuranceLab.textColor = COLOR_333333;
        [self.contentView addSubview:insuranceLab];
        self.insuranceLab = insuranceLab;
        
        UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 8)];
        spView.backgroundColor = COLOR_F2F2F2;
        [self.contentView addSubview:spView];
    }
    return self;
}

@end
