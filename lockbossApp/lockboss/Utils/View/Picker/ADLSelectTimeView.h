//
//  ADLSelectTimeView.h
//  lockboss
//
//  Created by Adel on 2019/9/12.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSelectTimeView : UIView

/**
 选择时间

 @param title 标题
 @param period 是否是时间段
 @param posterior 选择的时间是否要大于当前时间
 @param finish 完成的回调
 @return 时间选择器
 */
+ (instancetype)showWithTitle:(NSString *)title period:(BOOL)period posterior:(BOOL)posterior finish:(void(^)(NSString *dateStr))finish;

@end
