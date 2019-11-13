//
//  ADLguestRoomsCell.m
//  ADEL-APP
//
//  Created by bailun91 on 2018/6/14.
//

#import "ADLguestRoomsCell.h"
#import "ADLGuestRoomsModel.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>

@interface ADLguestRoomsCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UILabel *typname;
@property (nonatomic, strong) UILabel *startdate;
@property (nonatomic, strong) UILabel *endTime;
//@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *addressBtn;
@end



@implementation ADLguestRoomsCell




+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"guestRoomsCell";
    ADLguestRoomsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ADLguestRoomsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
           self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView  addSubview:self.typname];
        [self.contentView  addSubview:self.phoneBtn];
        [self.contentView  addSubview:self.startdate];
//        [self.contentView  addSubview:self.addressLabel];
        [self.contentView  addSubview:self.endTime];
        [self.contentView  addSubview:self.addressBtn];
       
       
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = 5;
    frame.size.width -= 10;
   [super setFrame:frame];
   
}


-(UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 100, 120)];
    }
    return _headImage;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _nameLabel.textColor = COLOR_333333;
//        [UILabel createLabelFrame:CGRectMake(0, 0, 0, 0) font:FontSize14 text:@"张先森" texeColor:Color333333];
         _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    return _nameLabel;
}
-(UIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.frame = CGRectMake(0, 0, 0, 0);
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_phoneBtn addTarget:self action:@selector(addressBtn:) forControlEvents:UIControlEventTouchUpInside];
        _phoneBtn.tag = 1;
        [_phoneBtn setImage:[UIImage imageNamed:@"icon_room_phone"] forState:UIControlStateNormal];
    }
    return _phoneBtn;
}


-(UILabel *)typname {
    
    if (!_typname) {
        _typname = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _typname.textColor = COLOR_333333;
        _typname.font = [UIFont systemFontOfSize:12];
        _typname.text = @"豪华大床房";
//        [UILabel createLabelFrame:CGRectMake(0, 0, 0, 0) font:FontSize12 text:@"豪华大床房" texeColor:Color333333];
    }
    return _typname;
}
-(UILabel *)startdate {
    if (!_startdate) {
        _startdate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _startdate.textColor = COLOR_333333;
        _startdate.font = [UIFont systemFontOfSize:12];
    }
    return _startdate;
}

-(UILabel *)endTime {
    if (!_endTime) {
        _endTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _endTime.textColor = COLOR_333333;
        _endTime.font = [UIFont systemFontOfSize:12];
    }
    return _endTime;
}

-(UIButton *)addressBtn {
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBtn setTitle:@"" forState:UIControlStateNormal];
        [_addressBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addressBtn addTarget:self action:@selector(addressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_addressBtn setImage:[UIImage imageNamed:@"icon_room_address"] forState:UIControlStateNormal];
        [self.contentView layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft createButton:_addressBtn imageTitleSpace:2];
        _addressBtn.tag = 2;
    }
    return _addressBtn;
}

-(void)addressBtn:(UIButton *)btn {
    if (self.addressBlack) {
        self.addressBlack(btn);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.headImage.mas_right).offset(12);
        make.right.mas_offset(-(48));
        make.top.mas_equalTo(@15);
        make.height.mas_equalTo(@16);
    }];

    
    [self.typname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.headImage.mas_right).offset(12);
        make.right.mas_offset(-(48));
        make.top.mas_equalTo(ws.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@14);
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(12));
        make.top.mas_equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.startdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.typname);
        make.top.mas_equalTo(ws.typname.mas_bottom).offset(10);
        make.right.mas_equalTo(@(-12));
        make.height.mas_equalTo(@17);
    }];
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.typname);
        make.right.mas_equalTo(@(-12));
        make.height.mas_equalTo(@12);
        make.top.mas_equalTo(ws.startdate.mas_bottom).offset(10);
    }];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.endTime.mas_bottom).offset(6);
        make.left.mas_equalTo(ws.typname);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
 
    
}

- (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(9, 2)];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(13, 2)];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(15, 2)];
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
    theLab.attributedText = strAtt;
}


-(void)setModel:(ADLGuestRoomsModel *)model {
      _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.url]] placeholderImage:[UIImage imageNamed:@"bg_adelHotel"]];
    
    self.nameLabel.text = _model.name;
     self.typname.text = [NSString stringWithFormat:@"%@: %@",@"房号",_model.roomName];
    
    self.phoneBtn.titleLabel.text = _model.customerServicePhone;
    self.startdate.text = [NSString stringWithFormat:@"%@: %@",@"入住时间",[self dateTime:_model.startDatetime]];
    self.endTime.text = [NSString stringWithFormat:@"%@: %@",@"离开时间",[self dateTime:_model.endDatetime]];
    NSString *addressString = [_model.adress stringByReplacingOccurrencesOfString:@"|" withString:@""];
    [self.addressBtn setTitle:addressString forState:UIControlStateNormal];
//    self.addressLabel.text = [NSString stringWithFormat:@"%@: %@",@"酒店地址",[_model.adress stringByReplacingOccurrencesOfString:@"|" withString:@""]];
    
   
}
- (NSString *)dateTime:(NSString *)time {
    NSTimeInterval interval    =[time doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
}


@end
