//
//  ADLDropMenuView.h
//  lockboss
//
//  Created by adel on 2019/8/28.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLDropMenuView : UIView

/**
 快速显示菜单视图，lightMode为yes则为白色视图，否则为黑色视图
 
 @param sView 基准视图
 @param imgNameArray 图片名称数组，可以为空
 @param titleArr 标题数组
 @param lightMode 是否为白色视图
 @param finish 点击返回对应的index
 @return 菜单视图
 */
+ (instancetype)showWithView:(UIView *)sView
                imgNameArray:(NSArray *)imgNameArray
                  titleArray:(NSArray *)titleArr
                   lightMode:(BOOL)lightMode
                      finish:(void(^)(NSInteger index))finish;

/**
 快速显示菜单视图，lightMode为yes则为白色视图，否则为黑色视图
 
 @param sRect 基准Rect
 @param imgNameArray 图片名称数组，可以为空
 @param titleArr 标题数组
 @param lightMode 是否为白色视图
 @param finish 点击返回对应的index
 @return 菜单视图
 */
+ (instancetype)showWithRect:(CGRect)sRect
                imgNameArray:(NSArray *)imgNameArray
                  titleArray:(NSArray *)titleArr
                   lightMode:(BOOL)lightMode
                      finish:(void(^)(NSInteger index))finish;

@end
