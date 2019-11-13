//
//  ADLReservationServiceCell.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLReservationServiceCell.h"

@implementation ADLReservationServiceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ADLReservationServiceCell";
    ADLReservationServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ADLReservationServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.lockName];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.switchBtn];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    WS(ws);
    
    
    [self.lockName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@14);
        make.width.mas_equalTo(@90);
        make.top.mas_equalTo(ws.mas_top).offset(5);;
        make.bottom.mas_equalTo(ws.mas_bottom);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.lockName.mas_right).offset(14);
        make.top.mas_equalTo(ws.lockName.mas_top);
        make.bottom.mas_equalTo(ws.mas_bottom);
        make.right.mas_equalTo(ws.mas_right).offset(-15);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.lockName.mas_right).offset(14); make.right.mas_equalTo(ws.mas_right).offset(-15);
        make.top.mas_equalTo(ws.mas_top).offset(5);
        make.bottom.mas_equalTo(ws.mas_bottom);
        
    }];
    
}

-(UILabel *)lockName {
    if (!_lockName) {
        _lockName = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:14 text:@"智能门锁" texeColor:COLOR_333333];
        _lockName.textAlignment = NSTextAlignmentLeft;
       // _lockName.backgroundColor = [UIColor yellowColor];
    }
    return _lockName;
}
-(UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:nil titleColor:COLOR_333333 font:12 target:self action:@selector(addbtn:)];
        _switchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _switchBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0,0);
        [_switchBtn setImage:[UIImage imageNamed:@"icon_service_upate"] forState:UIControlStateNormal];
        _switchBtn.enabled = NO;
    }
    return _switchBtn;
}

-(UILabel *)title {
    if (!_title) {
        _title = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"在线在线" texeColor:COLOR_333333];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.numberOfLines = 0;
      // _title.backgroundColor = [UIColor redColor];
    }
    return _title;
}


-(void)addbtn:(UIButton *)btn{
    
}


@end
