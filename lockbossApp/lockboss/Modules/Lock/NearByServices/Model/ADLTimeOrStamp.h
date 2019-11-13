//
//  ADLTimeOrStamp.h
//  lockboss
//
//  Created by bailun91 on 2019/10/9.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADLTimeOrStamp : NSObject

#pragma mark --- 获取星期日期
+ (NSString *)getWeekDayFordate:(NSTimeInterval)data;

#pragma mark --- 获取当前时间戳 (字符串类型)
+ (NSString *)getCurrentTimestampString;

#pragma mark --- 获取当前时间戳 (整数类型)
+ (NSInteger)getCurrentTimestamp;

#pragma mark --- 获取当前时间
+ (NSString *)getCurrentTime:(NSString *)format;

#pragma mark ---- 将时间戳转换成时间
+ (NSString *)getTimeFromTimestamp:(double)time format:(NSString *)format;

#pragma mark - 将时间转化成时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

/**
 *比较当前时间和传入时间的大小
 *aDate  传入时间(秒数)
 *return 0相等  1传入时间大于当前时间  -1传入时间小于当前时间
 */
+ (NSInteger)compareDateseconds:(NSString*)aDate;

//比较两个日期大小 0 日期相等 1大 -1小 年-月-日-时-分
+ (BOOL)compareDate:(NSString*)start stop:(NSString *)stop;
@end

NS_ASSUME_NONNULL_END
