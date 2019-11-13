//
//  ADLAlertView.h
//  lockboss
//
//  Created by adel on 2019/4/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLAlertView : UIView

/**
 仿系统弹窗

 @param title 标题
 @param message 内容
 @param confirmTitle 确认按钮标题，默认为确定，可以传nil
 @param confirmAction 点击确定按钮执行的Block
 @param cancleTitle 取消按钮标题，默认为取消，可以传nil
 @param cancleAction 点击取消按钮执行的Block
 @param showCancle 是否显示取消按钮
 @return Alert
 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                 confirmTitle:(NSString *)confirmTitle
                confirmAction:(void (^)(void))confirmAction
                  cancleTitle:(NSString *)cancleTitle
                 cancleAction:(void (^)(void))cancleAction
                   showCancle:(BOOL)showCancle;

@end
