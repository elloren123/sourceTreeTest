//
//  ADLToastView.h
//  lockboss
//
//  Created by adel on 2019/3/20.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ADLToastType) {
    ADLToastTypeText,
    ADLToastTypeLoading
};

@interface ADLToastView : UIView

///快速初始化
+ (instancetype)toastViewWithLightMode:(BOOL)lightMode;

///弹窗 ContentView
@property (nonatomic, strong) UIView *contentView;

///显示内容
@property (nonatomic, strong) NSString *contentText;

///弹窗类型
@property (nonatomic, assign) ADLToastType type;

///距底部距离
@property (nonatomic, assign) CGFloat bottomGap;

///显示弹窗
- (void)show;

///隐藏弹窗
- (void)hide;

@end
