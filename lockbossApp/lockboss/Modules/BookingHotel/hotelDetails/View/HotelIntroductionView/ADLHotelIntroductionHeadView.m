//
//  ADLHotelIntroductionHeadView.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelIntroductionHeadView.h"
#import "ADLBookingHotelModel.h"
#import <UIImageView+WebCache.h>


@interface ADLHotelIntroductionHeadView ()
@property (nonatomic ,strong)UIImageView *headImage;
@property (nonatomic ,strong)UILabel *headName;
@property (nonatomic ,strong)UILabel *number;
@property (nonatomic ,strong)UILabel *content;

@end

@implementation ADLHotelIntroductionHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = [UIColor whiteColor];
       [self addSubview:self.headImage];
       [self addSubview:self.headName];
      // [self addSubview:self.number];
       [self addSubview:self.content];
    }
    return self;
}

-(UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width, 150)];
//        _headImage.contentMode = UIViewContentModeCenter;
    }
    return _headImage;
}
-(UILabel *)headName {
    if (!_headName) {
        _headName = [self createLabelFrame:CGRectMake(25, CGRectGetMaxY(self.headImage.frame)+10, SCREEN_WIDTH - 50, 16) font:16 text:@"维也纳酒店" texeColor:COLOR_666666];
    }
    return _headName;
}
//-(UILabel *)number {
//    if (!_number) {
//        _number = [self createLabelFrame:CGRectMake(25, CGRectGetMaxY(self.headName.frame)+10, SCREEN_WIDTH - 50, 50) font:12 text:@"房间数量" texeColor:COLOR_666666];
//    }
//    return _number;
//}
-(UILabel *)content {
    if (!_content) {
    //    CGFloat titleH = [ADLUtils calculateString:self.model.des rectSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) fontSize:12].height;
        _content = [self createLabelFrame:CGRectMake(25, CGRectGetMaxY(self.headName.frame)+10, SCREEN_WIDTH - 50,20) font:12 text:nil texeColor:COLOR_666666];
        _content.numberOfLines = 0;
       // _content.backgroundColor = [UIColor yellowColor];
    
    }
    return _content;
}

-(void)setModel:(ADLBookingHotelModel *)model {
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.coverUrl]] placeholderImage:[UIImage imageNamed:@"img_square"]];
    self.headName.text = _model.companyName;
    self.content.text = _model.des;
    
     [self.content sizeToFit];
}
@end
