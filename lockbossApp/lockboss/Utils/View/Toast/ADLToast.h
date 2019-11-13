//
//  ADLToast.h
//  lockboss
//
//  Created by adel on 2019/3/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLToast : NSObject

+ (instancetype)sharedToast;

///文字弹窗
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(double)duration;
+ (void)showMessage:(NSString *)message lightMode:(BOOL)lightMode;

///底部文字弹窗
+ (void)showBottomMessage:(NSString *)message;
+ (void)showBottomMessage:(NSString *)message lightMode:(BOOL)lightMode;
+ (void)showBottomMessage:(NSString *)message duration:(double)duration bottomGap:(CGFloat)bottomGap;

///加载动画文字弹窗
+ (void)showLoadingMessage:(NSString *)message;
+ (void)showLoadingMessage:(NSString *)message lightMode:(BOOL)lightMode;

///是否正在显示加载视图
+ (BOOL)isShowLoading;

///隐藏弹窗
+ (void)hide;

@end
