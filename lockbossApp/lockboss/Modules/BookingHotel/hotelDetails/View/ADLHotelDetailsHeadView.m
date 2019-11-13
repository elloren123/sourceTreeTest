//
//  ADLHotelDetailsHeadView.m
//  lockboss
//
//  Created by adel on 2019/9/23.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHotelDetailsHeadView.h"
#import "ADLBookingHotelModel.h"
@interface ADLHotelDetailsHeadView ()
@property (nonatomic ,strong)UIImageView *honeimage;
@property (nonatomic ,strong)UILabel *honeName;
@property (nonatomic ,strong)UIButton *introduceBtn;
@property (nonatomic ,strong)UIButton *addresBtn;
@property (nonatomic ,strong)UIButton *scoreBtn;
@property (nonatomic ,strong)UIView *scoreView;
@property (nonatomic ,strong)UIButton *commentsBtn;



@property (nonatomic ,strong)UIView *lien1;
@property (nonatomic ,strong)UIView *lien2;

@property (nonatomic ,strong)UIView *screenView;
@end

@implementation ADLHotelDetailsHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
          [self addSubview:self.honeimage];
           [self addSubview:self.honeName];
            [self addSubview:self.introduceBtn];
            [self addSubview:self.addresBtn];
            [self addSubview:self.scoreBtn];
         [self addSubview:self.scoreView];
            [self addSubview:self.commentsBtn];
            [self addSubview:self.lien1];
            [self addSubview:self.stay];
            [self addSubview:self.leave];
            [self addSubview:self.numDateBtn];
            [self addSubview:self.lien2];
            [self addSubview:self.screenView];
        
    }
    return self;
}

//-(void)addsubView
//{
//    int margin = 10;//间隙
//
//    int width = 60;//格子的宽
//
//    int height = 30;//格子的高
//
//    for (int i = 0; i < self.array.count; i++) {
//       // int row = i/3;
//        int col = i%_array.count;
//        UIButton * btn = [self createButtonFrame:CGRectMake(18+col*(width+margin), self.height - 50, width,  height) imageName:nil title:self.array[i] titleColor:COLOR_333333 font:10 target:self action:@selector(tagbtn:)];
//        btn.backgroundColor  = COLOR_F7F7F7;
//        [self addSubview:btn];
//        btn.tag = i+1;
//
//    }
//    UIButton * screeningbtn = [self createButtonFrame:CGRectMake(self.width - 80, self.height - 50, width,  height) imageName:@"jiantou1" title:@"筛选" titleColor:COLOR_333333 font:12 target:self action:@selector(tagbtn:)];
//    screeningbtn.tag = 5;
//    screeningbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:screeningbtn imageTitleSpace:10];
//    [self addSubview:screeningbtn];
//
//}
-(void)tagbtn:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(htelDetailsHeadView:didSelectRowAtIndexPath:)]) {
        [self.delegate htelDetailsHeadView:self didSelectRowAtIndexPath:btn];
    }
}
//-(NSArray *)array {
//    if (!_array) {
//        _array = @[@"到店支付",@"早餐",@"大床",@"房型"];
//    }
//    return _array;
//}
-(UIView *)screenView {
    if (!_screenView) {
        _screenView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 50, self.width,30)];
      //  _screenView.backgroundColor = [UIColor yellowColor];
    }
    return _screenView;
}

-(void)setArray:(NSMutableArray *)array {
    
    for(UIView *view in [self.screenView subviews])
    {
        [view removeFromSuperview];
    }
    int margin = 10;//间隙
    
    int width = 80;//格子的宽
    
    int height = 30;//格子的高
    
    for (int i = 0; i < array.count; i++) {
        // int row = i/3;
        int col = i%array.count;
        NSString *name = array[i];
        
        UIButton * btn = [self createButtonFrame:CGRectMake(18+col*(width+margin),0, width,  height) imageName:nil title:array[i] titleColor:COLOR_E0212A font:10 target:self action:@selector(tagbtn:)];
        btn.backgroundColor  = COLOR_F7F7F7;
        if ([name isEqualToString:ADLString(@"全部早餐")] || [name isEqualToString:ADLString(@"有早餐")] || [name isEqualToString:ADLString(@"无早餐")]) {
            [btn setImage:[UIImage imageNamed:@"icon_can"] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"icon_fangxing"] forState:UIControlStateNormal];
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        btn.tag = i+1;
        
        [self.screenView addSubview:btn];
    }
    UIButton * screeningbtn = [self createButtonFrame:CGRectMake(self.screenView.width - 80,0, width,  height) imageName:@"jiantou1" title:@"筛选" titleColor:COLOR_333333 font:12 target:self action:@selector(tagbtn:)];
    screeningbtn.tag = 5;
    screeningbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:screeningbtn imageTitleSpace:10];
    [self.screenView addSubview:screeningbtn];
    [self datestr:1];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
    CGFloat left = 18;
    [self.honeimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws);
        make.right.mas_equalTo(ws);
        make.top.mas_equalTo(ws);
        make.height.mas_equalTo(150);
    }];
    [self.introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(ws.honeimage.mas_bottom).offset(12);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(20);
    }];
    
    [self.honeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(ws.introduceBtn.mas_left).offset(left);
        make.top.mas_equalTo(ws.honeimage.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
    }];
   
    [self.addresBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(ws.honeName.mas_bottom).offset(12);
        make.height.mas_equalTo(15);
    }];
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(ws.addresBtn.mas_bottom).offset(12);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(15);

    }];
    [self.scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(ws.addresBtn.mas_bottom).offset(12);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.scoreBtn.mas_right).offset(2);
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(ws.scoreBtn.mas_top);
        make.height.mas_equalTo(10);
    }];
    [self.lien1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(ws.commentsBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
  //共多少天
    [self.numDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(self.lien1.mas_bottom).offset(10);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(@15);
    }];
    
    [self.stay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(self.numDateBtn.mas_top);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(@15);
    }];
    [self.leave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stay.mas_right).offset(100);
        make.top.mas_equalTo(self.numDateBtn.mas_top);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(@15);
    }];
    
    [self.lien2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-left);
        make.top.mas_equalTo(ws.leave.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
}
-(UIImageView *)honeimage {
    if (!_honeimage) {
        _honeimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiudian2"]];
    }
    return _honeimage;
}
-(UILabel *)honeName {
    if (!_honeName) {
        _honeName = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:16 text:ADLString(@"维也纳酒店") texeColor:COLOR_333333];
    }
    return _honeName;
}
-(UIButton *)introduceBtn {
    if (!_introduceBtn) {
        _introduceBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"jiantou1" title:ADLString(@"酒店介绍") titleColor:COLOR_666666 font:12 target:self action:@selector(numDateBtn:)];
           _introduceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _introduceBtn.tag = 1;
        [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_introduceBtn imageTitleSpace:10];
    }
        return _introduceBtn;
    
}
-(UIButton *)addresBtn {
    if (!_addresBtn) {
        _addresBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:@"地址" titleColor:COLOR_666666 font:12 target:self action:@selector(numDateBtn:)];
           _addresBtn.tag = 2;
        _addresBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _addresBtn;
}
-(UIButton *)scoreBtn {
    if (!_scoreBtn) {
        _scoreBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:nil title:@"" titleColor:COLOR_666666 font:10 target:self action:@selector(numDateBtn:)];
        _scoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_scoreBtn imageTitleSpace:10];
    }
    return _scoreBtn;
}
-(UIView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[UIView alloc]init];
    }
    return _scoreView;
}
-(UIButton *)commentsBtn {
    if (!_commentsBtn) {
        _commentsBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"jiantou1" title:@"0条评论" titleColor:COLOR_E0212A font:12 target:self action:@selector(numDateBtn:)];
            [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_commentsBtn imageTitleSpace:10];
        _commentsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     // _commentsBtn.backgroundColor = [UIColor yellowColor];
          _commentsBtn.tag = 3;
    }
    return _commentsBtn;
}
-(UILabel *)leave {
    if (!_leave) {
        _leave = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:ADLString(@"退房时间") texeColor:COLOR_333333];
    }
    return _leave;
}
-(UILabel *)stay {
    if (!_stay) {
        _stay = [self createLabelFrame:CGRectMake(0, 0, 0, 0) font:12 text:ADLString(@"入住时间") texeColor:COLOR_333333];
    }
    return _stay;
}
-(UIButton *)numDateBtn {
    if (!_numDateBtn) {
        _numDateBtn = [self createButtonFrame:CGRectMake(0, 0, 0, 0) imageName:@"jiantou1" title:@"共1天" titleColor:COLOR_E0212A font:12 target:self action:@selector(numDateBtn:)];
             [self layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight createButton:_numDateBtn imageTitleSpace:10];
              _numDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _numDateBtn.tag = 4;
             // _numDateBtn.backgroundColor = [UIColor yellowColor];
    }
    return _numDateBtn;
}
-(UIView *)lien1 {
    if (!_lien1) {
        _lien1 = [[UIView alloc]init];
        _lien1.backgroundColor = COLOR_999999;
    }
    return _lien1;
}
-(UIView *)lien2 {
    if (!_lien2) {
        _lien2 = [[UIView alloc]init];
        _lien2.backgroundColor = COLOR_999999;
    }
    return _lien2;
}
-(void)numDateBtn:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(htelDetailsHeadView:didSelectRowAtIndexPath:)]) {
        [self.delegate htelDetailsHeadView:self didSelectRowAtIndexPath:btn];
    }
}

-(void)setModel:(ADLBookingHotelModel *)model {
    _model = model;
    [self.addresBtn setTitle:_model.address forState:UIControlStateNormal];
    if (_model.gradeNum.length > 0) {
    [self.commentsBtn setTitle:[NSString stringWithFormat:@"%@条评论",_model.gradeNum] forState:UIControlStateNormal];
    }
  
//    [self.commentsBtn setImage:[UIImage imageNamed:@"jiantou1"] forState:UIControlStateNormal];
    self.honeName.text  =_model.companyName;
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"评分%@",_model.grade] forState:UIControlStateNormal];
    
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
        image.frame =CGRectMake(col*(width+margin), 0, width,  height);
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

-(void)datestr:(NSInteger)date {
    NSInteger dis = 1; //前后的天数
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    
    self.stay.text = [NSString stringWithFormat:@"入住日期%@",currentString];
    
    NSDate* theDate;
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [currentDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        // theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }
    else
    {
        theDate = currentDate;
    }
    //yyyy-MM-dd hh:mm:ss
    NSDateFormatter *theDateformatter = [[NSDateFormatter alloc] init];
    [theDateformatter setDateFormat:@"MM-dd"];
    NSString *string=[theDateformatter stringFromDate:theDate];
    
    self.leave.text = [NSString stringWithFormat:@"退房日期%@",string];
}
@end
