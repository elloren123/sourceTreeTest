//
//  ADLBookingHotelTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/11.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLBookingHotelTableViewCell.h"
#import <Masonry.h>
#import "ADLBookingHotelModel.h"
#import "UIImageView+WebCache.h"
@interface ADLBookingHotelTableViewCell ()
@property (nonatomic, strong) UIImageView  *homeImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *bookingBtn;
@property (nonatomic, strong) UILabel *coentLabel;
@property (nonatomic, strong) UIView  *lienView;

@property (nonatomic ,strong)NSArray *array;

@property (nonatomic, strong) UIButton *btn;
@end

@implementation ADLBookingHotelTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:self.homeImage];
            [self.contentView addSubview:self.nameLabel];
            [self.contentView addSubview:self.scoreView];
            [self.contentView addSubview:self.scoreLabel];
            [self.contentView addSubview:self.messageBtn];
            [self.contentView addSubview:self.addressBtn];
            [self.contentView addSubview:self.priceLabel];
            [self.contentView addSubview:self.bookingBtn];
            [self.contentView addSubview:self.coentLabel];
            [self.contentView addSubview:self.lienView];
       // [self addsubView];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"bookingHotelTableViewCell";
    ADLBookingHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    if (cell == nil) {
        cell = [[ADLBookingHotelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
    }
    
    return cell;
}
- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = 10;
    frame.size.width -= 20;
    [super setFrame:frame];
    
}
-(void)addsubView
{
    int margin = 10;//间隙
    
    int width = 46;//格子的宽
    
    int height = 15;//格子的高
    
    for (int i = 0; i < self.array.count; i++) {
        int row = i/3;
        int col = i%3;
        UIButton * btn = [self createButtonFrame:CGRectMake(140+col*(width+margin), 90+row*(height+margin), width,  height) imageName:nil title:self.array[i] titleColor:COLOR_E0212A font:10 target:self action:@selector(tagbtn:)];
        [btn setImage:[UIImage imageNamed:@"mine_head_bg"] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i;
        self.btn = btn;
    }
    
    
}
-(NSArray *)array {
    if (!_array) {
        _array = @[@"按天",@"按周",@"按月"];
    }
    return _array;
}
-(void)layoutSubviews {
    [super layoutSubviews];

    [self.homeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(@110);
       make.bottom.mas_equalTo(-20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.top.mas_equalTo(self.homeImage.mas_top).offset(5);
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@(120));
    }];
 
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@(60));
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreView.mas_right).offset(5);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@(70));
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self.scoreLabel.mas_top);
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@(80));
    }];
   
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.messageBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(@20);
    }];


    //线条
    [self.lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-90);
        make.bottom.mas_equalTo(self.homeImage.mas_bottom).offset(-5);
        make.height.mas_equalTo(@15);
    }];

    [self.bookingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.priceLabel.mas_bottom);
        make.height.mas_equalTo(@35);
    }];

    
    [self.coentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.priceLabel.mas_top).offset(-10);
        make.height.mas_equalTo(@0);
    }];
    
    
}
-(UIImageView *)homeImage {
    if (!_homeImage) {
        _homeImage = [[UIImageView alloc]init];
        _homeImage.image = [UIImage imageNamed:@"icon_chanp"];
    }
    return _homeImage;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self createLabelFrame:CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30) font:14 text:ADLString(@"维也纳酒店") texeColor:COLOR_333333];
    }
    return _nameLabel;
}
-(UIView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[UIView alloc]init];
    }
    return _scoreView;
}
-(UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"评分:  4.0") texeColor:COLOR_E0212A];
         // _scoreLabel.backgroundColor = [UIColor redColor];
    }
    return _scoreLabel;
}
-(UIButton *)messageBtn {
    if (!_messageBtn) {
       _messageBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"mine_evaluate" title:ADLString(@"3567") titleColor:COLOR_E0212A font:12 target:self action:@selector(changedaddbtn:)];
         [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft createButton:_messageBtn imageTitleSpace:2];
        _messageBtn.tag = 0;
        //  _messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //_messageBtn.backgroundColor = [UIColor yellowColor];
    }
    return _messageBtn;
}

-(UILabel *)coentLabel {
    if (!_coentLabel) {
        _coentLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"全程可以APP订房/退房") texeColor:COLOR_666666];
        
    }
    return _coentLabel;
}
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"¥$100元起") texeColor:COLOR_E0212A];
    }
    return _priceLabel;
}

-(UIButton *)addressBtn {
    if (!_addressBtn) {
        _addressBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"dizhi" title:ADLString(@"南岗第二工业区维也纳酒店") titleColor:COLOR_666666 font:12 target:self action:@selector(changedaddbtn:)];
        _addressBtn.tag = 1;
        _addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          _addressBtn.userInteractionEnabled = NO;
    }
    return _addressBtn;
}

-(UIButton *)bookingBtn {
    if (!_bookingBtn) {
        _bookingBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:ADLString(@"预订") titleColor:COLOR_F7E4E4 font:14 target:self action:@selector(changedaddbtn:)];
        _bookingBtn.tag = 2;
        _bookingBtn.backgroundColor =COLOR_E0212A;
        _bookingBtn.layer.masksToBounds = YES;;
        _bookingBtn.layer.cornerRadius = 5;
        _bookingBtn.userInteractionEnabled = NO;
    }
    return _bookingBtn;
}

-(UIView *)lienView {
    if (!_lienView) {
        _lienView = [[UIView alloc]init];
        _lienView.backgroundColor = COLOR_CCCCCC;
    }
    return _lienView;
}

-(void)changedaddbtn:(UIButton *)btn {
    
}

- (void)tagbtn:(UIButton *)btn {
    
}


-(void)setModel:(ADLBookingHotelModel *)model {
    
    _model  = model;
    [self.scoreView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.homeImage sd_setImageWithURL:[NSURL URLWithString:_model.coverUrl] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    self.nameLabel.text = _model.companyName;
    if (_model.grade.length > 0) {
      self.scoreLabel.text = [NSString stringWithFormat:@"评分:%@",_model.grade];
    }else {
     self.scoreLabel.text = [NSString stringWithFormat:@"评分:00"];
    }
   
    [self.addressBtn setTitle:_model.address forState:UIControlStateNormal];
    if (_model.gradeNum.length > 0) {
       [self.messageBtn setTitle:_model.gradeNum forState:UIControlStateNormal];
    }else {
        [self.messageBtn setTitle:@"0" forState:UIControlStateNormal];
    }
   
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f元起",_model.floorPrice];
    CGFloat grade =[_model.grade floatValue];
  

    
  NSString *  title=  [self decimalwithFormat:@"0.0" floatV:grade];
    
        [self addScoreView:[title integerValue]];
}
-(void)addScoreView:(NSInteger)number{
    int margin = 2;//间隙
    
    int width = 10;//格子的宽
    
    int height = 10;//格子的高
    
    for (int i = 0; i <5; i++) {
       // int row = i/1;
        int col = i%5;
     
        UIImageView *image = [[UIImageView alloc]init];
        if (number > 0) {
            if (i+1 <= number ) {
                image.image = [UIImage imageNamed:@"icon_pinglun_1"];
            }else {
                image.image = [UIImage imageNamed:@"xingji"];
            }
            
        }else {
            
          image.image = [UIImage imageNamed:@"xingji"];
        }
        image.frame =CGRectMake(col*(width+margin), 1, width,  height);
        [self.scoreView addSubview:image];

    }
}

//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

@end
