//
//  ADLProgressView.h
//  lockboss
//
//  Created by Adel on 2019/9/17.
//  Copyright © 2019 adel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADLProgressViewType) {
    ADLProgressViewTypeHorizontal,
    ADLProgressViewTypeVertical
};

@interface ADLProgressView : UIView

+ (instancetype)progressViewWithFrame:(CGRect)frame type:(ADLProgressViewType)type;

- (instancetype)initWithFrame:(CGRect)frame type:(ADLProgressViewType)type;

///设置进度
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

///进度
@property (nonatomic, assign) CGFloat progress;

///进度颜色
@property (nonatomic, strong) UIColor *progressColor;

///背景颜色
@property (nonatomic, strong) UIColor *trackColor;

@end
