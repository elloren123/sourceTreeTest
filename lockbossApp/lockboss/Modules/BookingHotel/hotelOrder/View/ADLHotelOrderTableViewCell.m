//
//  ADLHotelOrderTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelOrderTableViewCell.h"
#import "ADLSelectNationView.h"

@interface ADLHotelOrderTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;


@property (nonatomic, strong) UIView *line;


@end

@implementation ADLHotelOrderTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.phoneCode];
        [self.contentView addSubview:self.iocn];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"HotelListTableViewCell";
    ADLHotelOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[ADLHotelOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
    }
    
    return cell;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);

    [self.iocn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(14);;
        make.top.mas_equalTo(ws.mas_top).offset(15);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(12);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(20);;
        make.top.mas_equalTo(ws.mas_top).offset(0);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.phoneCode.mas_right).offset(10);
        make.top.mas_equalTo(ws.mas_top).offset(0);
        make.right.mas_equalTo(@(-54));
        make.bottom.mas_equalTo(0);
    }];
    
    //线条
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.mas_bottom);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.height.mas_equalTo(0.5);
    }];
    
}
-(UIButton *)phoneCode {
    if (!_phoneCode) {
        _phoneCode = [self createButtonFrame:CGRectMake(80, 0, 0, 0) imageName:@"xiaojiantou_below" title:@" +86 " titleColor:COLOR_333333 font:12 target:self action:@selector(changedaddbtn:)];
      [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_phoneCode imageTitleSpace:20];
        //_phoneCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      // _phoneCode.backgroundColor = [UIColor yellowColor];
    }
    return _phoneCode;
}

-(UILabel *)iocn {
    if (!_iocn) {
        _iocn = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:@"*" texeColor:COLOR_E0212A];
    }
    return _iocn;
}
-(void)changedaddbtn:(UIButton *)btn {
    
//    [ADLSelectNationView showWithFrame:CGRectMake(29, VIEW_HEIGHT+NAVIGATION_H+36, SCREEN_WIDTH-58, SCREEN_HEIGHT-NAVIGATION_H-VIEW_HEIGHT-BOTTOM_H-60) finish:^(NSDictionary *dict) {
//        // self.pwdTF.secureTextEntry = YES;
//        if (dict) {
//            [self.phoneCode setTitle:dict[@"code"] forState:UIControlStateNormal];
//        // self.phoneCode.titleLabel.text = dict[@"code"];
//            //            self.nationName = dict[[ADLLocalizedHelper helper].currentLanguage];
//            //            CGFloat titW = [ADLUtils calculateString:dict[@"code"] rectSize:CGSizeMake(70, VIEW_HEIGHT) fontSize:13].width+15;
//            //            self.areaLab.frame = CGRectMake(36-titW/2, 0, titW-13, VIEW_HEIGHT);
//            //            self.areaImgView.frame = CGRectMake(24+titW/2, (VIEW_HEIGHT-3)/2, 9, 5);
//        }
//        [UIView animateWithDuration:0.3 animations:^{
//            //            self.areaImgView.transform = CGAffineTransformIdentity;
//        }];
//    }];
    
    [ADLSelectNationView showWithFinish:^(NSDictionary *dict) {
                // self.pwdTF.secureTextEntry = YES;
                if (dict) {
                    [self.phoneCode setTitle:dict[@"code"] forState:UIControlStateNormal];
                // self.phoneCode.titleLabel.text = dict[@"code"];
                    //            self.nationName = dict[[ADLLocalizedHelper helper].currentLanguage];
                    //            CGFloat titW = [ADLUtils calculateString:dict[@"code"] rectSize:CGSizeMake(70, VIEW_HEIGHT) fontSize:13].width+15;
                    //            self.areaLab.frame = CGRectMake(36-titW/2, 0, titW-13, VIEW_HEIGHT);
                    //            self.areaImgView.frame = CGRectMake(24+titW/2, (VIEW_HEIGHT-3)/2, 9, 5);
                }
                [UIView animateWithDuration:0.3 animations:^{
                    //            self.areaImgView.transform = CGAffineTransformIdentity;
                }];
    }];
}


-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"房间数量") texeColor:COLOR_333333];
    }
    return _nameLabel;
}

-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
      //  _textField.backgroundColor = [UIColor yellowColor];
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.textColor = COLOR_333333;
        //设置输入框不能编辑
        [_textField setEnabled:YES];
    [_textField addTarget:self action:@selector(titleFieldTarget:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(void)titleFieldTarget:(UITextField *)textField{
    if (self.titleFieldBlock) {
        self.titleFieldBlock(textField);
    }
}
-(UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = COLOR_CCCCCC;
    }
    return _line;
}
-(void)title:(NSString *)title placeholder:(NSString *)placeholder titleField:(NSString *)titleField{
    
    self.nameLabel.text = title;
    self.textField.placeholder = placeholder;
    self.textField.text = titleField;
}
@end
