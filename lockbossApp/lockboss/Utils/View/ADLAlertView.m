//
//  ADLAlertView.m
//  lockboss
//
//  Created by adel on 2019/4/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLAlertView.h"
#import "ADLLocalizedHelper.h"

@interface ADLAlertView ()
@property (nonatomic, copy) void (^confirmAction) (void);
@property (nonatomic, copy) void (^cancleAction) (void);
@end

@implementation ADLAlertView

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(void (^)(void))confirmAction cancleTitle:(NSString *)cancleTitle cancleAction:(void (^)(void))cancleAction showCancle:(BOOL)showCancle {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds title:title message:message confirmTitle:confirmTitle confirmAction:confirmAction cancleTitle:cancleTitle cancleAction:cancleAction showCancle:showCancle];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(void (^)(void))confirmAction cancleTitle:(NSString *)cancleTitle cancleAction:(void (^)(void))cancleAction showCancle:(BOOL)showCancle {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.tag = 19;
        self.cancleAction = cancleAction;
        self.confirmAction = confirmAction;
        [self initializationWithTitle:title message:message confirmTitle:confirmTitle cancleTitle:cancleTitle showCancle:showCancle];
    }
    return self;
}

#pragma mark ------ 初始化 ------
- (void)initializationWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancleTitle:(NSString *)cancleTitle showCancle:(BOOL)showCancle {
    if (title == nil && message == nil) return;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat alp = 0.5;
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [self addSubview:coverView];
    if ([window viewWithTag:19] != nil) {
        alp = 0.2;
    }
    
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 12;
    alertView.clipsToBounds = YES;
    [self addSubview:alertView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    titleLab.text = title;
    [alertView addSubview:titleLab];
    
    UILabel *msgLab = [[UILabel alloc] init];
    msgLab.textColor = [UIColor blackColor];
    msgLab.font = [UIFont systemFontOfSize:14];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.numberOfLines = 0;
    msgLab.text = message;
    [alertView addSubview:msgLab];
    
    CGFloat titleH = 0;
    CGFloat messageH = 0;
    if (title.length > 0) {
        titleH = [title boundingRectWithSize:CGSizeMake(238, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    }
    if (message.length > 0) {
        messageH = [message boundingRectWithSize:CGSizeMake(238, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    }
    
    CGFloat gap = 30;
    if (titleH == 0 || messageH == 0) gap = 20;
    CGFloat alertH = titleH+messageH+65+gap;
    CGFloat alertMaxH = screenH-200;
    if (alertH > alertMaxH) alertH = alertMaxH;
    
    titleLab.frame = CGRectMake(16, 20, 238, titleH);
    msgLab.frame = CGRectMake(16, titleH+gap, 238, messageH);
    alertView.frame = CGRectMake((screenW-270)/2, (screenH-alertH)/2, 270, alertH);
    alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    UIView *lineHView = [[UIView alloc] initWithFrame:CGRectMake(0, alertH-45, 270, 0.5)];
    lineHView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [alertView addSubview:lineHView];
    
    if (confirmTitle == nil) confirmTitle = ADLString(@"confirm");
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    confirmBtn.titleLabel.minimumScaleFactor = 0.7;
    confirmBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [confirmBtn setTitleColor:[UIColor colorWithRed:0 green:131/255.0 blue:253/255.0 alpha:1] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:confirmBtn];
    
    if (showCancle) {
        confirmBtn.frame = CGRectMake(136, alertH-44, 134, 44);
        
        if (cancleTitle == nil) cancleTitle = ADLString(@"cancle");
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancleBtn.frame = CGRectMake(0, alertH-44, 134, 44);
        [cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor colorWithRed:0 green:131/255.0 blue:253/255.0 alpha:1] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:cancleBtn];
        
        UIView *lineVView = [[UIView alloc] initWithFrame:CGRectMake(135, alertH-45, 0.5, 45)];
        lineVView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [alertView addSubview:lineVView];
    } else {
        confirmBtn.frame = CGRectMake(0, alertH-44, 270, 44);
    }
    
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        coverView.alpha = alp;
        alertView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark ------ 取消 ------
- (void)clickCancleBtn {
    [self removeFromSuperview];
    if (self.cancleAction) {
        self.cancleAction();
    }
}

#pragma mark ------ 确定 ------
- (void)clickConfirmBtn {
    [self removeFromSuperview];
    if (self.confirmAction) {
        self.confirmAction();
    }
}

@end
