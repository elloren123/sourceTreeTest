//
//  ADLGatewayAddDetailLeftCell.m
//  lockboss
//
//  Created by adel on 2019/10/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLGatewayAddDetailLeftCell.h"

@interface  ADLGatewayAddDetailLeftCell()

@end

static NSString * ADLGatewayAddDetailLeftCellIdentifier = @"ADLGatewayAddDetailLeftCellIdentifier";

@implementation ADLGatewayAddDetailLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ADLGatewayAddDetailLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:ADLGatewayAddDetailLeftCellIdentifier];
    if (cell == nil) {
        cell = [[ADLGatewayAddDetailLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADLGatewayAddDetailLeftCellIdentifier];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubVeiws];
    }
    return self;
}

-(void)setSubVeiws {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titLab];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

-(UILabel *)titLab {
    if (!_titLab) {
        _titLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titLab.font = [UIFont boldSystemFontOfSize:14];
        _titLab.textAlignment = NSTextAlignmentCenter;
        _titLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titLab.text = @"储物箱";//TODO
    }
    return _titLab;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected ;
    if (_isSelected) {
        _titLab.textColor = [UIColor colorWithRed:218/255.0 green:47/255.0 blue:45/255.0 alpha:1.0];
    }else {
        _titLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
}

@end
