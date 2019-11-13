//
//  ADLUtils.h
//  lockboss
//
//  Created by adel on 2019/3/26.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    NSString *duration;
    UIImage *thumbnail;
} VideoInfo;

typedef struct {
    NSString *cityId;
    NSString *address;
} AddressInfo;

typedef NS_ENUM(NSInteger, ADLLocationStatus) {
    ADLLocationStatusAllow,
    ADLLocationStatusDenied,
    ADLLocationStatusUnavailable
};

typedef NS_ENUM(NSInteger, ADLCameraStatus) {
    ADLCameraStatusAllow,
    ADLCameraStatusDenied,
    ADLCameraStatusUnavailable
};

@interface ADLUtils : NSObject

///获取定位权限状态
+ (ADLLocationStatus)getLocationStatus;

///获取相机权限
+ (ADLCameraStatus)getCameraStatus;

///压缩图片
+ (NSData *)compressImageQuality:(UIImage *)image maxLength:(NSInteger)maxLength;

///处理密文重新输入清空和明密文切换光标位置不对问题
+ (void)dealWithSecureEntryWithTextField:(UITextField *)textField;

///验证邮箱
+ (BOOL)verifyEmailAddress:(NSString *)email;

///是否是纯数字
+ (BOOL)isPureInt:(NSString *)string;

///限制输入长度
+ (BOOL)limitedTextField:(UITextField *)textField replacementString:(NSString *)string maxLength:(NSInteger)length;

///数字输入
+ (BOOL)numberTextField:(UITextField *)textField replacementString:(NSString *)string maxLength:(NSInteger)length firstZero:(BOOL)zero;

///电话输入
+ (BOOL)phoneTextField:(UITextField *)textField replacementString:(NSString *)string;

///获取当前显示的控制器
+ (UIViewController *)getCurrentViewController;

///保存数据 NSUserDefaults
+ (void)saveValue:(id)value forKey:(NSString *)key;

///取出数据 NSUserDefaults
+ (id)valueForKey:(NSString *)key;

///保存数据对象到本地,permanent是否是永久的，永久的清理缓存不会被清理掉
+ (BOOL)saveObject:(id)object fileName:(NSString *)fileName permanent:(BOOL)permanent;

///删除本地保存的数据对象，permanent与保存时一致
+ (void)removeObjectWithFileName:(NSString *)fileName permanent:(BOOL)permanent;

///获取文件路径,如果存在则返回文件地址，不存在返回nil
+ (NSString *)filePathWithName:(NSString *)fileName permanent:(BOOL)permanent;

///删除所有本地保存的数据对象
+ (void)removeAllCache;

///字典数组转简单数组
+ (NSMutableArray *)dictArrayToArray:(NSArray *)array key:(NSString *)key;

///根据地区ID查询父ID、地址
+ (AddressInfo)queryAddressWithDataArr:(NSArray *)dataArr areaId:(NSString *)areaId;

///处理字典数组里面空值
+ (NSMutableArray *)dealwithNullDictArr:(NSArray *)arr;

///计算字符串字符长度
+ (NSInteger)calculateCharacterLength:(NSString *)str;

///计算文字宽高
+ (CGSize)calculateString:(NSString *)string rectSize:(CGSize)rectSize fontSize:(CGFloat)fontSize;

///计算富文本宽高
+ (CGSize)calculateAttributeString:(NSAttributedString *)attributeString rectSize:(CGSize)rectSize;

///创建WKWebView
+ (id)webViewWithFrame:(CGRect)frame scale:(BOOL)scale;

/// 获取n分钟后的时间戳，精确到毫秒
+ (NSString *)timestampWithMinuteDelay:(NSInteger)minute;

/// 获取n分钟后的时间
+ (NSString *)dateWithMinuteDelay:(NSInteger)minute format:(NSString *)format;

/// 获取n月后的时间
+ (NSString *)dateWithMonthDelay:(NSInteger)month format:(NSString *)format;

/// 时间转时间戳，精确到毫秒,date为nil 则为当前时间，format可为nil
+ (NSString *)timestampWithDate:(NSDate *)date format:(NSString *)format;

/// 时间字符串转时间戳，精确到毫秒
+ (NSString *)timestampWithDateStr:(NSString *)dateStr format:(NSString *)format;

/// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateFromTimestamp:(double)timestamp format:(NSString *)format;

// 获取当前时间       str格式 YYYY-MM-dd HH:mm:ss
+ (NSString *)getCurrentTime:(NSString *)str;
/**
 *返回天数
 *yyyy-MM-dd HH:mm:ss"
 *开始时间 beginDate
 *结束时间 endDate
 */
+ (NSInteger)fateDifferenceWithStartTime:(NSDate *)beginDate endTime:(NSDate *)endDate;
///获取两个时间戳之间的秒数，endTimestamp为0则取当前时间戳
+ (NSInteger)getSecondFromStartTimestamp:(double)startTime endTimestamp:(double)endTime;

///计算时间戳距现在的时间差
+ (void)calculateDateInterval:(NSTimeInterval)timestamp includeDay:(BOOL)includeDay finish:(void (^)(NSString *day, NSString *hour, NSString *minute, NSString *second))finish;

///设置星级图片
+ (UIImage *)getStarImageWithCount:(NSInteger)count;

///设置文件类型图片
+ (UIImage *)getFileTypeImageWithType:(NSString *)type;

///sku提取属性
+ (NSArray *)skuArrToAttributeArr:(NSArray *)skuArr;

///当弹出键盘时，视图坐标转换
+ (CGFloat)convertRectWithView:(UIView *)inputView;

///获取当前显示的控制器
- (UIViewController *)getCurrentViewController;

///完全Copy对象
+ (id)realDeepCopyWithObject:(id)object;

///是否有表情
+ (BOOL)hasEmoji:(NSString *)string;

///获取视频信息,网络地址和本地地址传一个就可以，都传的话默认为网络地址（videoUrl），此操作为耗时操作
+ (VideoInfo)getVideoInfoWithUrlStr:(NSString *)videoUrl orPathUrl:(NSURL *)localUrl;

///视频转MP4
+ (void)convertVideoToMp4FromURL:(NSURL *)videoUrl finish:(void(^)(NSURL *fileUrl, NSString *fileName))finish;

///SHA1加密
+ (NSString *)sha1Encrypt:(NSString *)string;

///MD5加密
+ (NSString *)md5Encrypt:(NSString *)string lower:(BOOL)lower;

///开锁参数处理
+ (NSString *)handleParamsSign:(NSMutableDictionary *)params;

///锁类型对应图片
+ (UIImage *)lockImageWithType:(NSString *)type;

///拼接请求地址
+ (NSString *)splicingPath:(NSString *)path;

@end
