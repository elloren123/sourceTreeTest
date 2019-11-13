//
//  ADLHotelCommentTableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelCommentTableViewCell.h"
#import "ADLCommentImageView.h"
#import "ADLBookingHotelModel.h"
#import <UIImageView+WebCache.h>

@interface ADLHotelCommentTableViewCell ()
@property (nonatomic, strong) UIImageView  *homeImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *coentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ADLCommentImageView *images;
@property (nonatomic, strong) UIView  *lienView;

@property (nonatomic ,strong)NSArray *array;

@property (nonatomic, strong) UIButton *btn;
@end
@implementation ADLHotelCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.homeImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.coentLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.images];
        [self.contentView addSubview:self.lienView];
        
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *FamilyOpenLockCell = @"ADLHotelCommentTableViewCell";
    ADLHotelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FamilyOpenLockCell];
    if (cell == nil) {
        cell = [[ADLHotelCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FamilyOpenLockCell];
    }
    
    return cell;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.homeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@12);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.homeImage.mas_top).offset(5);
        make.height.mas_equalTo(@14);
      
    }];

    
    [self.coentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
       
    }];
 
    [self.images mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeImage.mas_right).offset(16);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.coentLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
        make.height.mas_equalTo(@12);
        
    }];
    //线条
    [self.lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(@2);
    }];
    
    
}

-(UIImageView *)homeImage {
    if (!_homeImage) {
        _homeImage = [[UIImageView alloc]init];
        _homeImage.image = [UIImage imageNamed:@"icon_chanp"];
        _homeImage.layer.masksToBounds = YES;;
        _homeImage.layer.cornerRadius = 45/2;
    }
    return _homeImage;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self createLabelFrame:CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30) font:14 text:ADLString(@"维也纳酒店") texeColor:COLOR_333333];
    }
    return _nameLabel;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelFrame:CGRectMake(105, 10, SCREEN_WIDTH - 105 - 140, 30) font:11 text:nil texeColor:COLOR_666666];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}



-(UILabel *)coentLabel {
    if (!_coentLabel) {
        _coentLabel = [self createLabelFrame:CGRectMake(0,0,0, 0) font:12 text:ADLString(@"全程可以APP订房/退房") texeColor:COLOR_666666];
        _coentLabel.numberOfLines = 0;
       // _coentLabel.backgroundColor = [UIColor yellowColor];
    }
    return _coentLabel;
}

-(ADLCommentImageView *)images {
    if (!_images) {
        _images = [[ADLCommentImageView alloc]init];
    }
    return _images;
}
-(UIView *)lienView {
    if (!_lienView) {
        _lienView = [[UIView alloc]init];
        _lienView.backgroundColor = COLOR_F7F7F7;
    }
    return _lienView;
}
-(void)setModel:(ADLBookingHotelModel *)model {
    _model = model;
    
    self.nameLabel.text =_model.addUserName;
    self.coentLabel.text = _model.gradeMessages;
    [self.homeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.headShot]] placeholderImage:[UIImage imageNamed:@"img_rectangle"]];
    self.timeLabel.text = [ADLUtils getDateFromTimestamp:_model.gradeDatetime format:@"YYY-MM-dd HH:mm:ss"];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    

    for (int i =1; i < 10; i++) {

        NSMutableDictionary *dict = [model mj_keyValues];

    NSString *str = [NSString stringWithFormat:@"gradeUrl%d",i];
        NSString *image = dict[str];
        if (image.length > 0) {
        [imageArray addObject:image];
        }


    }
    _model.numberImage = imageArray.count;
    self.images.isSmall = YES;
    self.images.photos = imageArray;
    

}
@end
