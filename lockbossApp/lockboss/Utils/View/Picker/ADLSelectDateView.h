//
//  ADLSelectDateView.h
//  lockboss
//
//  Created by adel on 2019/6/12.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSelectDateView : UIView

/**
 选择日期

 @param title 标题
 @param period 是否是时间段
 @param longterm 是否显示长期,选择时间段才有效（period=YES）
 @param posterior 是否要晚于当前时间
 @param finish 完成的回调
 @return 日期选择器
 */
+ (instancetype)showWithTitle:(NSString *)title
                       period:(BOOL)period
                     longterm:(BOOL)longterm
                    posterior:(BOOL)posterior
                       finish:(void(^)(NSString *dateStr))finish;

@end
