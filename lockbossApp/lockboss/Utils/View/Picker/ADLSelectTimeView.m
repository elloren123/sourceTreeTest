//
//  ADLSelectTimeView.m
//  lockboss
//
//  Created by Adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSelectTimeView.h"
#import "ADLToast.h"

@interface ADLSelectTimeView ()<UIPickerViewDelegate>
@property (nonatomic, copy) void (^finish) (NSString *dateStr);
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong) NSMutableArray *yearArr;
@property (nonatomic, strong) NSArray *zeroArr;
@property (nonatomic, strong) NSArray *oneArr;
@property (nonatomic, assign) BOOL posterior;
@property (nonatomic, assign) BOOL period;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *endLab;

@end

@implementation ADLSelectTimeView

+ (instancetype)showWithTitle:(NSString *)title period:(BOOL)period posterior:(BOOL)posterior finish:(void (^)(NSString *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title period:period posterior:posterior finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title period:(BOOL)period posterior:(BOOL)posterior finish:(void(^)(NSString *dateStr))finish {
    if (self = [super initWithFrame:frame]) {
        self.period = period;
        self.finish = finish;
        self.posterior = posterior;
        [self initializationViewWithTitle:title];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationViewWithTitle:(NSString *)title {
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIView *panelView = [[UIView alloc] init];
    panelView.backgroundColor = [UIColor whiteColor];
    panelView.layer.cornerRadius = 5;
    panelView.clipsToBounds = YES;
    [self addSubview:panelView];
    self.panelView = panelView;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    titleLab.text = title.length > 0 ? title : ADLString(@"select_time");
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = COLOR_333333;
    [panelView addSubview:titleLab];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = COLOR_E5E5E5;
    [panelView addSubview:topLine];
    
    self.yearArr = [[NSMutableArray alloc] init];
    self.zeroArr = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13),@(14),
                     @(15),@(16),@(17),@(18),@(19),@(20),@(21),@(22),@(23),@(24),@(25),@(26),@(27),@(28),@(29),
                     @(30),@(31),@(32),@(33),@(34),@(35),@(36),@(37),@(38),@(39),@(40),@(41),@(42),@(43),@(44),
                     @(45),@(46),@(47),@(48),@(49),@(50),@(51),@(52),@(53),@(54),@(55),@(56),@(57),@(58),@(59)];
    self.oneArr = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13),@(14),@(15),@(16),
                    @(17),@(18),@(19),@(20),@(21),@(22),@(23),@(24),@(25),@(26),@(27),@(28),@(29),@(30),@(31)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    NSInteger startYear = components.year;
    for (int i = 0; i < 12; i++) {
        [self.yearArr addObject:@(startYear+i)];
    }
    
    self.year = components.year;
    self.month = components.month;
    self.day = components.day;
    self.hour = components.hour;
    self.minute = components.minute;
    
    NSInteger yearIndex = [self.yearArr indexOfObject:@(components.year)];
    NSInteger monthIndex = [self.oneArr indexOfObject:@(components.month)];
    NSInteger dayIndex = [self.oneArr indexOfObject:@(components.day)];
    NSInteger hourIndex = [self.zeroArr indexOfObject:@(components.hour)];
    NSInteger minuteIndex = [self.zeroArr indexOfObject:@(components.minute)];
    
    UIPickerView *datePicker = [[UIPickerView alloc] init];
    datePicker.backgroundColor = COLOR_F2F2F2;
    datePicker.tag = 3;
    [panelView addSubview:datePicker];
    datePicker.delegate = self;
    self.datePicker = datePicker;
    
    [datePicker selectRow:yearIndex inComponent:0 animated:NO];
    [datePicker selectRow:monthIndex inComponent:1 animated:NO];
    [datePicker selectRow:dayIndex inComponent:2 animated:NO];
    
    UIPickerView *timePicker = [[UIPickerView alloc] init];
    timePicker.backgroundColor = COLOR_F2F2F2;
    [panelView addSubview:timePicker];
    timePicker.delegate = self;
    self.timePicker = timePicker;
    
    [timePicker selectRow:hourIndex inComponent:0 animated:NO];
    [timePicker selectRow:minuteIndex inComponent:1 animated:NO];
    
    UILabel *ymdLab = [[UILabel alloc] init];
    ymdLab.textAlignment = NSTextAlignmentRight;
    ymdLab.font = [UIFont systemFontOfSize:12];
    ymdLab.textColor = APP_COLOR;
    ymdLab.text = @"年 - 月 - 日";
    [panelView addSubview:ymdLab];
    
    UILabel *hmLab = [[UILabel alloc] init];
    hmLab.textAlignment = NSTextAlignmentRight;
    hmLab.font = [UIFont systemFontOfSize:12];
    hmLab.textColor = APP_COLOR;
    hmLab.text = @"时 - 分";
    [panelView addSubview:hmLab];
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = COLOR_E5E5E5;
    [panelView addSubview:botLine];
    
    UIView *verLine = [[UIView alloc] init];
    verLine.backgroundColor = COLOR_E5E5E5;
    [panelView addSubview:verLine];
    
    UIButton *cancleBtn = [[UIButton alloc] init];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:confirmBtn];
    
    CGFloat panelH = 416;
    if (self.period) {
        panelH = 470;
        panelView.frame = CGRectMake(SCREEN_WIDTH/2-150, SCREEN_HEIGHT, 300, 470);
        topLine.frame = CGRectMake(0, 80, 300, 0.5);
        
        UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 150, 40)];
        [startBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        [startBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [startBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [startBtn addTarget:self action:@selector(clickBeginBtn:) forControlEvents:UIControlEventTouchUpInside];
        startBtn.selected = YES;
        [panelView addSubview:startBtn];
        self.startBtn = startBtn;
        
        UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 40, 150, 40)];
        [endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        [endBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [endBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
        endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [endBtn addTarget:self action:@selector(clickEndBtn:) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:endBtn];
        self.endBtn = endBtn;
        
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(39, 79, 72, 2)];
        indicatorView.backgroundColor = APP_COLOR;
        indicatorView.layer.cornerRadius = 1;
        [panelView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        ymdLab.frame = CGRectMake(0, 81, 285, 32);
        datePicker.frame = CGRectMake(15, 113, 270, 119);
        hmLab.frame = CGRectMake(0, 232, 285, 32);
        timePicker.frame = CGRectMake(15, 264, 270, 119);
        
        UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 393, 120, 20)];
        startLab.textAlignment = NSTextAlignmentCenter;
        startLab.font = [UIFont systemFontOfSize:12];
        startLab.textColor = APP_COLOR;
        startLab.layer.borderColor = APP_COLOR.CGColor;
        startLab.layer.borderWidth = 0.5;
        startLab.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",components.year,components.month,components.day,components.hour,components.minute];
        [panelView addSubview:startLab];
        self.startLab = startLab;
        
        UILabel *zhiLab = [[UILabel alloc] initWithFrame:CGRectMake(135, 393, 30, 20)];
        zhiLab.textAlignment = NSTextAlignmentCenter;
        zhiLab.font = [UIFont systemFontOfSize:12];
        zhiLab.textColor = APP_COLOR;
        zhiLab.text = @"至";
        [panelView addSubview:zhiLab];
        
        UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 393, 120, 20)];
        endLab.textAlignment = NSTextAlignmentCenter;
        endLab.font = [UIFont systemFontOfSize:12];
        endLab.textColor = APP_COLOR;
        endLab.layer.borderColor = APP_COLOR.CGColor;
        endLab.layer.borderWidth = 0.5;
        [panelView addSubview:endLab];
        self.endLab = endLab;
        
        botLine.frame = CGRectMake(0, 423, 300, 0.5);
        verLine.frame = CGRectMake(150, 423, 0.5, 47);
        cancleBtn.frame = CGRectMake(0, 423, 150, 47);
        confirmBtn.frame = CGRectMake(150, 423, 150, 47);
    } else {
        panelView.frame = CGRectMake(SCREEN_WIDTH/2-150, SCREEN_HEIGHT, 300, 416);
        topLine.frame = CGRectMake(0, 51, 300, 0.5);
        ymdLab.frame = CGRectMake(0, 52, 280, 32);
        datePicker.frame = CGRectMake(20, 84, 260, 119);
        hmLab.frame = CGRectMake(0, 203, 280, 32);
        timePicker.frame = CGRectMake(20, 235, 260, 119);
        botLine.frame = CGRectMake(0, 370, 300, 0.5);
        verLine.frame = CGRectMake(150, 370, 0.5, 46);
        cancleBtn.frame = CGRectMake(0, 370, 150, 46);
        confirmBtn.frame = CGRectMake(150, 370, 150, 46);
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        panelView.frame = CGRectMake(SCREEN_WIDTH/2-150, (SCREEN_HEIGHT-panelH)/2, 300, panelH);
        coverView.alpha = 0.5;
    }];
}

#pragma mark ------ UIPickerView Delegate && DataSource ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 3) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 85;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 3) {
        if (component == 0) {
            return self.yearArr.count;
        } else if (component == 1) {
            return 12;
        } else {
            if (self.month == 2) {
                if ((self.year%100 > 0 && self.year%4 == 0) || self.year%400 == 0) {
                    return 29;
                } else {
                    return 28;
                }
            } else if (self.month == 4 || self.month == 6 || self.month == 9 || self.month == 11) {
                return 30;
            } else {
                return 31;
            }
        }
    } else {
        if (component == 0) {
            return 24;
        } else {
            return 60;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 26;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLab = [[UILabel alloc] init];
    pickerLab.textAlignment = NSTextAlignmentCenter;
    pickerLab.font = [UIFont systemFontOfSize:13];
    pickerLab.textColor = [UIColor blackColor];
    if (pickerView.tag == 3) {
        if (component == 0) {
            pickerLab.text = [NSString stringWithFormat:@"%@年",self.yearArr[row]];
        } else if (component == 1) {
            pickerLab.text = [NSString stringWithFormat:@"%@月",self.oneArr[row]];
        } else {
            pickerLab.text = [NSString stringWithFormat:@"%@日",self.oneArr[row]];
        }
    } else {
        if (component == 0) {
            pickerLab.text = [NSString stringWithFormat:@"%@时",self.zeroArr[row]];
        } else {
            pickerLab.text = [NSString stringWithFormat:@"%@分",self.zeroArr[row]];
        }
    }
    return pickerLab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 3) {
        if (component == 0) {
            self.year = [self.yearArr[row] integerValue];
            [pickerView reloadComponent:2];
        }
        if (component == 1) {
            self.month = [self.oneArr[row] integerValue];
            [pickerView reloadComponent:2];
        }
        self.day = [self.oneArr[[pickerView selectedRowInComponent:2]] integerValue];
    } else {
        if (component == 0) {
            self.hour = [self.zeroArr[[pickerView selectedRowInComponent:0]] integerValue];
        } else {
            self.minute = [self.zeroArr[[pickerView selectedRowInComponent:1]] integerValue];
        }
    }
    
    if (self.period) {
        if (self.startBtn.selected) {
            self.startLab.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",self.year,self.month,self.day,self.hour,self.minute];
        } else {
            self.endLab.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",self.year,self.month,self.day,self.hour,self.minute];
        }
    }
}

#pragma mark ------ 开始 ------
- (void)clickBeginBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.endBtn.selected = NO;
        [self selectPickerWithTimeStr:self.startLab.text];
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(39, 79, 72, 2);
        }];
    }
}

#pragma mark ------ 结束 ------
- (void)clickEndBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.startBtn.selected = NO;
        [self selectPickerWithTimeStr:self.endLab.text];
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(189, 79, 72, 2);
        }];
    }
}

#pragma mark ------ 切换选中 ------
- (void)selectPickerWithTimeStr:(NSString *)timeStr {
    if (timeStr.length > 0) {
        self.year = [[timeStr substringToIndex:4] integerValue];
        self.month = [[timeStr substringWithRange:NSMakeRange(5, 2)] integerValue];
        self.day = [[timeStr substringWithRange:NSMakeRange(8, 2)] integerValue];
        self.hour = [[timeStr substringWithRange:NSMakeRange(11, 2)] integerValue];
        self.minute = [[timeStr substringWithRange:NSMakeRange(14, 2)] integerValue];
        [self.datePicker reloadAllComponents];
        [self.timePicker reloadAllComponents];
        
        [self.datePicker selectRow:[self.yearArr indexOfObject:@(self.year)] inComponent:0 animated:YES];
        [self.datePicker selectRow:[self.oneArr indexOfObject:@(self.month)] inComponent:1 animated:YES];
        [self.datePicker selectRow:[self.oneArr indexOfObject:@(self.day)] inComponent:2 animated:YES];
        [self.timePicker selectRow:[self.zeroArr indexOfObject:@(self.hour)] inComponent:0 animated:YES];
        [self.timePicker selectRow:[self.zeroArr indexOfObject:@(self.minute)] inComponent:1 animated:YES];
    } else {
        self.endLab.text = self.startLab.text;
    }
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    if (self.period) {
        if (self.endLab.text.length == 0) {
            [ADLToast showMessage:@"请选择结束时间"];
        } else {
            BOOL goon = YES;
            NSDate *startDate = [formatter dateFromString:self.startLab.text];
            NSDate *endDate = [formatter dateFromString:self.endLab.text];
            NSComparisonResult result = [startDate compare:endDate];
            if (result == NSOrderedAscending) {
                if (self.posterior) {
                    NSComparisonResult cresult = [[NSDate date] compare:startDate];
                    if (cresult != NSOrderedAscending) {
                        [ADLToast showMessage:@"开始时间应大于当前时间"];
                        goon = NO;
                    }
                }
            } else {
                [ADLToast showMessage:@"结束时间应大于开始时间"];
                goon = NO;
            }
            if (goon) {
                if (self.finish) {
                    self.finish([NSString stringWithFormat:@"%@,%@",self.startLab.text,self.endLab.text]);
                }
                [self clickCancleBtn];
            }
        }
    } else {
        BOOL keepon = YES;
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",self.year,self.month,self.day,self.hour,self.minute];
        if (self.posterior) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSDate *selectDate = [formatter dateFromString:dateStr];
            NSComparisonResult result = [[NSDate date] compare:selectDate];
            if (result != NSOrderedAscending) {
                keepon = NO;
                [ADLToast showMessage:@"选择的时间应大于当前时间"];
            }
        }
        if (keepon) {
            if (self.finish) {
                self.finish(dateStr);
            }
            [self clickCancleBtn];
        }
    }
}

@end
