//
//  ADLUtils.m
//  lockboss
//
//  Created by adel on 2019/3/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLUtils.h"
#import <WebKit/WebKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>

@implementation ADLUtils

#pragma mark ------ 获取定位权限状态 ------
+ (ADLLocationStatus)getLocationStatus {
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
            return ADLLocationStatusDenied;
        } else {
            return ADLLocationStatusAllow;
        }
    } else {
        return ADLLocationStatusUnavailable;
    }
}

#pragma mark ------ 获取相机权限状态 ------
+ (ADLCameraStatus)getCameraStatus {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            return ADLCameraStatusDenied;
        } else {
            return ADLCameraStatusAllow;
        }
    } else {
        return ADLCameraStatusUnavailable;
    }
}

#pragma mark ------ 压缩图片 ------
+ (NSData *)compressImageQuality:(UIImage *)image maxLength:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max+min)/2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength*0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

#pragma mark ------ 处理密文重新输入清空和明密文切换光标位置不对问题 ------
+ (void)dealWithSecureEntryWithTextField:(UITextField *)textField {
    NSString *str = textField.text;
    textField.text = @"";
    if (textField.secureTextEntry) {
        [textField insertText:str];
    }
    textField.text = str;
}

#pragma mark ------ 邮箱验证 ------
+ (BOOL)verifyEmailAddress:(NSString *)email {
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:email];
}

#pragma mark ------ 检测是否是纯数字 ------
+ (BOOL)isPureInt:(NSString *)string {
    if (string.length == 0) {
        return NO;
    } else {
        NSString *regex = @"[0-9]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [predicate evaluateWithObject:string];
    }
}

#pragma mark ------ 限制输入长度 ------
+ (BOOL)limitedTextField:(UITextField *)textField replacementString:(NSString *)string maxLength:(NSInteger)length {
    if (![string isEqualToString:@""]) {
        NSInteger selectLenght = [textField offsetFromPosition:textField.selectedTextRange.start toPosition:textField.selectedTextRange.end];
        NSInteger markedLenght = [textField offsetFromPosition:textField.markedTextRange.start toPosition:textField.markedTextRange.end];
        if (string.length > 1) {
            NSInteger remainder = length-textField.text.length+selectLenght+markedLenght;
            NSString *subStr;
            if (remainder < string.length) {
                subStr = [string substringToIndex:remainder];
            } else {
                subStr = string;
            }
            if (markedLenght > 0) {
                [textField replaceRange:textField.markedTextRange withText:subStr];
            } else {
                [textField replaceRange:textField.selectedTextRange withText:subStr];
            }
            return NO;
        } else {
            if (selectLenght == 0 && textField.text.length-markedLenght == length) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark ------ 数字输入 ------
+ (BOOL)numberTextField:(UITextField *)textField replacementString:(NSString *)string maxLength:(NSInteger)length firstZero:(BOOL)zero {
    if ([string isEqualToString:@""]) {
        if (!zero) {
            if (textField.text.length > 1) {
                NSInteger location = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
                NSString *second = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (location == 1 && [second isEqualToString:@"0"]) {
                    return NO;
                }
            }
        }
    } else {
        if (length < 1) length = NSIntegerMax;
        NSInteger selectLenght = [textField offsetFromPosition:textField.selectedTextRange.start toPosition:textField.selectedTextRange.end];
        if (string.length > 1) {
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([self isPureInt:string]) {
                NSInteger remainder = length-textField.text.length+selectLenght;
                NSString *subStr;
                if (remainder < string.length) {
                    subStr = [string substringToIndex:remainder];
                } else {
                    subStr = string;
                }
                if (zero) {
                    [textField replaceRange:textField.selectedTextRange withText:subStr];
                } else {
                    NSInteger loc = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
                    if (loc != 0 || ![subStr hasPrefix:@"0"]) {
                        [textField replaceRange:textField.selectedTextRange withText:subStr];
                    }
                }
            }
            return NO;
        } else {
            if (![self isPureInt:string]) {
                return NO;
            }
            if (selectLenght == 0 && textField.text.length == length) {
                return NO;
            }
            if (!zero) {
                NSInteger loca = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
                if (loca == 0 && [string isEqualToString:@"0"]) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark ------ 电话输入 ------
+ (BOOL)phoneTextField:(UITextField *)textField replacementString:(NSString *)string {
    if (![string isEqualToString:@""]) {
        if (string.length > 1) {//粘贴的
            if ([string hasPrefix:@"+86"]) {
                string = [string substringFromIndex:3];
            }
            //一般来说()是成对出现的，而且只有一对，(一般在首位，）后面就是对应的电话号码
            if ([string containsString:@")"]) {
                string = [string substringFromIndex:[string rangeOfString:@")"].location+1];
            }
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"+" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([self isPureInt:string]) {
                [textField replaceRange:textField.selectedTextRange withText:string];
            }
            return NO;
        } else {//输入的
            if ([self isPureInt:string]) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark ------ 获取当前显示的控制器 ------
+ (UIViewController *)getCurrentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

#pragma mark ------ 保存数据到本地 ------
+ (BOOL)saveObject:(id)object fileName:(NSString *)fileName permanent:(BOOL)permanent {
    if ([object isKindOfClass:[NSArray class]] ||
        [object isKindOfClass:[NSData class]] ||
        [object isKindOfClass:[NSDictionary class]] ||
        [object isKindOfClass:[NSString class]]) {
        
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *cachePath = [docPath stringByAppendingPathComponent:@"myCache"];
        if (permanent) cachePath = [docPath stringByAppendingPathComponent:@"pmCache"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        return [object writeToFile:filePath atomically:YES];
    } else {
        return NO;
    }
}

#pragma mark ------ 删除本地保存的数据 ------
+ (void)removeObjectWithFileName:(NSString *)fileName permanent:(BOOL)permanent {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/myCache/%@",docPath,fileName];
    if (permanent) filePath = [NSString stringWithFormat:@"%@/pmCache/%@",docPath,fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

#pragma mark ------ 获取本地保存的文件路径 ------
+ (NSString *)filePathWithName:(NSString *)fileName permanent:(BOOL)permanent {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/myCache/%@",docPath,fileName];
    if (permanent) filePath = [NSString stringWithFormat:@"%@/pmCache/%@",docPath,fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    } else {
        return nil;
    }
}

#pragma mark ------ 删除所有本地保存的数据 ------
+ (void)removeAllCache {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [docPath stringByAppendingPathComponent:@"myCache"];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark ------ 字典数组转简单数组 ------
+ (NSMutableArray *)dictArrayToArray:(NSArray *)array key:(NSString *)key {
    if (array == nil) return nil;
    NSMutableArray *contentArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [contentArr addObject:dict[key]];
    }
    return contentArr;
}

#pragma mark ------ 根据地区ID查询父ID、地址 ------
+ (AddressInfo)queryAddressWithDataArr:(NSArray *)dataArr areaId:(NSString *)areaId {
    AddressInfo info;
    if ([areaId isEqualToString:@"1046255"]) {
        info.cityId = areaId;
        info.address = @"台湾";
        return info;
    }
    for (NSDictionary *provDict in dataArr) {
        for (NSDictionary *cityDict in provDict[@"areaTemps"]) {
            if ([cityDict[@"areaTemps"] count] > 0) {
                for (NSDictionary *areaDict in cityDict[@"areaTemps"]) {
                    if ([areaDict[@"areaTemps"] count] > 0) {
                        for (NSDictionary *streetDict in areaDict[@"areaTemps"]) {
                            if ([streetDict[@"areaId"] isEqualToString:areaId]) {
                                NSString *address = provDict[@"areaName"];
                                if (![cityDict[@"areaName"] isEqualToString:provDict[@"areaName"]]) {
                                    address = [NSString stringWithFormat:@"%@%@",address,cityDict[@"areaName"]];
                                }
                                if (![areaDict[@"areaName"] isEqualToString:cityDict[@"areaName"]]) {
                                    address = [NSString stringWithFormat:@"%@%@",address,areaDict[@"areaName"]];
                                }
                                if (![streetDict[@"areaName"] isEqualToString:areaDict[@"areaName"]]) {
                                    address = [NSString stringWithFormat:@"%@%@",address,streetDict[@"areaName"]];
                                }
                                info.cityId = [cityDict[@"areaId"] stringValue];
                                info.address = address;
                                return info;
                            }
                        }
                    } else {
                        if ([[areaDict[@"areaId"] stringValue] isEqualToString:areaId]) {
                            NSString *addr = provDict[@"areaName"];
                            if (![cityDict[@"areaName"] isEqualToString:provDict[@"areaName"]]) {
                                addr = [NSString stringWithFormat:@"%@%@",addr,cityDict[@"areaName"]];
                            }
                            if (![areaDict[@"areaName"] isEqualToString:cityDict[@"areaName"]]) {
                                addr = [NSString stringWithFormat:@"%@%@",addr,areaDict[@"areaName"]];
                            }
                            info.cityId = [cityDict[@"areaId"] stringValue];
                            info.address = addr;
                            return info;
                        }
                    }
                }
            } else {
                if ([[cityDict[@"areaId"] stringValue] isEqualToString:areaId]) {
                    info.cityId = areaId;
                    info.address = [NSString stringWithFormat:@"%@%@",provDict[@"areaName"],cityDict[@"areaName"]];
                    return info;
                }
            }
        }
    }
    info.cityId = @"";
    info.address = @"";
    return info;
}

#pragma mark ------ 处理字典数组里面空值 ------
+ (NSMutableArray *)dealwithNullDictArr:(NSArray *)arr {
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        NSArray *keyArr = [dict allKeys];
        NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < keyArr.count; i++) {
            id value = [dict valueForKey:keyArr[i]];
            if ([value isKindOfClass:[NSNull class]]) {
                value = @"";
            }
            [muDict setValue:value forKey:keyArr[i]];
        }
        [muArr addObject:muDict];
    }
    return muArr;
}

#pragma mark ------ 计算字符串字符长度 ------
+ (NSInteger)calculateCharacterLength:(NSString *)str {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [str dataUsingEncoding:enc];
    return [data length];
}

#pragma mark ------ 计算文字宽高 ------
+ (CGSize)calculateString:(NSString *)string rectSize:(CGSize)rectSize fontSize:(CGFloat)fontSize {
    if (string.length > 0) {
        return [string boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    } else {
        return CGSizeZero;
    }
}

#pragma mark ------ 计算富文本宽高 ------
+ (CGSize)calculateAttributeString:(NSAttributedString *)attributeString rectSize:(CGSize)rectSize {
    if (attributeString.length > 0) {
        return [attributeString boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    } else {
        return CGSizeZero;
    }
}

#pragma mark ------ 创建WKWebView ------
+ (id)webViewWithFrame:(CGRect)frame scale:(BOOL)scale {
    NSString *scaleStr = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    
    if (scale) scaleStr = @"";
    NSMutableString *scriptStr = [NSMutableString stringWithString:scaleStr];
    [scriptStr appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [scriptStr appendString:@"document.documentElement.style.webkitUserSelect='none';"];
    if (!scale) [scriptStr appendString:@"javascript:document.body.style.padding=\"0pt 3pt\"; void 0"];
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:scriptStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:userScript];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.backgroundColor = [UIColor whiteColor];
    webView.allowsLinkPreview = NO;
    return webView;
}

#pragma mark ------ 获取n分钟后的时间戳 ------
+ (NSString *)timestampWithMinuteDelay:(NSInteger)minute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    if (minute > 0) {
        [components setMinute:([components minute]+minute)];
    }
    NSDate *date = [calendar dateFromComponents:components];
    return [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000];
}

#pragma mark ------ 获取n分钟后的时间 ------
+ (NSString *)dateWithMinuteDelay:(NSInteger)minute format:(NSString *)format {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    if (minute > 0) {
        [components setMinute:([components minute]+minute)];
    }
    NSDate *date = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (format) {
        formatter.dateFormat = format;
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [formatter stringFromDate:date];
}

#pragma mark ------ 获取n月后的时间 ------
+ (NSString *)dateWithMonthDelay:(NSInteger)month format:(NSString *)format {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    if (month > 0) {
        [components setMonth:([components month]+month)];
    }
    NSDate *date = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (format) {
        formatter.dateFormat = format;
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [formatter stringFromDate:date];
}

#pragma mark ------ 获取两个时间戳之间的秒数 ------
+ (NSInteger)getSecondFromStartTimestamp:(double)startTime endTimestamp:(double)endTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime/1000];
    NSDate *endDate = [NSDate date];
    if (endTime > 0) {
        endDate = [NSDate dateWithTimeIntervalSince1970:endTime/1000];
    }
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:startDate toDate:endDate options:0];
    return components.second;
}

#pragma mark ------ 时间转时间戳 ------
+ (NSString *)timestampWithDate:(NSDate *)date format:(NSString *)format {
    if (date == nil) {
        date = [NSDate date];
    }
    if (format) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = format;
        NSString *dateStr = [formatter stringFromDate:date];
        date = [formatter dateFromString:dateStr];
    }
    return [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000];
}

#pragma mark ------ 时间字符串转时间戳 ------
+ (NSString *)timestampWithDateStr:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:dateStr];
    return [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000];
}

#pragma mark ------ 时间戳转时间,精确到毫秒 ------
+ (NSString *)getDateFromTimestamp:(double)timestamp format:(NSString *)format {
    if (timestamp == 0) {
        return @"";
    } else {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        return [formatter stringFromDate:date];
    }
}

#pragma mark --- 获取当前时间       str格式 YYYY-MM-dd HH:mm:ss
+ (NSString *)getCurrentTime:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:str];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beiji"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    NSLog(@"当前时间nowtimeStr = %@", nowtimeStr);
    
    return nowtimeStr;
}
#pragma mark ---  传开始时间和结束时间 返回天数   YYYY-MM-dd HH:mm:ss
/**
 *返回天数
 *yyyy-MM-dd HH:mm:ss"
 *开始时间 beginDate
 *结束时间 endDate
 */
+ (NSInteger)fateDifferenceWithStartTime:(NSDate *)beginDate endTime:(NSDate *)endDate
{
    //创建日期格式化对象
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    
    //取两个日期对象的时间间隔：
    
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    
    
    int days=((int)time)/(3600*24);
    
    //int hours=((int)time)%(3600*24)/3600;
    
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return  days;
    
}
#pragma mark ------ 计算时间差 ------
+ (void)calculateDateInterval:(NSTimeInterval)timestamp includeDay:(BOOL)includeDay finish:(void (^)(NSString *day, NSString *hour, NSString *minute, NSString *second))finish {
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (includeDay) {
        NSCalendarUnit typeDay = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *componentsDay = [calendar components:typeDay fromDate:[NSDate date] toDate:endDate options:0];
        if (finish) {
            finish([NSString stringWithFormat:@"%02ld",componentsDay.day],[NSString stringWithFormat:@"%02ld",componentsDay.hour],[NSString stringWithFormat:@"%02ld",componentsDay.minute],[NSString stringWithFormat:@"%02ld",componentsDay.second]);
        }
    } else {
        NSCalendarUnit type = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:type fromDate:[NSDate date] toDate:endDate options:0];
        if (finish) {
            finish(@"00",[NSString stringWithFormat:@"%02ld",components.hour],[NSString stringWithFormat:@"%02ld",components.minute],[NSString stringWithFormat:@"%02ld",components.second]);
        }
    }
}

#pragma mark ------ 设置星级图片 ------
+ (UIImage *)getStarImageWithCount:(NSInteger)count {
    switch (count) {
        case 0:
            return [UIImage imageNamed:@"star_zero"];
            break;
        case 1:
            return [UIImage imageNamed:@"star_one"];
            break;
        case 2:
            return [UIImage imageNamed:@"star_two"];
            break;
        case 3:
            return [UIImage imageNamed:@"star_three"];
            break;
        case 4:
            return [UIImage imageNamed:@"star_four"];
            break;
        case 5:
            return [UIImage imageNamed:@"star_five"];
            break;
        default:
            return [UIImage imageNamed:@"star_five"];
            break;
    }
}

#pragma mark ------ 设置文件类型图片 ------
+ (UIImage *)getFileTypeImageWithType:(NSString *)type {
    if ([type containsString:@"jp"]) {
        return [UIImage imageNamed:@"datum_jpg"];
    } else if ([type containsString:@"png"]) {
        return [UIImage imageNamed:@"datum_png"];
    } else if ([type containsString:@"doc"]) {
        return [UIImage imageNamed:@"datum_word"];
    } else if ([type containsString:@"ppt"]) {
        return [UIImage imageNamed:@"datum_ppt"];
    } else if ([type containsString:@"xl"]) {
        return [UIImage imageNamed:@"datum_exl"];
    } else if ([type containsString:@"pdf"]) {
        return [UIImage imageNamed:@"datum_pdf"];
    } else if ([type containsString:@"mp4"] || [type containsString:@"mov"] || [type containsString:@"3gp"] || [type containsString:@"m4v"]) {
        return [UIImage imageNamed:@"datum_video"];
    } else {
        return [UIImage imageNamed:@"datum_file"];
    }
}

#pragma mark ------ sku提取属性 ------
+ (NSArray *)skuArrToAttributeArr:(NSArray *)skuArr {
    NSMutableArray *proArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in skuArr) {
        NSArray *perArr = dict[@"propertyVOList"];
        for (int i = 0; i < perArr.count; i++) {
            NSDictionary *perDict = perArr[i];
            if (proArr.count != perArr.count) {
                NSMutableArray *muArr = [[NSMutableArray alloc] init];
                NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
                NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
                [muDict setValue:perDict[@"propertyName"] forKey:@"propertyName"];
                [valueDict setValue:perDict[@"propertyValue"] forKey:@"propertyValue"];
                [valueDict setValue:perDict[@"id"] forKey:@"id"];
                [muArr addObject:valueDict];
                [muDict setValue:muArr forKey:@"values"];
                [proArr addObject:muDict];
            } else {
                for (NSMutableDictionary *muDict in proArr) {
                    if ([muDict[@"propertyName"] isEqualToString:perDict[@"propertyName"]]) {
                        NSMutableArray *muArr = muDict[@"values"];
                        NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
                        [valueDict setValue:perDict[@"propertyValue"] forKey:@"propertyValue"];
                        [valueDict setValue:perDict[@"id"] forKey:@"id"];
                        if (![muArr containsObject:valueDict]) {
                            [muArr addObject:valueDict];
                            break;
                        }
                    }
                }
            }
        }
    }
    return proArr;
}

#pragma mark ------ 当弹出键盘时，视图坐标转换 ------
+ (CGFloat)convertRectWithView:(UIView *)inputView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect inputRect = [inputView.superview convertRect:inputView.frame toView:window];
    CGFloat bottomH = window.bounds.size.height-inputRect.origin.y-inputRect.size.height;
    return bottomH;
}

#pragma mark ------ 获取当前显示的控制器 ------
- (UIViewController *)getCurrentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

#pragma mark ------ 保存数据 NSUserDefaults ------
+ (void)saveValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark ------ 取出数据 NSUserDefaults ------
+ (id)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

#pragma mark ------ 完全Copy对象 ------
+ (id)realDeepCopyWithObject:(id)object {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:object]];
}

#pragma mark ------ 是否有表情 ------
+ (BOOL)hasEmoji:(NSString *)string {
    __block BOOL result = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar high = [substring characterAtIndex: 0];
        if (0xD800 <= high && high <= 0xDBFF) {
            const unichar low = [substring characterAtIndex:1];
            const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
            if (0x1D000 <= codepoint && codepoint <= 0x1F9FF) {
                result = YES;
            }
        } else {
            if (0x2100 <= high && high <= 0x27BF){
                result = YES;
            }
        }
    }];
    return result;
}

#pragma mark ------ 获取视频信息 ------
+ (VideoInfo)getVideoInfoWithUrlStr:(NSString *)videoUrl orPathUrl:(NSURL *)localUrl {
    AVURLAsset *asset;
    if (videoUrl) {
        NSString *filename = [NSString stringWithFormat:@"%@.%@",[self md5Encrypt:videoUrl lower:YES],[videoUrl componentsSeparatedByString:@"."].lastObject];
        NSString *filePath = [self filePathWithName:filename permanent:NO];
        if (filePath) {
            asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        } else {
            asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrl] options:nil];
        }
    } else {
        asset = [[AVURLAsset alloc] initWithURL:localUrl options:nil];
    }
    NSUInteger totalSecond = asset.duration.value/asset.duration.timescale;
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    CGImageRef cgImage = [generator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    NSInteger minute = totalSecond/60;
    NSInteger second = totalSecond%60;
    
    VideoInfo videoInfo;
    videoInfo.thumbnail = thumbnail;
    videoInfo.duration = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    return videoInfo;
}

#pragma mark ------ 视频转MP4 ------
+ (void)convertVideoToMp4FromURL:(NSURL *)videoUrl finish:(void(^)(NSURL *fileUrl, NSString *fileName))finish {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *cachePath = [NSString stringWithFormat:@"%@/myCache",docPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:[cachePath stringByAppendingFormat:@"/%@.mp4",fileName]];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                finish(exportSession.outputURL,fileName);
            } else {
                finish(nil, nil);
            }
        }];
    }
}

#pragma mark ------ SHA1 加密 ------
+ (NSString *)sha1Encrypt:(NSString *)string {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

#pragma mark ------ MD5加密 ------
+ (NSString *)md5Encrypt:(NSString *)string lower:(BOOL)lower {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    if (lower) {
        return [result lowercaseString];
    } else {
        return result;
    }
}

#pragma mark ------ 开锁参数处理 ------
+ (NSString *)handleParamsSign:(NSMutableDictionary *)params {
    NSString *randomStr = [NSString stringWithFormat:@"%08d%08d",arc4random_uniform(10000000),arc4random_uniform(10000000)];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:randomStr forKey:@"seq"];
    
    NSArray *sortArr = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *valueArr = [[NSMutableArray alloc] init];
    for (NSString *key in sortArr) {
        [valueArr addObject:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
    }
    return [self md5Encrypt:[valueArr componentsJoinedByString:@"&"] lower:NO];
}

#pragma mark ------ 锁对应图片 ------
+ (UIImage *)lockImageWithType:(NSString *)type {
    if ([type isEqualToString:@"11"]) {
        return [UIImage imageNamed:@"lock_l0"];
    } else if ([type isEqualToString:@"12"] || [type isEqualToString:@"19"]) {
        return [UIImage imageNamed:@"lock_h10"];
    } else if ([type isEqualToString:@"13"]) {
        return [UIImage imageNamed:@"lock_wfl77"];
    } else if ([type isEqualToString:@"14"]) {
        return [UIImage imageNamed:@"lock_l2"];
    } else if ([type isEqualToString:@"16"]) {
        return [UIImage imageNamed:@"lock_wfl66"];
    } else if ([type isEqualToString:@"17"]) {
        return [UIImage imageNamed:@"lock_wfl99"];
    } else if ([type isEqualToString:@"21"] || [type isEqualToString:@"25"]) {
        return [UIImage imageNamed:@"lock_gateway"];
    } else if ([type isEqualToString:@"24"]) {
        return [UIImage imageNamed:@"icon_airoom_hema"];
    } else if ([type isEqualToString:@"110"]) {
        return [UIImage imageNamed:@"lock_h10c"];
    } else if ([type isEqualToString:@"51"]) {
        return [UIImage imageNamed:@"icon_device_boxoff"];
    } else if ([type isEqualToString:@"41"]) {
        return [UIImage imageNamed:@"icon_device_gason"];
    } else if ([type isEqualToString:@"233"]) {
        return [UIImage imageNamed:@"icon_airoom_gateway2"];
    } else if ([type isEqualToString:@"22"]) {
        return [UIImage imageNamed:@"icon_airoom_l2"];
    } else if ([type isEqualToString:@"24"]) {
        return [UIImage imageNamed:@"icon_airoom_hema"];
    }  else {
        return [UIImage imageNamed:@"lock_other"];
    }
}

#pragma mark ------ 拼接地址 ------
+ (NSString *)splicingPath:(NSString *)path {
    if ([path hasPrefix:@"hotel-around"]) {
        return [NSString stringWithFormat:@"http://testshop.adellock.com:8080/%@",path];
    } else {
        return path;
    }
}

@end
