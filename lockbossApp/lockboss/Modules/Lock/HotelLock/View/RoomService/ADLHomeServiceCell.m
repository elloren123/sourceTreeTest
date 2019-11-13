//
//  ADLHomeServiceCell.m
//  lockboss
//
//  Created by adel on 2019/11/4.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHomeServiceCell.h"
#import "ADLHomeServiceModel.h"
#import <UIImageView+WebCache.h>

@interface ADLHomeServiceCell ()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *title;
@end

@implementation ADLHomeServiceCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.title];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
   
    WS(ws);
   
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.top.equalTo(ws).offset(0);
        make.width.equalTo(@(66));
        make.height.equalTo(@(66));
    }];
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.icon.mas_bottom).offset(10);
        make.height.equalTo(@15);
        make.left.equalTo(@(5));
        make.right.equalTo(@(-5));
    }];
    
    
}

-(UIImageView *)icon {
    if (!_icon) {
        
        _icon = [[UIImageView alloc]init];
        //  _icon.backgroundColor = [UIColor yellowColor];
//      _icon.contentMode = UIViewContentModeScaleAspectFill;
//         _icon.clipsToBounds = YES;
        //   _icon.alpha = 0.2;
    }
    return _icon;
}
-(UILabel *)title {
    if (!_title) {
        _title = [self createLabelFrame:CGRectMake(0, 0,0, 0) font:12 text:ADLString(@"密码") texeColor:COLOR_333333];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.userInteractionEnabled = NO;
      
    }
    return _title;
}


-(void)strtitle:(NSString *)title image:(NSString *)image {
    self.title.text = title;
    self.icon.image = [UIImage imageNamed:image];
    
}

-(void)setModel:(ADLHomeServiceModel *)model {
    _model = model;
    
    
    
    self.title.text = _model.name;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.imageUrl]] placeholderImage:[UIImage imageNamed:@"bg_adel_service"]];
    //    [self.sericeBtn setTitle:_model.name forState:UIControlStateNormal];
    //
    //  [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.imageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg_adel_service"]];
    
    
}




@end
