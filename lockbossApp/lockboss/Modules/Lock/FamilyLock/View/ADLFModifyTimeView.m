//
//  ADLFModifyTimeView.m
//  lockboss
//
//  Created by Adel on 2019/9/18.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLFModifyTimeView.h"
#import "ADLToast.h"

@interface ADLFModifyTimeView ()<UIPickerViewDelegate>
@property (nonatomic, copy) void (^finish) (NSString *dateStr);
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) NSMutableArray *yearArr;
@property (nonatomic, strong) NSArray *zeroArr;
@property (nonatomic, strong) NSArray *oneArr;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@end

@implementation ADLFModifyTimeView

+ (instancetype)showWithTitle:(NSString *)title finish:(void (^)(NSString *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title finish:(void (^)(NSString *))finish {
    if (self = [super initWithFrame:frame]) {
        self.finish = finish;
        
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-140, SCREEN_HEIGHT, 280, 412)];
        panelView.backgroundColor = [UIColor whiteColor];
        panelView.layer.cornerRadius = 5;
        panelView.clipsToBounds = YES;
        [self addSubview:panelView];
        self.panelView = panelView;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        titleLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titleLab.textColor = COLOR_333333;
        titleLab.text = title;
        [panelView addSubview:titleLab];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(238, 0, 42, 50)];
        [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:closeBtn];
        
        UILabel *ymdLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 265, 32)];
        ymdLab.textAlignment = NSTextAlignmentRight;
        ymdLab.font = [UIFont systemFontOfSize:12];
        ymdLab.textColor = APP_COLOR;
        ymdLab.text = @"年 - 月 - 日";
        [panelView addSubview:ymdLab];
        
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
        
        NSInteger yearIndex = [self.yearArr indexOfObject:@(components.year)];
        NSInteger monthIndex = [self.oneArr indexOfObject:@(components.month)];
        NSInteger dayIndex = [self.oneArr indexOfObject:@(components.day)];
        NSInteger hourIndex = [self.zeroArr indexOfObject:@(components.hour)];
        NSInteger minuteIndex = [self.zeroArr indexOfObject:@(components.minute)];
        
        UIPickerView *datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 76, 250, 119)];
        datePicker.backgroundColor = COLOR_F2F2F2;
        datePicker.tag = 3;
        [panelView addSubview:datePicker];
        datePicker.delegate = self;
        self.datePicker = datePicker;
        
        [datePicker selectRow:yearIndex inComponent:0 animated:NO];
        [datePicker selectRow:monthIndex inComponent:1 animated:NO];
        [datePicker selectRow:dayIndex inComponent:2 animated:NO];
        
        UILabel *hmLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 195, 265, 32)];
        hmLab.textAlignment = NSTextAlignmentRight;
        hmLab.font = [UIFont systemFontOfSize:12];
        hmLab.textColor = APP_COLOR;
        hmLab.text = @"时 - 分";
        [panelView addSubview:hmLab];
        
        UIPickerView *timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 227, 250, 119)];
        timePicker.backgroundColor = COLOR_F2F2F2;
        [panelView addSubview:timePicker];
        timePicker.delegate = self;
        self.timePicker = timePicker;
        
        [timePicker selectRow:hourIndex inComponent:0 animated:NO];
        [timePicker selectRow:minuteIndex inComponent:1 animated:NO];
        
        UIButton *permanentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        permanentBtn.frame = CGRectMake(15, 361, 117, 36);
        [permanentBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        permanentBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [permanentBtn setTitle:ADLString(@"permanent") forState:UIControlStateNormal];
        permanentBtn.backgroundColor = COLOR_F2F2F2;
        permanentBtn.layer.cornerRadius = 4;
        [permanentBtn addTarget:self action:@selector(clickPermanentBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:permanentBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(148, 361, 117, 36);
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn setTitle:ADLString(@"confirm") forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        confirmBtn.backgroundColor = APP_COLOR;
        confirmBtn.layer.cornerRadius = 4;
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:confirmBtn];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.5;
            panelView.frame = CGRectMake(SCREEN_WIDTH/2-140, (SCREEN_HEIGHT-412)/2, 280, 412);
        }];
    }
    return self;
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
    return 80;
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
    }
}

#pragma mark ------ 永久 ------
- (void)clickPermanentBtn {
    if (self.finish) {
        self.finish(@"-1");
    }
    [self clickCloseBtn];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    NSInteger day = [self.oneArr[[self.datePicker selectedRowInComponent:2]] integerValue];
    NSInteger hour = [self.zeroArr[[self.timePicker selectedRowInComponent:0]] integerValue];
    NSInteger minute = [self.zeroArr[[self.timePicker selectedRowInComponent:1]] integerValue];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",self.year,self.month,day,hour,minute];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *endDate = [formatter dateFromString:dateStr];
    NSComparisonResult result = [[NSDate date] compare:endDate];
    if (result == NSOrderedAscending) {
        if (self.finish) {
            self.finish(dateStr);
        }
        [self clickCloseBtn];
    } else {
        [ADLToast showMessage:@"选择时间应大于当前时间"];
    }
}

#pragma mark ------ 关闭 ------
- (void)clickCloseBtn {
    CGRect frame = self.panelView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
