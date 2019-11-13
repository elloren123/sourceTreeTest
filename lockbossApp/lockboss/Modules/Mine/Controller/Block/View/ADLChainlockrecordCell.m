//
//  ADLChainlockrecordCell.m
//  ADEL-APP
//
//  Created by adel on 2019/8/28.
//

#import "ADLChainlockrecordCell.h"
#import "ADLBlockchainLockModel.h"


@interface ADLChainlockrecordCell ()

@property (nonatomic, strong) UIImageView *backImage;


@property (nonatomic, strong) UILabel *openlockType;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *openOK;

@property (nonatomic, strong) UILabel *serialNumber;

@property (nonatomic, strong) UIView *lienView;
@end

@implementation ADLChainlockrecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ChainlockrecordCell";
    ADLChainlockrecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ADLChainlockrecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.backgroundColor =  [UIColor clearColor];
        [self.contentView addSubview:self.backImage];
        [self.backImage addSubview:self.number];
        [self.backImage addSubview:self.lockName];
        [self.backImage addSubview:self.timeLabel];
          [self.backImage addSubview:self.openlockType];
          [self.backImage addSubview:self.openOK];
          [self.backImage addSubview:self.serialNumber];
     
     
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    WS(ws);
    
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(0);
        make.right.mas_equalTo(ws.mas_right).offset(0);
        make.top.mas_equalTo(ws.mas_top).offset(0);
        make.bottom.mas_equalTo(ws.mas_bottom).offset(0);
    }];
    
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.backImage.mas_left).offset(10);
        make.top.mas_equalTo(ws.backImage.mas_top).offset(10);
        make.bottom.mas_equalTo(ws.backImage.mas_bottom).offset(-10);
        make.width.mas_equalTo(@(30));
    }];
    
    [self.openOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.backImage.mas_top).offset(14);
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@(90));
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-10);
    }];
    
    
    [self.lockName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.number.mas_right).offset(5);
        make.top.mas_equalTo(ws.backImage.mas_top).offset(14);
        make.height.mas_equalTo(@14);
        make.right.mas_equalTo(ws.openOK.mas_left).offset(-5);
    }];
    
    [self.openlockType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.lockName.mas_left);
        make.top.mas_equalTo(ws.lockName.mas_bottom).offset(10);
        make.height.mas_equalTo(@12);
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-5);
    }];
  
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.lockName.mas_left);
        make.bottom.mas_equalTo(ws.backImage.mas_bottom).offset(-20);
        make.height.mas_equalTo(@10);
        make.right.mas_equalTo(ws.openOK.mas_left).offset(-5);
    }];
    
    [self.serialNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.timeLabel.mas_top).offset(-10);
        make.left.mas_equalTo(ws.lockName.mas_left);
        make.height.mas_equalTo(@30);
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-10);
    }];
    

    
}
-(UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc]init];
        _backImage.image = [UIImage imageNamed:@"bg_other_lock"];
        //_backImage.backgroundColor = [UIColor yellowColor];
    }
    return _backImage;
}
-(UILabel *)number {
    if (!_number) {
        _number = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:16 text:nil texeColor:COLOR_333333];
        _number.textAlignment = NSTextAlignmentCenter;
    }
    return _number;
}

-(UILabel *)lockName {
    if (!_lockName) {
        _lockName = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:14 text:@"家庭大门" texeColor:COLOR_666666];
       // _lockName.textAlignment = NSTextAlignmentLeft;
    }
    return _lockName;
}

-(UILabel *)openOK {
    if (!_openOK) {
        _openOK = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"开门成功" texeColor:COLOR_666666];
        _openOK.textAlignment = NSTextAlignmentRight;
    }
    return _openOK;
}
-(UILabel *)openlockType {
    if (!_openlockType) {
        _openlockType = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:11 text:@"开门成功" texeColor:COLOR_666666];
    }
    return _openlockType;
}


-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"开门成功" texeColor:COLOR_666666];
    }
    return _timeLabel;
}

-(UILabel *)serialNumber {
    if (!_serialNumber) {
        _serialNumber = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:11 text:@"区块链" texeColor:COLOR_666666];
        _serialNumber.numberOfLines = 0;
    }
    return _serialNumber;
}
-(void)setModel:(ADLBlockchainLockModel *)model {
    _model = model;
    self.openlockType.text = [NSString stringWithFormat:@"开锁人:%@  开锁方式:%@",_model.userName,[_model openType:_model.openType]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %@",ADLString(@"开锁时间"),[self dateTime:_model.openDatetime]];
  //  self.serialNumber.text = [NSString stringWithFormat:@"%@:%@",ADLString(@"区块链编号"),_model.block];
    self.serialNumber.text = _model.block;
    [self.serialNumber sizeToFit];
    if ([_model.result isEqualToString:@"1"]) {
        //1 开门类型255:无 1:前室外 2:后室内 3:前室外（常开）  4:钥匙",
        if ([_model.openWay isEqualToString:@"0"]) {
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"未知"),ADLString(@"开门成功")];
        }else
        if ([_model.openWay isEqualToString:@"1"]) {
          self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"室外"),ADLString(@"开门成功")];
        }else  if ([_model.openWay isEqualToString:@"2"]){
          self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"室内"),ADLString(@"开门成功")];
        }else  if ([_model.openWay isEqualToString:@"3"]){
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"室外"),ADLString(@"常开成功")];
        }else  if ([_model.openWay isEqualToString:@"4"]){
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"钥匙"),ADLString(@"开门成功")];
        }
        
       
    }else {
        if ([_model.openWay isEqualToString:@"0"]) {
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"未知"),ADLString(@"开门失败")];
        }else
        if ([_model.openWay isEqualToString:@"1"]) {
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"室外"),ADLString(@"开门失败")];
        }else  if ([_model.openWay isEqualToString:@"2"]){
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"室内"),ADLString(@"开门失败")];
        }else  if ([_model.openWay isEqualToString:@"3"]){
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"室外"),ADLString(@"常开失败")];
        }else  if ([_model.openWay isEqualToString:@"4"]){
            self.openOK.text = [NSString stringWithFormat:@"%@%@",ADLString(@"钥匙"),ADLString(@"开门失败")];
        }
        
    }

   
    
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
