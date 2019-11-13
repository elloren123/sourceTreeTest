//
//  ADLSelectDateView.m
//  lockboss
//
//  Created by adel on 2019/6/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLSelectDateView.h"
#import "ADLGlobalDefine.h"
#import "ADLToast.h"

@interface ADLSelectDateView ()<UIPickerViewDelegate>
@property (nonatomic, copy) void (^finish) (NSString *dateStr);
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *endLab;

@property (nonatomic, strong) NSMutableArray *yearArr;
@property (nonatomic, strong) NSArray *oneArr;
@property (nonatomic, assign) BOOL posterior;
@property (nonatomic, assign) BOOL longterm;
@property (nonatomic, assign) BOOL period;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@end

@implementation ADLSelectDateView

+ (instancetype)showWithTitle:(NSString *)title period:(BOOL)period longterm:(BOOL)longterm posterior:(BOOL)posterior finish:(void (^)(NSString *))finish {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title period:period longterm:longterm posterior:posterior finish:finish];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title period:(BOOL)period longterm:(BOOL)longterm posterior:(BOOL)posterior finish:(void (^)(NSString *))finish {
    if (self = [super initWithFrame:frame]) {
        self.period = period;
        self.finish = finish;
        self.longterm = longterm;
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
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.text = title.length > 0 ? title : ADLString(@"select_time");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = COLOR_333333;
    [panelView addSubview:titleLab];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = COLOR_E5E5E5;
    [panelView addSubview:topLine];
    
    self.yearArr = [[NSMutableArray alloc] init];
    self.oneArr = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13),@(14),@(15),@(16),
                    @(17),@(18),@(19),@(20),@(21),@(22),@(23),@(24),@(25),@(26),@(27),@(28),@(29),@(30),@(31)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger startYear = components.year-100;
    for (int i = 0; i < 199; i++) {
        [self.yearArr addObject:[NSString stringWithFormat:@"%ld年",startYear+i]];
    }
    
    self.year = components.year;
    self.month = components.month;
    self.day = components.day;
    NSInteger yearIndex = [self.yearArr indexOfObject:[NSString stringWithFormat:@"%ld年",components.year]];
    NSInteger monthIndex = [self.oneArr indexOfObject:@(components.month)];
    NSInteger dayIndex = [self.oneArr indexOfObject:@(components.day)];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [panelView addSubview:pickerView];
    pickerView.delegate = self;
    self.pickerView = pickerView;
    
    [pickerView selectRow:yearIndex inComponent:0 animated:NO];
    [pickerView selectRow:monthIndex inComponent:1 animated:NO];
    [pickerView selectRow:dayIndex inComponent:2 animated:NO];
    
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
    
    CGFloat panelH = 260;
    CGFloat panelW = 280;
    if (self.period) {
        panelH = 335;
        panelView.frame = CGRectMake((SCREEN_WIDTH-panelW)/2, SCREEN_HEIGHT, panelW, panelH);
        titleLab.frame = CGRectMake(0, 0, panelW, 50);
        
        UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, panelW/2, 40)];
        [startBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        [startBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [startBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [startBtn addTarget:self action:@selector(clickBeginBtn:) forControlEvents:UIControlEventTouchUpInside];
        startBtn.selected = YES;
        [panelView addSubview:startBtn];
        self.startBtn = startBtn;
        
        UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(panelW/2, 40, panelW/2, 40)];
        [endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        [endBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        [endBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
        endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [endBtn addTarget:self action:@selector(clickEndBtn:) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:endBtn];
        self.endBtn = endBtn;
        
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(panelW/4-36, 79, 72, 2)];
        indicatorView.backgroundColor = APP_COLOR;
        indicatorView.layer.cornerRadius = 1;
        [panelView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        topLine.frame = CGRectMake(0, 80, panelW, 0.5);
        pickerView.frame = CGRectMake(30, 90, panelW-60, 139);
        
        UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 239, panelW/2-40, 34)];
        startLab.font = [UIFont systemFontOfSize:14];
        startLab.textAlignment = NSTextAlignmentCenter;
        startLab.layer.borderColor = APP_COLOR.CGColor;
        startLab.layer.borderWidth = 0.5;
        startLab.textColor = APP_COLOR;
        startLab.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",components.year,components.month,components.day];
        [panelView addSubview:startLab];
        self.startLab = startLab;
        
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(panelW/2-20, 239, 40, 34)];
        bottomLab.font = [UIFont systemFontOfSize:14];
        bottomLab.textAlignment = NSTextAlignmentCenter;
        bottomLab.textColor = APP_COLOR;
        bottomLab.text = @"至";
        [panelView addSubview:bottomLab];
        
        UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(panelW/2+20, 239, panelW/2-40, 34)];
        endLab.font = [UIFont systemFontOfSize:14];
        endLab.textAlignment = NSTextAlignmentCenter;
        endLab.layer.borderColor = APP_COLOR.CGColor;
        endLab.layer.borderWidth = 0.5;
        endLab.textColor = APP_COLOR;
        [panelView addSubview:endLab];
        self.endLab = endLab;
        
        botLine.frame = CGRectMake(0, 285, panelW, 0.5);
        verLine.frame = CGRectMake(panelW/2, 285, 0.5, 50);
        cancleBtn.frame = CGRectMake(0, 285, panelW/2, 50);
        confirmBtn.frame = CGRectMake(panelW/2, 285, panelW/2, 50);
        
    } else {
        panelView.frame = CGRectMake((SCREEN_WIDTH-panelW)/2, SCREEN_HEIGHT, panelW, panelH);
        titleLab.frame = CGRectMake(0, 0, panelW, 50);
        topLine.frame = CGRectMake(0, 51, panelW, 0.5);
        pickerView.frame = CGRectMake(30, 61, panelW-60, 139);
        botLine.frame = CGRectMake(0, 210, panelW, 0.5);
        verLine.frame = CGRectMake(panelW/2, 210, 0.5, 50);
        cancleBtn.frame = CGRectMake(0, 210, panelW/2, 50);
        confirmBtn.frame = CGRectMake(panelW/2, 210, panelW/2, 50);
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.5;
        panelView.frame = CGRectMake((SCREEN_WIDTH-panelW)/2, (SCREEN_HEIGHT-panelH)/2, panelW, panelH);
    }];
}

#pragma mark ------ UIPickerView Delegate && DataSource ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArr.count;
    } else if (component == 1) {
        if (self.year == 0) {
            return 0;
        } else {
            return 12;
        }
    } else {
        if (self.year == 0) {
            return 0;
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
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLab = [[UILabel alloc] init];
    pickerLab.adjustsFontSizeToFitWidth = YES;
    pickerLab.textAlignment = NSTextAlignmentCenter;
    pickerLab.font = [UIFont systemFontOfSize:16];
    pickerLab.textColor = [UIColor blackColor];
    if (component == 0) {
        pickerLab.text = self.yearArr[row];
    } else if (component == 1) {
        pickerLab.text = [NSString stringWithFormat:@"%@月",self.oneArr[row]];
    } else {
        pickerLab.text = [NSString stringWithFormat:@"%@日",self.oneArr[row]];;
    }
    return pickerLab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.year = [self.yearArr[row] integerValue];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        if (self.year != 0) {
            self.month = [self.oneArr[[pickerView selectedRowInComponent:1]] integerValue];
        }
    }
    if (component == 1) {
        self.month = [self.oneArr[row] integerValue];
        [pickerView reloadComponent:2];
    }
    self.day = [self.oneArr[[pickerView selectedRowInComponent:2]] integerValue];
    if (self.period) {
        if (self.startBtn.selected) {
            self.startLab.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.year,self.month,self.day];
        } else {
            if (self.year == 0) {
                self.endLab.text = @"长期";
            } else {
                self.endLab.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.year,self.month,self.day];
            }
        }
    }
}

#pragma mark ------ 开始 ------
- (void)clickBeginBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.endBtn.selected = NO;
        if (self.longterm) {
            [self.yearArr removeLastObject];
        }
        NSArray *startArr = [self.startLab.text componentsSeparatedByString:@"-"];
        NSInteger yearIndex = [self.yearArr indexOfObject:[NSString stringWithFormat:@"%ld年",[startArr[0] integerValue]]];
        NSInteger monthIndex = [self.oneArr indexOfObject:@([startArr[1] integerValue])];
        NSInteger dayIndex = [self.oneArr indexOfObject:@([startArr[2] integerValue])];
        self.year = [startArr[0] integerValue];
        self.month = [startArr[1] integerValue];
        self.day = [startArr[2] integerValue];
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(34, 79, 72, 2);
        }];
    }
}

#pragma mark ------ 结束 ------
- (void)clickEndBtn:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.startBtn.selected = NO;
        if (self.longterm) {
            [self.yearArr addObject:@"长期"];
        }
        
        if (self.endLab.text.length > 0) {
            if ([self.endLab.text isEqualToString:@"长期"]) {
                self.year = 0;
                [self.pickerView reloadAllComponents];
                [self.pickerView selectRow:self.yearArr.count-1 inComponent:0 animated:YES];
            } else {
                NSArray *endArr = [self.endLab.text componentsSeparatedByString:@"-"];
                NSInteger yearIndex = [self.yearArr indexOfObject:[NSString stringWithFormat:@"%ld年",[endArr[0] integerValue]]];
                NSInteger monthIndex = [self.oneArr indexOfObject:@([endArr[1] integerValue])];
                NSInteger dayIndex = [self.oneArr indexOfObject:@([endArr[2] integerValue])];
                self.year = [endArr[0] integerValue];
                self.month = [endArr[1] integerValue];
                self.day = [endArr[2] integerValue];
                
                [self.pickerView reloadAllComponents];
                [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
                [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
                [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
            }
        } else {
            [self.pickerView reloadComponent:0];
            self.endLab.text = self.startLab.text;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(174, 79, 72, 2);
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
            if ([self.endLab.text isEqualToString:@"长期"]) {
                if (self.finish) {
                    self.finish([NSString stringWithFormat:@"%@,%@",self.startLab.text,self.endLab.text]);
                }
                [self clickCancleBtn];
            } else {
                BOOL goon = YES;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd";
                NSDate *startDate = [formatter dateFromString:self.startLab.text];
                NSDate *endDate = [formatter dateFromString:self.endLab.text];
                NSComparisonResult result = [startDate compare:endDate];
                if (result == NSOrderedAscending) {
                    if (self.posterior) {
                        NSComparisonResult cresult = [[NSDate date] compare:startDate];
                        if (cresult != NSOrderedAscending) {
                            [ADLToast showBottomMessage:@"开始时间应大于当前时间"];
                            goon = NO;
                        }
                    }
                } else {
                    [ADLToast showBottomMessage:@"结束时间应大于开始时间"];
                    goon = NO;
                }
                if (goon) {
                    if (self.finish) {
                        self.finish([NSString stringWithFormat:@"%@,%@",self.startLab.text,self.endLab.text]);
                    }
                    [self clickCancleBtn];
                }
            }
        }
    } else {
        BOOL keepon = YES;
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.year,self.month,self.day];
        if (self.posterior) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSDate *selectDate = [formatter dateFromString:dateStr];
            NSComparisonResult result = [[NSDate date] compare:selectDate];
            if (result != NSOrderedAscending) {
                keepon = NO;
                [ADLToast showBottomMessage:@"选择的时间应大于当前时间"];
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
