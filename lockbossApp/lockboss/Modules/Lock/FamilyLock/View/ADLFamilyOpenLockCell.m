//
//  ADLFamilyOpenLockCell.m
//  lockboss
//
//  Created by adel on 2019/10/10.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFamilyOpenLockCell.h"

#import "ADLGlobalDefine.h"

#import <UIImageView+WebCache.h>

#import "ADLTimeOrStamp.h"

//#import "ADLLockModel.h"
//#import "ADLDeviceModel.h"
//#import "UIView+Extension.h"
//#import "ADLUtils.h"

@interface ADLFamilyOpenLockCell ()

//@property (nonatomic, strong) UIImageView *backImage;
//
//@property (nonatomic, strong) UIImageView *lockImage;
//
//@property (nonatomic, strong) UILabel *lockName;
//
//@property (nonatomic, strong) UILabel *title;
//
//@property (nonatomic, strong) UIImageView *userImage;
//
//@property (nonatomic, strong) UIButton *replaceBtn;

@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *lockLabel;
@property (nonatomic, strong) UILabel *openWaylab;
@property (nonatomic, strong) UILabel *lockTyp;
@property (nonatomic, strong) UIView *lienView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) UIImageView *icon2;
@property (nonatomic, strong) UIImageView *icon3;
@property (nonatomic, strong) UIImageView *icon4;
@property (nonatomic, strong) UIImageView *icon5;


@end

@implementation ADLFamilyOpenLockCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self addSubview:self.subView];
        [self.subView addSubview:self.headImage];
        [self.subView addSubview:self.nameLabel];
//        [self.subView addSubview:self.lockLabel];
        [self.subView addSubview:self.openWaylab];
        [self.subView addSubview:self.lockTyp];
        [self.subView addSubview:self.lienView];
        [self.subView addSubview:self.timeLabel];
        
        [self.subView addSubview:self.icon1];
        [self.subView addSubview:self.icon2];
        [self.subView addSubview:self.icon3];
        [self.subView addSubview:self.icon4];
        [self.subView addSubview:self.icon5];
        // [self setUpView];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"FamilyOpenLockCell";
    ADLFamilyOpenLockCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    if (cell == nil) {
        cell = [[ADLFamilyOpenLockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
     }
    return cell;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    WS(ws);
    
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12);
        make.right.mas_equalTo(@(-12));
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(@100);
    }];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.subView.mas_left).offset(12);
        make.top.mas_equalTo(ws.subView.mas_top).offset(20);
        make.width.mas_equalTo(@44);
        make.height.mas_equalTo(@44);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.subView.mas_left).offset(0);
        make.top.mas_equalTo(ws.headImage.mas_bottom).offset(10);
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@(68));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.nameLabel.mas_right).offset(20);
        make.right.mas_equalTo(ws.subView.mas_right).offset(-10);
        make.bottom.mas_equalTo(ws.subView.mas_bottom).offset(-20);
        make.height.mas_equalTo(@12);
    }];
    
    [self.lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.headImage.mas_right).offset(16);
        make.top.mas_equalTo(ws.subView.mas_top).offset(27);
        make.bottom.mas_equalTo(ws.subView.mas_bottom).offset(-27);
        make.width.mas_equalTo(@0.5);
    }];
    
    [self.lockTyp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.subView.mas_top).offset(12);
        make.left.mas_equalTo(ws.lienView.mas_right).offset(20);
        make.right.mas_equalTo(ws.subView.mas_right).offset(-10);
        make.height.mas_equalTo(@12);
    }];
    [self.openWaylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.lienView.mas_right).offset(20);
        make.top.mas_equalTo(ws.lockTyp.mas_bottom).offset(14);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@12);
    }];

    [self.icon5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.openWaylab.mas_right).offset(10);
        make.centerY.mas_equalTo(ws.openWaylab.mas_centerY);
        make.height.mas_equalTo(@18);
        make.width.mas_equalTo(@18);
    }];
    [self.icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.icon5.mas_right).offset(10);
        make.centerY.mas_equalTo(ws.openWaylab.mas_centerY);
        make.height.mas_equalTo(@18);
        make.width.mas_equalTo(@18);
        //        if ([ws.model.cardValidation isEqualToString:@"1"]) {
        //        make.width.mas_equalTo(@18);
        //        }else {
        //         make.width.mas_equalTo(@0);
        //        }
    }];
    
    [self.icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.icon4.mas_right).offset(10);
        make.centerY.mas_equalTo(ws.openWaylab.mas_centerY);
        make.height.mas_equalTo(@18);
        make.width.mas_equalTo(@18);
        //        if ([ws.model.phoneValidation isEqualToString:@"1"]) {
        //        make.width.mas_equalTo(@18);
        //        }else {
        //        make.width.mas_equalTo(@0);
        //        }
    }];
    
    [self.icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.icon3.mas_right).offset(10);
        make.centerY.mas_equalTo(ws.openWaylab.mas_centerY);
        make.height.mas_equalTo(@18);
        make.width.mas_equalTo(@18);
        //        if ([ws.model.passwordValidation isEqualToString:@"1"]) {
        //
        //        }else {
        //              make.width.mas_equalTo(@0);
        //        }
    }];
    
    [self.icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.icon2.mas_right).offset(10);
        make.centerY.mas_equalTo(ws.openWaylab.mas_centerY);
        make.height.mas_equalTo(@18);
        make.width.mas_equalTo(@18);
        //        if ([ws.model.fingerprintValidation isEqualToString:@"1"]) {
        //           make.width.mas_equalTo(@18);
        //        }else {
        //            make.width.mas_equalTo(@0);
        //        }
    }];
    
}

-(UIView *)subView {
    if (!_subView) {
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _subView.backgroundColor = [UIColor whiteColor];
        _subView.layer.masksToBounds = YES;
        _subView.layer.cornerRadius = 5;
    }
    return _subView;
}

-(UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.layer.cornerRadius = 22;
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];//CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30)
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor  = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]; //COLOR_E0212A;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;    //中间的内容以……方式省略，显示头尾的文字内容。
    }
    return _nameLabel;
}

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"";
        _timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];//Color999999;
    }
    return _timeLabel;
}
-(UIView *)lienView {
    if (!_lienView) {
        _lienView = [[UIView alloc]init];
        _lienView.backgroundColor = [UIColor grayColor];//Coloraf0f0f0;
    }
    return _lienView;
}
-(UILabel *)lockTyp {
    if (!_lockTyp) {
        _lockTyp = [[UILabel alloc]init];
        _lockTyp.text = @"";
        _lockTyp.font = [UIFont systemFontOfSize:12];
        _lockTyp.textColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:83/255.0 alpha:1.0];//Color999999;
    }
    return _lockTyp;
}

-(UILabel *)openWaylab {
    if (!_openWaylab) {
        _openWaylab = [[UILabel alloc]init];
        _openWaylab.font = [UIFont systemFontOfSize:12];
        _openWaylab.text = @"开锁方式:";
        _openWaylab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];//Color999999;
    }
    return _openWaylab;
}


-(UIImageView *)icon1 {
    if (!_icon1) {
        _icon1 = [[UIImageView alloc]init];
        _icon1.image = [UIImage imageNamed:@"secret_finger_s"];
        _icon1.hidden = YES;
    }
    return _icon1;
}
-(UIImageView *)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc]init];
        _icon2.image = [UIImage imageNamed:@"secret_pwd_s"];
        _icon2.hidden = YES;
    }
    return _icon2;
}

-(UIImageView *)icon3 {
    if (!_icon3) {
        _icon3 = [[UIImageView alloc]init];
        _icon3.image = [UIImage imageNamed:@"secret_phone_s"];
        _icon3.hidden = YES;
    }
    return _icon3;
}

-(UIImageView *)icon4 {
    if (!_icon4) {
        _icon4 = [[UIImageView alloc]init];
        _icon4.image = [UIImage imageNamed:@"secret_card_s"];
        _icon4.hidden = YES;
    }
    return _icon4;
}

-(UIImageView *)icon5 {
    if (!_icon5) {
        _icon5 = [[UIImageView alloc]init];
        _icon5.image = [UIImage imageNamed:@"secret_key_s"];
        _icon5.hidden = YES;
    }
    return _icon5;
}


-(void)setModel:(ADLLockRecordModel *)model {
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.headShot] placeholderImage:[UIImage imageNamed:@"bg_headimg"]];
    
    NSInteger count = [ADLTimeOrStamp timeSwitchTimestamp:[self dateTime:_model.openDatetime] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    self.timeLabel.text = [self distanceTimeWithBeforeTime:(float)count];
    
    //开锁成功/失败，0失败 1成功
    if ([_model.result isEqualToString:@"0"]) {
        self.icon2.hidden = YES;
        self.icon3.hidden = YES;
        self.icon4.hidden = YES;
        self.icon5.hidden = YES;
        self.lockTyp.text = @"失败";
        self.lockTyp.textColor = [UIColor colorWithRed:223/255.0 green:42/255.0 blue:45/255.0 alpha:1.0];//Color999999;

        if (_model.userName.length > 0) {
            self.nameLabel.text = _model.userName;
        }else {
            self.nameLabel.text = @"未知";
        }
    }else {

        self.lockTyp.text = @"成功";
        self.lockTyp.textColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:83/255.0 alpha:1.0];//Color0aaa00;
        if (_model.userName.length > 0) {
            self.nameLabel.text = _model.userName;
        }else {
            self.nameLabel.text = @"未知";
        }
    }

    //指纹验证状态 0 未验证，1验证成功，2验证失败 int  openGroup 0任意 1开启组合
    if ([_model.openGroup isEqualToString:@"0"]) {

        self.icon2.hidden = YES;
        self.icon3.hidden = YES;
        self.icon4.hidden = YES;

        if ([_model.fingerprintValidation isEqualToString:@"1"]) {
            self.icon5.hidden = NO;
            self.icon5.image = [UIImage imageNamed:@"secret_finger_s"];
        }
        if ([_model.cardValidation isEqualToString:@"1"]) {
            self.icon5.hidden = NO;
            self.icon5.image = [UIImage imageNamed:@"secret_card_s"];
        }
        if ([_model.passwordValidation isEqualToString:@"1"]) {
            self.icon5.hidden = NO;
            self.icon5.image = [UIImage imageNamed:@"secret_pwd_s"];
        }
        if ([_model.phoneValidation isEqualToString:@"1"]) {
            self.icon5.hidden = NO;
            self.icon5.image = [UIImage imageNamed:@"secret_phone_s"];
        }

    }else{
        self.icon2.hidden = NO;
        self.icon3.hidden = NO;
        self.icon4.hidden = NO;
        self.icon5.hidden = NO;

        if ([_model.fingerprintValidation isEqualToString:@"1"]) {

            self.icon2.image =[UIImage imageNamed:@"secret_finger_s"];
        }else {
            self.icon2.image = [UIImage imageNamed:@"secret_finger_n"];
        }

        if ([_model.cardValidation isEqualToString:@"1"]) {

            self.icon5.image =[UIImage imageNamed:@"secret_card_s"];
        }else {
            self.icon5.image =[UIImage imageNamed:@"secret_card_n"];
        }
        if ([_model.passwordValidation isEqualToString:@"1"]) {

            self.icon3.image = [UIImage imageNamed:@"secret_pwd_s"];
        }else {
            self.icon3.image = [UIImage imageNamed:@"secret_pwd_n"];
        }
        if ([_model.phoneValidation isEqualToString:@"1"]) {

            self.icon4.image = [UIImage imageNamed:@"secret_phone_s"];
        }else {
            self.icon4.image =[UIImage imageNamed:@"secret_phone_n"];
        }
    }
    
}
//频繁创建date,很不合理 TODO;
- (NSString *)dateTime:(NSString *)time {
    NSTimeInterval interval = [time doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

- (NSString *)distanceTimeWithBeforeTime:(double)beTime {
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [date timeIntervalSince1970];
    
    double distanceTime = now - beTime;
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"HH:mm:ss"];
    
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        
    }
    
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
            
        }
        else{
            
            [df setDateFormat:@"MM-dd HH:mm:ss"];
            
            distanceStr = [df stringFromDate:beDate];
            
        }
        
    }
    
    else if(distanceTime < 24*60*60*365){
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    
    else{
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    
    return distanceStr;
    
}


@end
