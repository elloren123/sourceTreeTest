//
//  ADLScreeningableViewCell.m
//  lockboss
//
//  Created by adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLScreeningableViewCell.h"

@interface ADLScreeningableViewCell ()

@property (nonatomic ,strong)UILabel *content;
@property (nonatomic ,strong)UIView *line;
@end


@implementation ADLScreeningableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ScreeningableViewCell";
    ADLScreeningableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ADLScreeningableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
    
}
-(void)setupUI{
            [self addSubview:self.locationBtn];
            [self addSubview:self.startTime];
             [self addSubview:self.endTime];
            [self addSubview:self.content];
            [self addSubview:self.line];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.height.mas_equalTo(@0.5);
         make.bottom.mas_equalTo(self.mas_bottom).offset(-0.5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(self.mas_right).offset(-50);
         make.height.mas_equalTo(@15);
         make.width.mas_equalTo((self.width - 100)/2);
        make.top.mas_equalTo(self.mas_top).offset(10);
    }];
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo((self.width - 40)/2);
        make.top.mas_equalTo(self.mas_top).offset(10);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo((self.width - 100)/2);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo((self.width - 40)/2);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];

    [self datestr:1];
}
-(UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [self createButtonFrame:CGRectMake(10,self.height - 35 ,120,15) imageName:@"" title:nil titleColor:COLOR_666666 font:12 target:self action:@selector(changedaddbtn:)];
        _locationBtn.tag = 0;
        _locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _locationBtn.contentHorizontalAlignment  =UIControlContentHorizontalAlignmentLeft;
    }
    return _locationBtn;
}

-(UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 130,self.height - 35 ,120,15)];
        _content.textColor = COLOR_666666;
        _content.font = [UIFont systemFontOfSize:12];
        _content.textAlignment = NSTextAlignmentRight;
    }
    return _content;
}

-(UILabel *)startTime {
    if (!_startTime) {
        _startTime = [[UILabel alloc]initWithFrame:CGRectMake(10,5, self.width/2 - 20, 12)];
        _startTime.textColor = COLOR_333333;
        _startTime.font = [UIFont systemFontOfSize:14];
       //_startTime.textAlignment = NSTextAlignmentCenter;
        _startTime.text = @"2019-10-10";
    
    }
    return _startTime;
}

-(UILabel *)endTime {
    if (!_endTime) {
        _endTime = [[UILabel alloc]init];
        _endTime.textColor = COLOR_333333;
        _endTime.font = [UIFont systemFontOfSize:14];
        _endTime.textAlignment = NSTextAlignmentRight;
        _endTime.text = @"2019-10-10";
      
    }
    return _endTime;
}
//1天  --  7天
-(void)datestr:(NSInteger)date {
    NSInteger dis = 1; //前后的天数
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    
   self.startTime.text = currentString;
    
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
    [theDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string=[theDateformatter stringFromDate:theDate];
    
    self.endTime.text = string;
}
-(void)changedaddbtn:(UIButton *)btn{
    if (self.changedaddbtnBack) {
       self.changedaddbtnBack();
    }
  
}


-(UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0,40, self.width, 0.5)];
        _line.backgroundColor =COLOR_CCCCCC   ;
    }
    return _line;
}
-(void)titlestr:(NSString *)title content:(NSString * )content {
    [self.locationBtn setTitle:title forState:UIControlStateNormal];
    self.content.text = content;
   
}

@end
