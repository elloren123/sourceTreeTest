//
//  ADLSwitch.h
//  lockboss
//
//  Created by Adel on 2019/11/8.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLSwitch : UIView

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

///添加点击事件
- (void)addTarget:(id)target action:(SEL)action;

///打开颜色
@property (nonatomic, strong) UIColor *openColor;

///关闭颜色
@property (nonatomic, strong) UIColor *closeColor;

///圆圈颜色
@property (nonatomic, strong) UIColor *roundColor;

///状态,默认Yes，不带动画
@property (nonatomic, assign) BOOL open;

///状态,默认Yes，带动画
@property (nonatomic, assign) BOOL on;

@end
