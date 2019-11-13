//
//  ADLSelectMonthView.m
//  lockboss
//
//  Created by Adel on 2019/9/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLSelectMonthView.h"
#import "ADLToast.h"

@interface ADLSelectMonthView ()<UIPickerViewDelegate>
@property (nonatomic, copy) void (^finish) (NSString *monthStr);
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *yearArr;
@property (nonatomic, strong) NSArray *monthArr;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *endLab;
@property (nonatomic, assign) BOOL period;
@end

@implementation ADLSelectMonthView

+ (instancetype)showWithTitle:(NSString *)title period:(BOOL)period selectTime:(NSString *)selectTime finish:(void (^)(NSString *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title period:period selectTime:selectTime finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title period:(BOOL)period selectTime:(NSString *)selectTime finish:(void (^)(NSString *))finish {
    if (self = [super initWithFrame:frame]) {
        self.finish = finish;
        self.period = period;
        
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
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 50)];
        titleLab.text = title.length > 0 ? title : ADLString(@"select_time");
        titleLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = COLOR_333333;
        [panelView addSubview:titleLab];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:topLine];
        
        self.yearArr = [[NSMutableArray alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        NSInteger startYear = components.year-5;
        for (int i = 0; i < 10; i++) {
            [self.yearArr addObject:@(startYear+i)];
        }
        self.monthArr = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12)];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        [panelView addSubview:pickerView];
        pickerView.delegate = self;
        self.pickerView = pickerView;
        
        NSString *endStr = @"";
        NSInteger yearIndex = [self.yearArr indexOfObject:@(components.year)];
        NSInteger monthIndex = [self.monthArr indexOfObject:@(components.month)];
        NSString *startStr = [NSString stringWithFormat:@"%ld-%02ld",components.year,components.month];
        if (selectTime.length > 0) {
            if (period) {
                NSArray *selArr = [selectTime componentsSeparatedByString:@","];
                if (selArr.count == 2) {
                    NSArray *firstArr = [selArr.firstObject componentsSeparatedByString:@"-"];
                    NSArray *lastArr = [selArr.lastObject componentsSeparatedByString:@"-"];
                    if (firstArr.count == 2 && lastArr.count == 2) {
                        NSInteger fyear = [firstArr.firstObject integerValue];
                        NSInteger fmonth = [firstArr.lastObject integerValue];
                        NSInteger lyear = [lastArr.firstObject integerValue];
                        NSInteger lmonth = [lastArr.lastObject integerValue];
                        if ([self.yearArr containsObject:@(fyear)] &&
                            [self.yearArr containsObject:@(lyear)] &&
                            [self.monthArr containsObject:@(fmonth)] &&
                            [self.monthArr containsObject:@(lmonth)]) {
                            yearIndex = [self.yearArr indexOfObject:@(fyear)];
                            monthIndex = [self.monthArr indexOfObject:@(fmonth)];
                            startStr = [NSString stringWithFormat:@"%ld-%02ld",fyear,fmonth];
                            endStr = [NSString stringWithFormat:@"%ld-%02ld",lyear,lmonth];
                        }
                    }
                }
            } else {
                NSArray *selectArr = [selectTime componentsSeparatedByString:@"-"];
                if (selectArr.count == 2) {
                    NSInteger year = [selectArr.firstObject integerValue];
                    NSInteger month = [selectArr.lastObject integerValue];
                    if ([self.yearArr containsObject:@(year)] && [self.monthArr containsObject:@(month)]) {
                        yearIndex = [self.yearArr indexOfObject:@(year)];
                        monthIndex = [self.monthArr indexOfObject:@(month)];
                        startStr = [NSString stringWithFormat:@"%ld-%02ld",year,month];
                    }
                }
            }
        }
        [pickerView selectRow:yearIndex inComponent:0 animated:NO];
        [pickerView selectRow:monthIndex inComponent:1 animated:NO];
        
        UIView *botLine = [[UIView alloc] init];
        botLine.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:botLine];
        
        UIView *verLine = [[UIView alloc] init];
        verLine.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:verLine];
        
        UIButton *cancleBtn = [[UIButton alloc] init];
        [cancleBtn setTitle:ADLString(@"cancle") forState:UIControlStateNormal];
        [cancleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:cancleBtn];
        
        UIButton *confirmBtn = [[UIButton alloc] init];
        [confirmBtn setTitle:ADLString(@"confirm") forState:UIControlStateNormal];
        [confirmBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:confirmBtn];
        
        CGFloat panelH = 250;
        if (self.period) {
            panelH = 319;
            panelView.frame = CGRectMake((SCREEN_WIDTH-260)/2, SCREEN_HEIGHT, 260, 319);
            
            UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 130, 40)];
            [startBtn setTitle:@"开始时间" forState:UIControlStateNormal];
            [startBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            [startBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
            startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [startBtn addTarget:self action:@selector(clickBeginBtn:) forControlEvents:UIControlEventTouchUpInside];
            startBtn.selected = YES;
            [panelView addSubview:startBtn];
            self.startBtn = startBtn;
            
            UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 40, 130, 40)];
            [endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
            [endBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
            [endBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
            endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [endBtn addTarget:self action:@selector(clickEndBtn:) forControlEvents:UIControlEventTouchUpInside];
            [panelView addSubview:endBtn];
            self.endBtn = endBtn;
            
            UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(29, 79, 72, 2)];
            indicatorView.backgroundColor = APP_COLOR;
            indicatorView.layer.cornerRadius = 1;
            [panelView addSubview:indicatorView];
            self.indicatorView = indicatorView;
            
            topLine.frame = CGRectMake(0, 80, 260, 0.5);
            pickerView.frame = CGRectMake(30, 85, 200, 139);
            
            UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 229, 80, 30)];
            startLab.font = [UIFont systemFontOfSize:13];
            startLab.textAlignment = NSTextAlignmentCenter;
            startLab.layer.borderColor = APP_COLOR.CGColor;
            startLab.layer.borderWidth = 0.5;
            startLab.textColor = APP_COLOR;
            startLab.text = startStr;
            [panelView addSubview:startLab];
            self.startLab = startLab;
            
            UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 229, 40, 30)];
            bottomLab.font = [UIFont systemFontOfSize:13];
            bottomLab.textAlignment = NSTextAlignmentCenter;
            bottomLab.textColor = APP_COLOR;
            bottomLab.text = @"至";
            [panelView addSubview:bottomLab];
            
            UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 229, 80, 30)];
            endLab.font = [UIFont systemFontOfSize:13];
            endLab.textAlignment = NSTextAlignmentCenter;
            endLab.layer.borderColor = APP_COLOR.CGColor;
            endLab.layer.borderWidth = 0.5;
            endLab.textColor = APP_COLOR;
            endLab.text = endStr;
            [panelView addSubview:endLab];
            self.endLab = endLab;
            
            botLine.frame = CGRectMake(0, 269, 260, 0.5);
            verLine.frame = CGRectMake(130, 269, 0.5, 50);
            cancleBtn.frame = CGRectMake(0, 269, 130, 50);
            confirmBtn.frame = CGRectMake(130, 269, 130, 50);
        } else {
            panelView.frame = CGRectMake((SCREEN_WIDTH-260)/2, SCREEN_HEIGHT, 260, 250);
            topLine.frame = CGRectMake(0, 51, 260, 0.5);
            pickerView.frame = CGRectMake(30, 56, 200, 139);
            botLine.frame = CGRectMake(0, 200, 260, 0.5);
            verLine.frame = CGRectMake(130, 200, 0.5, 50);
            cancleBtn.frame = CGRectMake(0, 200, 130, 50);
            confirmBtn.frame = CGRectMake(130, 200, 130, 50);
        }
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.5;
            panelView.frame = CGRectMake((SCREEN_WIDTH-260)/2, (SCREEN_HEIGHT-panelH)/2, 260, panelH);
        }];
    }
    return self;
}

#pragma mark ------ UIPickerView Delegate ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArr.count;
    } else {
        return 12;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLab = [[UILabel alloc] init];
    pickerLab.textAlignment = NSTextAlignmentCenter;
    pickerLab.font = [UIFont systemFontOfSize:15];
    pickerLab.textColor = [UIColor blackColor];
    if (component == 0) {
        pickerLab.text = [NSString stringWithFormat:@"%@年",self.yearArr[row]];
    } else {
        pickerLab.text = [NSString stringWithFormat:@"%@月",self.monthArr[row]];
    }
    return pickerLab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.period) {
        NSInteger year = [self.yearArr[[self.pickerView selectedRowInComponent:0]] integerValue];
        NSInteger month = [self.monthArr[[self.pickerView selectedRowInComponent:1]] integerValue];
        if (self.startBtn.selected) {
            self.startLab.text = [NSString stringWithFormat:@"%ld-%02ld",year,month];
        } else {
            self.endLab.text = [NSString stringWithFormat:@"%ld-%02ld",year,month];
        }
    }
}

#pragma mark ------ 开始 ------
- (void)clickBeginBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.endBtn.selected = NO;
        NSInteger year = [[self.startLab.text substringToIndex:4] integerValue];
        NSInteger month = [[self.startLab.text substringWithRange:NSMakeRange(5, 2)] integerValue];
        NSInteger yearIndex = [self.yearArr indexOfObject:@(year)];
        NSInteger monthIndex = [self.monthArr indexOfObject:@(month)];
        
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(29, 79, 72, 2);
        }];
    }
}

#pragma mark ------ 结束 ------
- (void)clickEndBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.startBtn.selected = NO;
        if (self.endLab.text.length > 0) {
            NSInteger year = [[self.endLab.text substringToIndex:4] integerValue];
            NSInteger month = [[self.endLab.text substringWithRange:NSMakeRange(5, 2)] integerValue];
            NSInteger yearIndex = [self.yearArr indexOfObject:@(year)];
            NSInteger monthIndex = [self.monthArr indexOfObject:@(month)];
            
            [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
            [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
        } else {
            self.endLab.text = self.startLab.text;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(159, 79, 72, 2);
        }];
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
    if (self.period) {
        if (self.endLab.text.length == 0) {
            [ADLToast showBottomMessage:@"请选择结束时间"];
        } else {
            NSInteger sYear = [[self.startLab.text substringToIndex:4] integerValue];
            NSInteger sMonth = [[self.startLab.text substringWithRange:NSMakeRange(5, 2)] integerValue];
            NSInteger eYear = [[self.endLab.text substringToIndex:4] integerValue];
            NSInteger eMonth = [[self.endLab.text substringWithRange:NSMakeRange(5, 2)] integerValue];
            
            BOOL state = YES;
            if (sYear > eYear) {
                state = NO;
            } else {
                if (sMonth > eMonth) {
                    state = NO;
                }
            }
            
            if (state) {
                if (self.finish) {
                    self.finish([NSString stringWithFormat:@"%@,%@",self.startLab.text,self.endLab.text]);
                }
                [self clickCancleBtn];
            } else {
                [ADLToast showBottomMessage:@"结束时间应大于开始时间"];
            }
        }
    } else {
        if (self.finish) {
            NSInteger year = [self.yearArr[[self.pickerView selectedRowInComponent:0]] integerValue];
            NSInteger month = [self.monthArr[[self.pickerView selectedRowInComponent:1]] integerValue];
            self.finish([NSString stringWithFormat:@"%ld-%02ld",year,month]);
        }
        [self clickCancleBtn];
    }
}

@end
