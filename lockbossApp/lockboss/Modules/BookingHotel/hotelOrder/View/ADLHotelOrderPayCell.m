//
//  ADLHotelOrderPayCell.m
//  lockboss
//
//  Created by adel on 2019/10/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderPayCell.h"
#import "ADLSelectNationView.h"
@interface ADLHotelOrderPayCell ()

@property (nonatomic ,strong)UIView *line;
@end
@implementation ADLHotelOrderPayCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.title];
          [self.contentView addSubview:self.iconbtn];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"ADLHotelOrderPayCell";
    ADLHotelOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[ADLHotelOrderPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
    }
    
    return cell;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
  
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(21);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(28);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(@15);
        make.right.mas_equalTo(-100);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(20);
        make.top.mas_equalTo(ws.name.mas_bottom).offset(10);
        make.height.mas_equalTo(@12);
        make.right.mas_equalTo(-20);
    }];
    
    [self.iconbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(ws);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(30);
    }];

    //线条
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-0.5);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.height.mas_equalTo(0.5);
    }];
}
-(UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
      _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        //_iconImage.image = [UIImage imageNamed:@"icon_chanp"];
    }
    return _iconImage;
}
-(UILabel *)name {
    if (!_name) {
        _name = [self createLabelFrame:CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30) font:14 text:ADLString(@"维也纳酒店") texeColor:COLOR_333333];
    }
    return _name;
}

-(UILabel *)title {
    if (!_title) {
        _title = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"不含早") texeColor:COLOR_666666];
    }
    return _title;
}
-(UIButton *)iconbtn {
    if (!_iconbtn) {
        _iconbtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"icon_pay_select_normal" title:nil titleColor:COLOR_666666 font:12 target:self action:@selector(numDateBtn:)];
        [_iconbtn setImage:[UIImage imageNamed:@"queren"] forState:UIControlStateSelected];
        _iconbtn.userInteractionEnabled = NO;
    }
    return _iconbtn;
}
-(UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = COLOR_CCCCCC;
    }
    return _line;
}
-(void)numDateBtn:(UIButton *)btn {

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
