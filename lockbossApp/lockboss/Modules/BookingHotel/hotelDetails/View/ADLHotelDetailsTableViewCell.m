//
//  ADLHotelDetailsTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelDetailsTableViewCell.h"
#import "ADLBookingHotelModel.h"
#import "UIImageView+WebCache.h"
@interface ADLHotelDetailsTableViewCell ()
@property (nonatomic, strong) UIImageView  *homeImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *breakfast;
@property (nonatomic, strong) UILabel *bed;
@property (nonatomic, strong) UIView  *bookView;
@property (nonatomic, strong) UILabel *discountsLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *bookLabel;
@property (nonatomic, strong) UIButton *bookingBtn;
@property (nonatomic, strong) UILabel *coentLabel;
@property (nonatomic, strong) UIView  *lienView;
@property (nonatomic, strong) UILabel  *roomNumber;
@property (nonatomic ,strong)NSArray *array;

@property (nonatomic, strong) UIButton *btn;
@end
@implementation ADLHotelDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.lienView];
        [self.contentView addSubview:self.homeImage];
        [self.contentView addSubview:self.nameLabel];
         [self.contentView addSubview:self.breakfast];
        [self.contentView addSubview:self.bed];
        [self.contentView addSubview:self.coentLabel];
        [self.contentView addSubview:self.roomNumber];
        [self.contentView addSubview:self.bookView];
        [self.bookView addSubview:self.discountsLabel];
        [self.bookView addSubview:self.priceLabel];
        [self.bookView addSubview:self.bookingBtn];
      

       
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"ADLHotelDetailsTableViewCell";
    ADLHotelDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    if (cell == nil) {
        cell = [[ADLHotelDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
    }
    
    return cell;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
    //线条
    [self.lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws);
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.height.mas_equalTo(5);
    }];
    
    [self.homeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@5);
        make.top.mas_equalTo(ws.lienView.mas_bottom).offset(8);
        make.width.mas_equalTo(@103);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(10);
        make.top.mas_equalTo(self.homeImage.mas_top).offset(5);
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@(120));
    }];
    
    [self.breakfast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@(80));
    }];

    [self.bed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.breakfast.mas_right).offset(10);
        make.top.mas_equalTo(self.breakfast.mas_top);
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@(120));
    }];

    [self.coentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-160);
        make.top.mas_equalTo(self.bed.mas_bottom).offset(10);
        make.height.mas_equalTo(@12);
    }];
    
    
    
    [self.roomNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-160);
        make.top.mas_equalTo(self.coentLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(@12);
    }];
   
    [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.width.mas_equalTo(@80);
    }];

 

    [self.discountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bookView.mas_left).offset(5);
        make.right.mas_equalTo(self.bookView.mas_right).offset(-5);
        make.top.mas_equalTo(self.bookView.mas_top).offset(5);
        make.height.mas_equalTo(@15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bookView.mas_left).offset(5);
        make.right.mas_equalTo(self.bookView.mas_right).offset(-5);
        make.top.mas_equalTo(self.discountsLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(@12);
    }];
    
    [self.bookingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bookView.mas_left).offset(1);
        make.right.mas_equalTo(self.bookView.mas_right).offset(-1);
        make.bottom.mas_equalTo(self.bookView.mas_bottom).offset(-1);
        make.height.mas_equalTo(@22);
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

-(UILabel *)breakfast {
    if (!_breakfast) {
        _breakfast = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"不含早") texeColor:COLOR_E0212A];
    }
    return _breakfast;
}
-(UILabel *)bed {
    if (!_bed) {
        _bed = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"床") texeColor:COLOR_E0212A];
    }
    return _bed;
}

-(UILabel *)coentLabel {
    if (!_coentLabel) {
        _coentLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"全程可以APP订房/退房") texeColor:COLOR_666666];
    }
    return _coentLabel;
}
-(UILabel *)roomNumber {
    if (!_roomNumber) {
        _roomNumber = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"房间数量") texeColor:COLOR_E0212A];
    }
    return _roomNumber;
}
-(UILabel *)discountsLabel {
    if (!_discountsLabel) {
        _discountsLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"优惠价100") texeColor:[UIColor whiteColor]];
        _discountsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _discountsLabel;
}

-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:10 text:ADLString(@"原价100") texeColor:[UIColor whiteColor]];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        
   
    }
    return _priceLabel;
}



-(UIButton *)bookingBtn {
    if (!_bookingBtn) {
        _bookingBtn = [self createButtonFrame:CGRectMake(1,0,80 - 2, 22) imageName:nil title:ADLString(@"立即预订") titleColor:COLOR_E0212A font:14 target:self action:@selector(changedaddbtn:)];
        _bookingBtn.enabled = NO;
      //  _bookingBtn.tag = 2;
        _bookingBtn.backgroundColor =[UIColor whiteColor];
//        _bookingBtn.layer.masksToBounds = YES;;
//        _bookingBtn.layer.cornerRadius = 5;
        
        
        /**
         参数：
         
         rect        :  被传入View的bounds
         corners     :  圆角的位置（枚举值：左上、左下、右上、右下，可用“|”符号组合使用）
         cornerRadii :  圆角大小（CGSize）
         */
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_bookingBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = _bookingBtn.bounds;
        shapeLayer.path = bezierPath.CGPath;
        _bookingBtn.layer.mask = shapeLayer;
        
    }
    return _bookingBtn;
}

-(UIView *)bookView {
    if (!_bookView) {
        _bookView = [[UIView alloc]init];
        _bookView.backgroundColor = COLOR_E0212A;
        _bookView.layer.masksToBounds = YES;;
        _bookView.layer.cornerRadius = 5;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookHome)];
        [_bookView addGestureRecognizer:tap];
    }
    return _bookView;
}
-(void)bookHome {
    if (self.blockBtn) {
        self.blockBtn();
    }
}
-(UIView *)lienView {
    if (!_lienView) {
        _lienView = [[UIView alloc]init];
        _lienView.backgroundColor = COLOR_F2F2F2;
    }
    return _lienView;
}

-(void)changedaddbtn:(UIButton *)btn {
    
}

- (void)tagbtn:(UIButton *)btn {
    
}

-(void)setModel:(ADLBookingHotelModel *)model {
    _model = model;
    [self.homeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.url1]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    self.nameLabel.text = _model.name;
 
    self.discountsLabel.text =[NSString stringWithFormat:@"优惠价%.2f",_model.discountsPrice];
    
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价%.2f",_model.price] attributes:attribtDic];
    
    // 赋值
    self.priceLabel.attributedText = attribtStr;
    
  if (_model.breakfastNum == 1 ){
        self.breakfast.text = @"单早餐";
    }else  if (_model.breakfastNum == 2 ){
        self.breakfast.text = @"双早餐";
    }else  if (_model.breakfastNum >2 ){
        self.breakfast.text = @"多早餐";
    }else {
      self.breakfast.text = @"不含早餐";
    }
    
    
    
    self.bed.text = [NSString stringWithFormat:@"可入住%d人",_model.guestNum];
}
@end
