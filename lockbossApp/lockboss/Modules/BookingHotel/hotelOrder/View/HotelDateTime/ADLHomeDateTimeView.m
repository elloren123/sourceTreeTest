//
//  ADLHomeDateTimeView.m
//  lockboss
//
//  Created by adel on 2019/10/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLHomeDateTimeView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
@interface ADLHomeDateTimeView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign)NSInteger yearRange;
@property (nonatomic, assign)NSInteger dayRange;

@property (nonatomic, assign) NSInteger startYear;
@property (nonatomic, assign) NSInteger selectedYear;

@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign)NSInteger selectedDay;

@property (nonatomic, assign) NSInteger selectedHour;
@property (nonatomic, assign) NSInteger selectedMinute;
@property (nonatomic, assign)NSInteger selectedSecond;
@property (nonatomic, strong)NSCalendar *calendar;
@property (nonatomic, strong)UIButton *cancelButton; //左边退出按钮
@property (nonatomic, strong) UIButton *chooseButton;  //右边的确定按钮
@end

@implementation ADLHomeDateTimeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.alpha = 0;
        
        
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
        contentV.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        
        [contentV addSubview:self.pickerView];
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [contentV addSubview:upVeiw];
        //左边的取消按钮
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.backgroundColor = [UIColor clearColor];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelButton setTitleColor:UIColorFromRGB(0x0d8bf5) forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:self.cancelButton];
        
        //右边的确定按钮
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 52, 0, 40, 40);
        [self.chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        self.chooseButton.backgroundColor = [UIColor clearColor];
        self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.chooseButton setTitleColor:UIColorFromRGB(0x0d8bf5) forState:UIControlStateNormal];
        [self.chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:self.chooseButton];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), 0, SCREEN_WIDTH-104, 40)];
        [upVeiw addSubview:_titleL];
        _titleL.textColor = UIColorFromRGB(0x3f4548);
        _titleL.font = [UIFont systemFontOfSize:13];
        _titleL.textAlignment = NSTextAlignmentCenter;
        
        //分割线
        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 0.5)];
        splitView.backgroundColor = UIColorFromRGB(0xe6e6e6);
        [upVeiw addSubview:splitView];
        
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
        self.startYear=year-15;
        self.yearRange=50;
        [self setCurrentDate:[NSDate date]];
    }
    return self;
}


#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return 5;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return 3;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return 2;
    }
    return 0;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return self.dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return self.dayRange;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
                
            case 0:
            {
                return 24;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    comps = [calendar0 components:unitFlags fromDate:currentDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    self.selectedYear=year;
    self.selectedMonth=month;
    self.selectedDay=day;
    self.selectedHour=hour;
    self.selectedMinute=minute;
    
    self.dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        [self.pickerView selectRow:year-self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        [self.pickerView selectRow:year-self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
    }
    
    [self.pickerView reloadAllComponents];
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*component/6.0, 0,SCREEN_WIDTH/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                self.selectedYear=self.startYear + row;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                self.selectedMonth=row+1;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                self.selectedDay=row+1;
            }
                break;
            case 3:
            {
                self.selectedHour=row;
            }
                break;
            case 4:
            {
                self.selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute];
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                self.selectedYear=self.startYear + row;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                self.selectedMonth=row+1;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                self.selectedDay=row+1;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay];
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                self.selectedHour=row;
            }
                break;
            case 1:
            {
                self.selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld",self.selectedHour,self.selectedMinute];
        
        
        
    }
    
    
}



#pragma mark -- show and hidden
- (void)showDateTimePickerView{
    [self setCurrentDate:[NSDate date]];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        _contentV.frame = CGRectMake(0, SCREEN_HEIGHT-220, SCREEN_WIDTH, 220);
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideDateTimePickerView{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        _contentV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
}
#pragma mark - private
//取消的隐藏
- (void)cancelButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCancelDateTimePickerView)]) {
        [self.delegate didClickCancelDateTimePickerView];
    }
    
    [self hideDateTimePickerView];
    
}

//确认的隐藏
-(void)configButtonClick
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:)]) {
        [self.delegate didClickFinishDateTimePickerView:_string];
        
    }
    
    [self hideDateTimePickerView];
}

-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideDateTimePickerView];
}

@end
