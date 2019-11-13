//
//  ADLToast.m
//  lockboss
//
//  Created by adel on 2019/3/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLToast.h"
#import "ADLToastView.h"

@interface ADLToast ()
@property (nonatomic, strong) ADLToastView *toastView;
@property (nonatomic, strong) NSTimer *timer;
@end

#define DEFAULT_DURATION 2

@implementation ADLToast

///单例
+ (instancetype)sharedToast {
    static ADLToast *toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[ADLToast alloc] init];
    });
    return toast;
}

///文字弹窗
+ (void)showMessage:(NSString *)message {
    [self showMessage:message duration:DEFAULT_DURATION];
}

+ (void)showMessage:(NSString *)message duration:(double)duration {
    [[self sharedToast] showMessage:message duration:duration type:ADLToastTypeText bottomGap:0 lightMode:NO];
}

+ (void)showMessage:(NSString *)message lightMode:(BOOL)lightMode {
    [[self sharedToast] showMessage:message duration:DEFAULT_DURATION type:ADLToastTypeText bottomGap:0 lightMode:lightMode];
}

///底部文字弹窗
+ (void)showBottomMessage:(NSString *)message {
    [self showBottomMessage:message duration:DEFAULT_DURATION bottomGap:119];
}

+ (void)showBottomMessage:(NSString *)message lightMode:(BOOL)lightMode {
    [[self sharedToast] showMessage:message duration:DEFAULT_DURATION type:ADLToastTypeText bottomGap:119 lightMode:lightMode];
}

+ (void)showBottomMessage:(NSString *)message duration:(double)duration bottomGap:(CGFloat)bottomGap {
    [[self sharedToast] showMessage:message duration:duration type:ADLToastTypeText bottomGap:bottomGap lightMode:NO];
}

///加载动画文字弹窗
+ (void)showLoadingMessage:(NSString *)message {
    [[self sharedToast] showMessage:message duration:999 type:ADLToastTypeLoading bottomGap:0 lightMode:NO];
}

+ (void)showLoadingMessage:(NSString *)message lightMode:(BOOL)lightMode {
    [[self sharedToast] showMessage:message duration:999 type:ADLToastTypeLoading bottomGap:0 lightMode:lightMode];
}

///显示弹窗
- (void)showMessage:(NSString *)message duration:(double)duration type:(ADLToastType)type bottomGap:(CGFloat)bottomGap lightMode:(BOOL)lightMode {
    if (message == nil) {
        return;
    }
    if (self.toastView == nil) {
        self.toastView = [ADLToastView toastViewWithLightMode:lightMode];
    }
    self.toastView.bottomGap = bottomGap;
    self.toastView.type = type;
    
    BOOL needShow = YES;
    if (_toastView.type == ADLToastTypeText && [_toastView.contentText isEqualToString:message]) {
        needShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.toastView.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.toastView.contentView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    if (needShow) {
        if ([[NSThread currentThread] isMainThread]) {
            self.toastView.contentText = message;
            [self.toastView show];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.toastView.contentText = message;
                [self.toastView show];
            });
        }
    }
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark ------ 是否正在显示Loading ------
+ (BOOL)isShowLoading {
    return [[self sharedToast] isShowing];
}

- (BOOL)isShowing {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL show = [self.toastView isDescendantOfView:window];
    if (show && self.toastView.type == ADLToastTypeLoading) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark ------ 隐藏弹窗 ------
+ (void)hide {
    [[self sharedToast] hideToast];
}

#pragma mark ------ 移除Toast ------
- (void)hideToast {
    [self.timer invalidate];
    [self.toastView hide];
    self.toastView = nil;
    self.timer = nil;
}

@end
