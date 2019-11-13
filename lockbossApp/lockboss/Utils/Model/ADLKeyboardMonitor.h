//
//  ADLKeyboardMonitor.h
//  lockboss
//
//  Created by adel on 2019/5/23.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLKeyboardMonitor : NSObject

+ (instancetype)monitor;

///是否可用
@property(nonatomic, assign) BOOL enable;

///键盘和输入视图间距,设置Enable为No后恢复默认间距
@property (nonatomic, assign) CGFloat gap;

///是否显示完成按钮
@property (nonatomic, assign) BOOL showDone;

///工具栏视图
@property (nonatomic, strong) UIView *toolView;

///键盘高度改变
@property (nonatomic, copy) void (^keyboardHeightChanged) (CGFloat keyboardH);

///键盘高度改变
@property (nonatomic, copy) void (^keyboardTransform) (CGFloat keyboardH);

@end
