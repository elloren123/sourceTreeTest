
//
//  ADLServicePickerView.m
//  lockboss
//
//  Created by adel on 2019/6/18.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLServicePickerView.h"
#import "ADLGlobalDefine.h"

@interface ADLServicePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, copy) void (^finishBlock) (NSString *dateStr, NSInteger year);
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *currArr;
@property (nonatomic, strong) NSArray *hourArr;
@property (nonatomic, strong) NSArray *dayArr;
@property (nonatomic, assign) NSInteger currentYear;
@end

@implementation ADLServicePickerView

+ (instancetype)showPickerWithFinishBlock:(void (^)(NSString *, NSInteger))finishBlock {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds finishBlock:finishBlock];
}

- (instancetype)initWithFrame:(CGRect)frame finishBlock:(void(^)(NSString *, NSInteger))finishBlock {
    if (self = [super initWithFrame:frame]) {
        self.finishBlock = finishBlock;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *coverView = [[UIView alloc] initWithFrame:window.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        [self addSubview:coverView];
        self.coverView = coverView;
        
        UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-140, SCREEN_HEIGHT, 280, 251)];
        panelView.backgroundColor = [UIColor whiteColor];
        panelView.layer.cornerRadius = 5;
        panelView.clipsToBounds = YES;
        [self addSubview:panelView];
        self.panelView = panelView;
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        titLab.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.textColor = COLOR_333333;
        titLab.text = @"上门时间";
        [panelView addSubview:titLab];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 280, 0.5)];
        topLine.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:topLine];
        
        self.hourArr = @[@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30"];
        self.currArr = [[NSMutableArray alloc] init];
        [self getRemainingDays];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 56, 220, 139)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [panelView addSubview:pickerView];
        self.pickerView = pickerView;
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancleBtn.frame = CGRectMake(0, 201, 140, 50);
        [cancleBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:cancleBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(140, 201, 140, 50);
        [confirmBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [panelView addSubview:confirmBtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 201, 280, 0.5)];
        line1.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(140, 201, 0.5, 50)];
        line2.backgroundColor = COLOR_E5E5E5;
        [panelView addSubview:line2];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 104, 280, 0.5)];
        line3.backgroundColor = COLOR_D3D3D3;
        [panelView addSubview:line3];
        
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 146, 280, 0.5)];
        line4.backgroundColor = COLOR_D3D3D3;
        [panelView addSubview:line4];
        
        [window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            coverView.alpha = 0.5;
            panelView.frame = CGRectMake(SCREEN_WIDTH/2-140, SCREEN_HEIGHT/2-125, 280, 251);
        }];
    }
    return self;
}

#pragma mark ------ UIPickerView Delegate && DataSource ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dayArr.count;
    } else {
        NSInteger currentRow = [pickerView selectedRowInComponent:0];
        if (currentRow == 0) {
            return 0;
        } else if (currentRow == 1) {
            return self.currArr.count;
        } else {
            return self.hourArr.count;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:16];
        pickerLabel.textColor = [UIColor blackColor];
    }
    if (component == 0) {
        pickerLabel.text = self.dayArr[row];
    } else {
        if ([pickerView selectedRowInComponent:0] == 1) {
            pickerLabel.text = self.currArr[row];
        } else {
            pickerLabel.text = self.hourArr[row];
        }
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadComponent:1];
}

#pragma mark ------ 获取剩余天数和当天可选时间 ------
- (void)getRemainingDays {
    NSMutableArray *days = [[NSMutableArray alloc] initWithObjects:@"加急", nil];
    
    NSDate *startDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm";
    NSString *dateStr = [formatter stringFromDate:startDate];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    int currentYear = [dateArr.firstObject intValue];
    
    if ([dateArr[1] intValue] == 12 && [dateArr[2] intValue] == 31 && [dateArr[3] intValue] > 21 && [dateArr[4] intValue] > 29) {
        currentYear = currentYear+1;
        startDate = [formatter dateFromString:[NSString stringWithFormat:@"%d-01-01-00-00",currentYear]];
    }
    
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%d-12-31-23-59",currentYear]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSComparisonResult result = [startDate compare:endDate];
    NSDateComponents *components;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM月dd日";
    while (result != NSOrderedDescending) {
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:startDate];
        [days addObject:[dateFormatter stringFromDate:startDate]];
        [components setDay:([components day]+1)];
        startDate = [calendar dateFromComponents:components];
        result = [startDate compare:endDate];
    }
    
    if ([dateArr[3] intValue] > 21 && [dateArr[4] intValue] > 29 && [dateArr.firstObject intValue] == currentYear) {
        [days removeObjectAtIndex:1];
    }
    
    int hour = [dateArr[3] intValue];
    int minute = [dateArr[4] intValue];
    if (minute < 30) {
        if (hour > 22) {
            hour = hour-23;
        }
        NSInteger index = [self.hourArr indexOfObject:[NSString stringWithFormat:@"%02d:30",hour+1]];
        for (NSInteger i = index; i < 48; i++) {
            [self.currArr addObject:self.hourArr[i]];
        }
    } else {
        if (hour > 21) {
            hour = hour-23;
        }
        NSInteger index = [self.hourArr indexOfObject:[NSString stringWithFormat:@"%02d:00",hour+1]];
        for (NSInteger i = index; i < 48; i++) {
            [self.currArr addObject:self.hourArr[i]];
        }
    }
    self.currentYear = currentYear;
    self.dayArr = [NSArray arrayWithArray:days];
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
        self.panelView.frame = CGRectMake(SCREEN_WIDTH/2-140, SCREEN_HEIGHT, 280, 251);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    NSInteger selRow = [self.pickerView selectedRowInComponent:0];
    NSString *dateStr = nil;
    if (selRow == 0) {
        dateStr = @"加急";
    } else if (selRow == 1) {
        dateStr = [NSString stringWithFormat:@"%@ %@",self.dayArr[1],self.currArr[[self.pickerView selectedRowInComponent:1]]];
    } else {
        dateStr = [NSString stringWithFormat:@"%@ %@",self.dayArr[selRow],self.hourArr[[self.pickerView selectedRowInComponent:1]]];
    }
    if (self.finishBlock) {
        self.finishBlock(dateStr, self.currentYear);
    }
    [self clickCancleBtn];
}

@end
