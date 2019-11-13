//
//  ADLL2PlusFaceView.m
//  lockboss
//
//  Created by adel on 2019/11/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLL2PlusFaceView.h"

@interface ADLL2PlusFaceView ()
@property (nonatomic ,strong)UILabel *titLab;
@property (nonatomic ,strong)UIImageView *imgView;
@property (nonatomic ,strong)UIButton *starBtn;
@property (nonatomic ,strong)UIButton *describeBtn;

@end

@implementation ADLL2PlusFaceView

#pragma mark ------ init ------
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.titLab];
    [self addSubview:self.imgView];
    [self addSubview:self.starBtn];
    [self addSubview:self.describeBtn];
}
#pragma mark ------ layout ------
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(40);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(20);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titLab.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(250);
    }];
    [self.starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(60);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(44);
    }];
    [self.describeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark ------ action ------
-(void)addFaceStar{
    self.clickBtn?self.clickBtn():nil;
}

#pragma mark ------ lazy ------
-(UILabel *)titLab{
    if (!_titLab) {
        _titLab = [self createLabelFrame:CGRectZero font:16 text:@"请正对河马防盗，确保光线充足" texeColor:COLOR_333333];
        _titLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titLab;
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView =[[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_addface"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
-(UIButton *)starBtn{
    if (!_starBtn) {
        _starBtn = [self createButtonFrame:CGRectZero imageName:nil title:@"开始刷脸" titleColor:UIColorFromRGB(0xffffff) font:16 target:self action:@selector(addFaceStar)];
        _starBtn.layer.cornerRadius = 22;
        _starBtn.layer.masksToBounds = YES;
        _starBtn.backgroundColor = APP_COLOR;
    }
    return _starBtn;
}

-(UIButton *)describeBtn{
    if (!_describeBtn) {
        _describeBtn = [self createButtonFrame:CGRectZero imageName:@"icon_addface_safe" title:@"信息已加密，仅用于身份认证" titleColor:UIColorFromRGB(0x999999) font:12 target:self action:nil];
        _describeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _describeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    }
    return _describeBtn;
}
@end
