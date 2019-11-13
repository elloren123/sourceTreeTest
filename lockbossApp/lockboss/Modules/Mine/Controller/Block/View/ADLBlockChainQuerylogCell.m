//
//  ADLBlockChainQuerylogCell.m
//  ADEL-APP
//
//  Created by adel on 2019/8/29.
//ADLBlockchainLockModel.h

#import "ADLBlockChainQuerylogCell.h"
#import "ADLBlockchainLockModel.h"


@interface ADLBlockChainQuerylogCell ()

@property (nonatomic, strong) UIImageView *backImage;

@property (nonatomic, strong) UILabel *account;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *phoneType;

@end

@implementation ADLBlockChainQuerylogCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"BlockChainQuerylogCell";
    ADLBlockChainQuerylogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ADLBlockChainQuerylogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
//        [self.backImage addSubview:self.phoneType];
        [self.backImage addSubview:self.account];
        [self.backImage addSubview:self.dateLabel];
        
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
    [self.lockName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.number.mas_right).offset(15);
        make.top.mas_equalTo(ws.backImage.mas_top).offset(14);
        make.height.mas_equalTo(@16);
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-5);
    }];
    
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.number.mas_right).offset(15);
        make.top.mas_equalTo(ws.lockName.mas_bottom).offset(9);
        make.height.mas_equalTo(@12);
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-5);
    }];
    
    


    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.number.mas_right).offset(15);
        make.top.mas_equalTo(ws.account.mas_bottom).offset(9);
        make.height.mas_equalTo(@12);
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-5);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.number.mas_right).offset(15);
        make.top.mas_equalTo(ws.timeLabel.mas_bottom).offset(9);
        make.height.mas_equalTo(@12);
        make.right.mas_equalTo(ws.backImage.mas_right).offset(-5);
    }];
    
    
    
//    [self.phoneType mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(ws.number.mas_right).offset(15);
//        make.bottom.mas_equalTo(ws.backImage.mas_bottom).offset(-14);
//        make.height.mas_equalTo(@12);
//        make.right.mas_equalTo(ws.backImage.mas_right).offset(-5);
//    }];
    
    
    
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
        _number = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:16 text:nil texeColor:COLOR_E0212A];
        //_number.textAlignment = NSTextAlignmentCenter;
    }
    return _number;
}

-(UILabel *)lockName {
    if (!_lockName) {
        _lockName = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:14 text:@"家庭大门" texeColor:COLOR_E0212A];
        // _lockName.textAlignment = NSTextAlignmentLeft;
    }
    return _lockName;
}

-(UILabel *)account {
    if (!_account) {
        _account = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:@"开门成功" texeColor:COLOR_E0212A];
        //_account.textAlignment = NSTextAlignmentRight;
    }
    return _account;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:11 text:@"开门成功" texeColor:COLOR_666666];
    }
    return _timeLabel;
}



-(UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:11 text:@"区块链" texeColor:COLOR_666666];
    }
    return _dateLabel;
}
//-(UILabel *)phoneType {
//    if (!_phoneType) {
//        _phoneType = [UILabel createLabelFrame:CGRectMake(0, 0, 0, 0) font:FontSize10 text:@"区块链" texeColor:Colorf5f5f5];
//    }
//    return _phoneType;
//}
-(void)setModel:(ADLBlockchainLockModel *)model{

         _model = model;

    self.lockName.text =_model.deviceName;
    self.account.text = [NSString stringWithFormat:@"%@:  %@",ADLString(@"查询账号"), _model.userName];
  //  self.phoneType.text =[NSString stringWithFormat:@"%@:  %@",KLocalizableStr(@"查询日期"), _model.addDatetime]; ;
      self.timeLabel.text =[NSString stringWithFormat:@"%@:  %@",ADLString(@"查询时间"),_model.addDatetime];
    self.dateLabel.text =[NSString stringWithFormat:@"%@:  %@",ADLString(@"手机终端"), _model.terminalCn];


}
@end
