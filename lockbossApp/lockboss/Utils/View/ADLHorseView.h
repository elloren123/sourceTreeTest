//
//  ADLHorseView.h
//  lockboss
//
//  Created by adel on 2019/3/21.
//  Copyright © 2019年 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLHorseView : UIView

///快速初始化
+ (instancetype)horseViewWithFrame:(CGRect)frame image:(UIImage *)image timeInterval:(NSTimeInterval)timeInterval;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image timeInterval:(NSTimeInterval)timeInterval;

///轮播内容数组
@property (nonatomic, strong) NSMutableArray<NSString *> *contentArr;

///点击事件
@property (nonatomic, copy) void (^clickHorseView) (NSInteger index);

///左边图片
@property (nonatomic, strong) UIImage *image;

///图片大小
@property (nonatomic, assign) CGSize imgSize;

///背景颜色
@property (nonatomic, strong) UIColor *bgColor;

///文字颜色
@property (nonatomic, strong) UIColor *textColor;

///字体大小
@property (nonatomic, strong) UIFont *textFont;

///定时器
@property (nonatomic, strong) NSTimer *timer;

@end
