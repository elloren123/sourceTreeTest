//
//  ADLSelectMonthView.h
//  lockboss
//
//  Created by Adel on 2019/9/16.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSelectMonthView : UIView

/**
 选择月份

 @param title 标题
 @param period 是否是时间段
 @param selectTime 默认选择的时间，格式为yyyy-MM,不传则选择当前时间，时间段的话，两个日期中间用,分开
 @param finish 完成的回调
 @return 月份选择器
 */
+ (instancetype)showWithTitle:(NSString *)title period:(BOOL)period selectTime:(NSString *)selectTime finish:(void(^)(NSString *dateStr))finish;

@end
