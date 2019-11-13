//
//  ADLTimeOrStamp.m
//  lockboss
//
//  Created by bailun91 on 2019/10/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLTimeOrStamp.h"

@implementation ADLTimeOrStamp

#pragma mark --- 获取星期日期
//获取星期
+ (NSString *)getWeekDayFordate:(NSTimeInterval)data {
    NSArray *weekday = [NSArray arrayWithObjects:[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

#pragma mark --- 获取当前时间戳 (字符串)
+ (NSString *)getCurrentTimestampString {
    NSDate *date = [NSDate date];//现在时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"当前时间戳timeSp: %@",timeSp);//时间戳的值
    
    return timeSp;
}
#pragma mark --- 获取当前时间戳 (整数)
+ (NSInteger)getCurrentTimestamp {
    NSDate *date = [NSDate date];//现在时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"当前时间戳timeSp.integerValue: %zd",timeSp.integerValue);//时间戳的值
    
    return timeSp.integerValue;
}
#pragma mark --- 获取当前时间
+ (NSString *)getCurrentTime:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beiji"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    
    return nowtimeStr;
}

#pragma mark ---- 将时间戳转换成时间
+ (NSString *)getTimeFromTimestamp:(double)time format:(NSString *)format {
    
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    NSLog(@"时间timeSp : %@",timeStr);//时间
    
    return timeStr;
}
#pragma mark - 将时间转化成时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //(@"YYYY-MM-dd HH:mm:ss")设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    //将字符串按formatter转成nsdate
    NSDate *date = [formatter dateFromString:formatTime];
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
}

#pragma mark ------ 比较当前时间和传入时间的大小 ------
+ (NSInteger)compareDateseconds:(NSString*)aDate{
    
    
    
    aDate = [self getDataTime:aDate];
    ADLLog(@"end---%@",aDate);
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSInteger aa=0;
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    dta = [dateformater dateFromString:aDate];
    ADLLog(@"now=== %@",dta);
    NSComparisonResult result = [dta compare:date];

    if (result==NSOrderedSame){
        aa=0;
    }else if (result==NSOrderedAscending){
        aa=1;
    }else if (result==NSOrderedDescending){
        aa=-1;
    }
    return aa;
}

+(NSString *)getDataTime:(NSString *)time{
    NSTimeInterval interval    =[time doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

//比较两个日期大小 0 日期相等 1大 -1小 年-月-日-时-分
+ (BOOL)compareDate:(NSString*)start stop:(NSString *)stop
{
    
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    
    
    dta = [dateformater dateFromString:start];
    dta = [dateformater dateFromString:stop];
    NSComparisonResult result = [start compare:stop];
    
    
    if (result==NSOrderedSame)
    {
       
        [ADLToast showMessage:ADLString(@"结束时间不能等于开始时间")];
     
        //        相等
        return NO;
    }else if (result==NSOrderedAscending)
    {
        //[ADLPromptMwssage showErrorMessage:KLocalizableStr(@"结束时间不能小于开始时间") inView:[UIApplication sharedApplication].keyWindow time:2];
        //aDate比date大
        return YES;
    }else if (result==NSOrderedDescending)
    {
        [ADLToast showMessage:ADLString(@"结束时间不能小于开始时间")];
        //aDate比date小
        return NO;
        
    }
    return YES;
    
}


@end
